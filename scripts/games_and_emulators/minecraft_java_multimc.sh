#!/bin/bash
# NOTE: This build is NOT a fork BUT it does use a custom native library repo for the arm64 builds, which is necessary as microsoft and the multimc5 devs do not provide arm64 native libraries

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
# clone the complete source
git clone --recursive https://github.com/MultiMC/MultiMC5.git src # You can clone from MultiMC's main repo, no need to use a fork.
cd src
git pull --recurse-submodules

# add secrets files
mkdir -p secrets
tee secrets/Secrets.h <<'EOF'
#include <QString>

namespace Secrets {
    QString getMSAClientID(char data_in){
        return "0d742867-f14f-4ad9-9d0b-13692c38dc3a";
    }
}
EOF
tee secrets/CMakeLists.txt <<'EOF'
add_library(secrets STATIC
    Secrets.h
)

target_link_libraries(secrets Qt5::Core)
target_include_directories(secrets PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
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
    "aarch64") cmake -DCMAKE_CXX_FLAGS="-DEMBED_SECRETS=TRUE" -DMultiMC_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-8-openjdk-arm64' -DMultiMC_BUILD_PLATFORM="$model_name" -DMultiMC_BUG_TRACKER_URL="https://github.com/MultiMC/MultiMC5/issues" -DMultiMC_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DMultiMC_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install -DMultiMC_META_URL:STRING="https://raw.githubusercontent.com/theofficialgman/meta-multimc/master/index.json" ../src ;;
    "x86_64") cmake -DCMAKE_CXX_FLAGS="-DEMBED_SECRETS=TRUE" -DMultiMC_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64' -DMultiMC_BUG_TRACKER_URL="https://github.com/MultiMC/MultiMC5/issues" -DMultiMC_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DMultiMC_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install ../src ;;
    "i386") cmake -DCMAKE_CXX_FLAGS="-DEMBED_SECRETS=TRUE" -DMultiMC_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-8-openjdk-i386' -DMultiMC_BUG_TRACKER_URL="https://github.com/MultiMC/MultiMC5/issues" -DMultiMC_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DMultiMC_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install ../src ;;
    *) echo "Error: your cpu architecture ($architecture) is not supporeted by MultiMC and will fail to compile"; rm -rf ~/MultiMC; echo ""; echo "Exiting the script"; sleep 3; exit $? ;;
esac

# build & install (use -j with the number of cores your CPU has)
make -j$(nproc) install
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
