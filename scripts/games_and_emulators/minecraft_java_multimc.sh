#!/bin/bash
# NOTE: This build is NOT a fork BUT it does use a custom native library repo for the arm64 builds, which is necessary as microsoft and the multimc5 devs do not provide arm64 native libraries

# obtain the cpu info
get_system
case "$architecture" in
    "aarch64"|"x86_64"|"i386") ;;
    *) echo "Error: your cpu architecture ($architecture) is not supporeted by MultiMC and will fail to compile"; echo ""; echo "Exiting the script"; sleep 3; exit $? ;;
esac

if grep -E 'bionic|focal|groovy' /etc/os-release > /dev/null; then
    ppa_added=$(grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep openjdk-r | wc -l)
    if [[ $ppa_added -eq "1" ]]; then
        echo "Skipping OpenJDK PPA, already added"
    else
        echo "Adding OpenJDK PPA, needed for Minecraft 1.17+"
        ppa_name="openjdk-r/ppa" && ppa_installer
    fi
fi
sudo apt install cmake curl zlib1g-dev openjdk-8-jdk openjdk-11-jre openjdk-16-jre qtbase5-dev -y
# make all the folders
cd
mkdir -p ~/MultiMC
cd ~/MultiMC
mkdir -p build
mkdir -p install
mkdir -p scripts

# install modmanager python script
if grep -E 'bionic' /etc/os-release > /dev/null; then
    python_version="python3.8"
else
    python_version="python3"
fi
sudo apt install $python_version python3-pip jq -y
hash -r
$python_version -m pip install --upgrade pip setuptools wheel minecraft-mod-manager
unset python_version

# creating mod updater script
tee scripts/pre-launch.sh <<'EOF' >>/dev/null
#!/bin/bash
# Download and install Mods compatible with minecraft version

wget -q --spider https://github.com && wget -q --spider https://raw.githubusercontent.com/

# only run update/install script if the user has an active internet connection
if [ $? == 0 ]
then
    cd "$INST_DIR"
    mc_version=$(jq -M -r '.components[] | "\(.uid)/\(.version)"' mmc-pack.json | sed -n -e 's/^.*net.minecraft\///p')
    mkdir -p .minecraft
    cd .minecraft
    mkdir -p mods
    mkdir -p config
    echo "Downloading latest gamecontrollerdb.txt"
    wget "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt" -O ./config/gamecontrollerdb_temp.txt && rm -rf ./config/gamecontrollerdb.txt && mv ./config/gamecontrollerdb_temp.txt ./config/gamecontrollerdb.txt
    echo "Patching gamecontrollerdb.txt for combined joycons to work around bug in lwjgl3"
    echo "060000004e696e74656e646f20537700,Nintendo Combined Joy-Cons 2 (joycond),a:b0,b:b1,back:b9,dpdown:b15,dpleft:b16,dpright:b17,dpup:b14,leftshoulder:b5,leftstick:b12,lefttrigger:b7,leftx:a0,lefty:a1,rightshoulder:b6,rightstick:b13,righttrigger:b8,rightx:a2,righty:a3,start:b10,x:b3,y:b2,platform:Linux," >> ./config/gamecontrollerdb.txt
    cd mods
    megascript_mods=$(sed -n "p" <"/home/$USER/MultiMC/scripts/megascript-mods.txt")
    user_mods=$(sed -n "p" <"/home/$USER/MultiMC/scripts/user-mods.txt")
    minecraft-mod-manager -v "$mc_version" --beta --alpha install $megascript_mods $user_mods
fi
echo "Mod script finished or skipped"
EOF

chmod +x scripts/pre-launch.sh

# fabric mods installed by default
# mods are disabled by default until the user uses the "Install Fabric" button in MultiMC
echo "Setting list of mods installed by the megascript by default"
echo "Make sure to click the Install Fabric button within MultiMC to enable these mods"
echo ""
tee scripts/megascript-mods.txt <<'EOF'
sodium
lithium
phosphor
hydrogen
lambdacontrols
fabric-api
EOF

# clone the complete source
git clone --recursive https://github.com/MultiMC/MultiMC5.git src # You can clone from MultiMC's main repo, no need to use a fork.
cd src
git pull --recurse-submodules

# add secrets files
mkdir -p secrets
tee secrets/Secrets.h <<'EOF' >>/dev/null
#pragma once
#include <QString>
#include <cstdint>

namespace Secrets {
bool hasMSAClientID();
QString getMSAClientID(uint8_t separator);
}
EOF

tee secrets/Secrets.cpp <<'EOF' >>/dev/null
#include "Secrets.h"

#include <array>
#include <cstdio>

namespace Secrets {
bool hasMSAClientID() {
    return true;
}

QString getMSAClientID(uint8_t separator) {
    return "41b2c9ae-45a2-4d9c-936a-38faa15d3845";
}
}
EOF

tee secrets/CMakeLists.txt <<'EOF' >>/dev/null
add_library(secrets STATIC Secrets.cpp Secrets.h)
target_link_libraries(secrets Qt5::Core)
target_compile_definitions(secrets PUBLIC -DEMBED_SECRETS)
target_include_directories(secrets PUBLIC .)

EOF

cd ..
# configure the project
cd build
# obtain the cpu info
get_system
# temporary hotfix to build with java 11 (build currently fails on java 16 autodetection)
# https://github.com/MultiMC/MultiMC5/issues/3949
# remove cmake cache until bug is fixed
rm -rf CMakeCache.txt
case "$architecture" in
    "aarch64") cmake -DMultiMC_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-8-openjdk-arm64' -DMultiMC_BUILD_PLATFORM="$model" -DMultiMC_BUG_TRACKER_URL="https://github.com/MultiMC/MultiMC5/issues" -DMultiMC_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DMultiMC_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install -DMultiMC_META_URL:STRING="https://raw.githubusercontent.com/theofficialgman/meta-multimc/master-clean/index.json" ../src ;;
    "x86_64") cmake -DMultiMC_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64' -DMultiMC_BUG_TRACKER_URL="https://github.com/MultiMC/MultiMC5/issues" -DMultiMC_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DMultiMC_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install ../src ;;
    "i386") cmake -DMultiMC_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-8-openjdk-i386' -DMultiMC_BUG_TRACKER_URL="https://github.com/MultiMC/MultiMC5/issues" -DMultiMC_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DMultiMC_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install ../src ;;
esac

# build & install (use -j with the number of cores your CPU has)
make -j$(nproc) install

# enable pre-launch script
cd ..
if cat install/multimc.cfg | grep -q "PreLaunchCommand="; then
    sed -i "s/PreLaunchCommand=.*/PreLaunchCommand=\/home\/$USER\/MultiMC\/scripts\/pre-launch.sh/" install/multimc.cfg
else
    echo "PreLaunchCommand=/home/$USER/MultiMC/scripts/pre-launch.sh" >> install/multimc.cfg
fi

cd
sudo sh -c "cat > /usr/local/share/applications/MultiMC.desktop << _EOF_
[Desktop Entry]
Type=Application
Exec=/home/$USER/MultiMC/install/MultiMC
Hidden=false
NoDisplay=false
Name=MutiMC
Icon=/home/$USER/MultiMC/src/launcher/resources/multimc/scalable/multimc.svg
Categories=Game
_EOF_"
