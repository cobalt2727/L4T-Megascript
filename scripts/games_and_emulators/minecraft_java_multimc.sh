#!/bin/bash
# NOTE: This build is NOT a fork BUT it does use a custom native library repo for the arm64 builds, which is necessary as microsoft and the multimc5 devs do not provide arm64 native libraries

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}


# adapted/inspired from retropie setup script system.sh https://github.com/RetroPie/RetroPie-Setup/blob/master/scriptmodules/system.sh
# armbian uses a minimal shell script replacement for lsb_release with basic
# parameter parsing that requires the arguments split rather than using -sidrc
mapfile -t os < <(lsb_release -s -i -d -r -c)
__os_id="${os[0]}"
__os_desc="${os[1]}"
__os_release="${os[2]}"
__os_codename="${os[3]}"

# obtain the cpu info
get_system
case "$dpkg_architecture" in
    "arm64"|"amd64"|"i386"|"armhf") ;;
    *) error "Error: your cpu architecture ($dpkg_architecture) is not supporeted by MultiMC and will fail to compile" ;;
esac

status "Installing Necessary Dependencies"
case "$__os_id" in
    Raspbian|Debian)
        case "$__os_codename" in
            bullseye|buster|stretch|jessie)
                sudo apt install wget apt-transport-https gnupg -y || error "Could not install dependencies"
                hash -r
                cd /tmp
                rm -rf public
                rm -rf adoptopenjdk-keyring.gpg
                wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
                gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import public
                gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg 
                rm -rf public
                rm -rf adoptopenjdk-keyring.gpg
                sudo mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings
                cd ~
                echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb $__os_codename main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list
                sudo apt update
                ;;
            *)
                error "Debian version ($__os_codename) is too old, update to debian Jessie or newer"
                ;;
        esac
        # install dependencies
        # for now don't install openjdk-8-jre on debian based 32bit installs... the repo versions (from adoptopenjdk and raspbian) are broken and don't work
        # refer to the below bug reports for updates
        # https://bugs.launchpad.net/raspbian/+bug/1944774
        # https://github.com/adoptium/adoptium-support/issues/368

        # download java 8 from adoptium github tar.gz as a workaround
        case  "$dpkg_architecture" in
            "amd64"|"i386")
                sudo apt install libopenal1 x11-xserver-utils subversion git clang gcc g++ cmake curl zlib1g-dev adoptopenjdk-8-hotspot-jre openjdk-11-jdk adoptopenjdk-16-hotspot-jre qtbase5-dev -y || error "Could not install dependencies"
                hash -r
                ;;
            "arm64")
                sudo apt install build-essential libopenal1 x11-xserver-utils subversion git clang cmake curl zlib1g-dev openjdk-11-jdk adoptopenjdk-16-hotspot-jre qtbase5-dev -y || error "Could not install dependencies"
                hash -r
                mkdir -p ~/MultiMC/install/java || exit 1
                cd ~/MultiMC/install/java || exit 1
                # download java 8 (unavailable in some debian versions)
                rm -rf jdk8u302-b08
                rm -rf java-8-temurin-aarch64
                rm -rf OpenJDK8U-jdk_aarch64_linux_hotspot_8u302b08.tar.gz
                wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u302-b08/OpenJDK8U-jdk_aarch64_linux_hotspot_8u302b08.tar.gz && tar -xzf OpenJDK8U-jdk_aarch64_linux_hotspot_8u302b08.tar.gz
                mv jdk8u302-b08 java-8-temurin-aarch64
                rm -rf OpenJDK8U-jdk_aarch64_linux_hotspot_8u302b08.tar.gz
                # check if java is working and remove if broken
                ./java-8-temurin-aarch64/bin/java -version || ( warning "The downloaded java 8 version does not work, removing it now..." && warning "It is up to you to download and install a working java 8 version." && echo "" && warning "Continuing the MultiMC5 Install without Java 8" && rm -rf java-8-temurin-aarch64 )

                # download java 17 (unavailable in some debian versions)
                rm -rf jdk-17.0.1+12
                rm -rf java-17-temurin-aarch64
                rm -rf OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.1_12.tar.gz
                wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.1_12.tar.gz && tar -xzf OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.1_12.tar.gz
                mv jdk-17.0.1+12 java-17-temurin-aarch64
                rm -rf OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.1_12.tar.gz
                # check if java is working and remove if broken
                ./java-17-temurin-aarch64/bin/java -version || ( warning "The downloaded java 17 version does not work, removing it now..." && warning "It is up to you to download and install a working java 17 version." && echo "" && warning "Continuing the MultiMC5 Install without Java 17" && rm -rf java-17-temurin-aarch64 )
                cd ~
                ;;
            "armhf")
                sudo apt install build-essential libopenal1 x11-xserver-utils subversion git clang cmake curl zlib1g-dev openjdk-11-jdk adoptopenjdk-16-hotspot-jre qtbase5-dev -y || error "Could not install dependencies"
                hash -r
                mkdir -p ~/MultiMC/install/java || exit 1
                cd ~/MultiMC/install/java || exit 1
                # download java 8 (unavailable or broken in some debian versions)
                rm -rf jdk8u302-b08-aarch32-20210726
                rm -rf java-8-temurin-armhf
                rm -rf OpenJDK8U-jdk_arm_linux_hotspot_8u302b08.tar.gz
                wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u302-b08/OpenJDK8U-jdk_arm_linux_hotspot_8u302b08.tar.gz && tar -xzf OpenJDK8U-jdk_arm_linux_hotspot_8u302b08.tar.gz
                mv jdk8u302-b08-aarch32-20210726 java-8-temurin-armhf
                rm -rf OpenJDK8U-jdk_arm_linux_hotspot_8u302b08.tar.gz
                # check if java is working and remove if broken
                ./java-8-temurin-armhf/bin/java -version || ( warning "The downloaded java 8 version does not work, removing it now..." && warning "It is up to you to download and install a working java 8 version." && echo "" && warning "Continuing the MultiMC5 Install without Java 8" && rm -rf java-8-temurin-armhf )

                # download java 17 (unavailable in some debian versions)
                rm -rf jdk-17.0.1+12
                rm -rf java-17-temurin-armhf
                rm -rf OpenJDK17U-jdk_arm_linux_hotspot_17.0.1_12.tar.gz
                wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_arm_linux_hotspot_17.0.1_12.tar.gz && tar -xzf OpenJDK17U-jdk_arm_linux_hotspot_17.0.1_12.tar.gz
                mv jdk-17.0.1+12 java-17-temurin-armhf
                rm -rf OpenJDK17U-jdk_arm_linux_hotspot_17.0.1_12.tar.gz
                # check if java is working and remove if broken
                ./java-17-temurin-armhf/bin/java -version || ( warning "The downloaded java 17 version does not work, removing it now..." && warning "It is up to you to download and install a working java 17 version." && echo "" && warning "Continuing the MultiMC5 Install without Java 17" && rm -rf java-17-temurin-armhf )

                cd ~
                ;;
            *) error "Failed to detect OS CPU architecture! Something is very wrong." ;;
        esac
        ;;
    LinuxMint|Linuxmint|Ubuntu|[Nn]eon|Pop|Zorin|[eE]lementary|[jJ]ing[Oo][sS])
        # get the $DISTRIB_RELEASE and $DISTRIB_CODENAME first from lsb-release (for ubuntu) and then from the upstream for derivatives
        source /etc/lsb-release
        source /etc/upstream-release/lsb-release
        case "$DISTRIB_CODENAME" in
            bionic|focal|groovy)
                ppa_added=$(grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep openjdk-r | wc -l)
                if [[ $ppa_added -eq "1" ]]; then
                    status "Skipping OpenJDK PPA, already added"
                else
                    status "Adding OpenJDK PPA, needed for Minecraft 1.17+"
                    ppa_name="openjdk-r/ppa" && ppa_installer
                fi
                ;;
            *)
                requiredver="18.04"
                if printf '%s\n' "$requiredver" "$DISTRIB_RELEASE" | sort -CV; then
                    status "Skipping OpenJDK PPA, $DISTRIB_CODENAME already has openjdk-16 in the default repositories"
                else
                    error "$DISTRIB_CODENAME appears to be too old to run/compile MultiMC5"
                fi
                ;;

        esac
        # install dependencies
        sudo apt install build-essential libopenal1 x11-xserver-utils git clang cmake curl zlib1g-dev openjdk-8-jre openjdk-17-jre openjdk-11-jdk openjdk-16-jre qtbase5-dev -y || error "Could not install dependencies"
        hash -r
        ;;
    *)
        error "$__os_id appears to be an unsupported OS"
        ;;
esac

# make all the folders
cd
mkdir -p ~/MultiMC
cd ~/MultiMC || exit 1
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
	megascript_mods=$(sed -n "p" <"/home/$USER/MultiMC/scripts/megascript-mods.txt")
	user_mods=$(sed -n "p" <"/home/$USER/MultiMC/scripts/user-mods.txt")
	cd "$INST_DIR"
	mc_version=$(jq -M -r '.components[] | "\(.uid)/\(.version)"' mmc-pack.json | sed -n -e 's/^.*net.minecraft\///p')
    if [[ -d "minecraft" ]]; then
        cd minecraft
    else
        mkdir -p .minecraft
        cd .minecraft
    fi
	mkdir -p mods
	mkdir -p config
	cd mods
	minecraft_mods_list=$(minecraft-mod-manager list | tail -n +2)
	echo -e "The megascript uses Minecraft Mod Manager to keep all your Mods up to date and install a pregenerated list of Fabric Mods.\
Do you want to update/install the following Mods: \n\n$minecraft_mods_list\n\n\n\
If this list above is emtpty, you haven't clicked (Yes, Update/Install My Mods and Megascript Suggested Fabric mods) before, you should do that to install suggested performance mods.\
\n\nMake sure you have already clicked the Install Fabric button (or Forge button if you are supplying your own mods) otherwise these mods won't activate!\n\n\
You might want to select the (Yes, Update/Install ONLY My Mods) button if you plan on using forge mods. This button will skip the pregenerated list of Fabric mods" | yad --image "dialog-question" \
	--borders="20" --height="200" --center --fixed\
	--window-icon=/usr/share/icons/L4T-Megascript.png \
	--text-info --fontname="@font@ 11" --wrap --width=800 --height=500 \
	--show-uri \
	--button="Yes, Update/Install My Mods and Megascript Suggested Fabric mods":0 \
    --button="Yes, Update/Install ONLY My Mods":1 \
	--button="No, skip this and save time":2
	
	case "$?" in
        "0")
            echo "Selected: Update/Install My Mods and Megascript Suggested Fabric mods"
            echo "Downloading latest gamecontrollerdb.txt"
            wget "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt" -O ../config/gamecontrollerdb_temp.txt && rm -rf ../config/gamecontrollerdb.txt && mv ../config/gamecontrollerdb_temp.txt ../config/gamecontrollerdb.txt
            echo "Patching gamecontrollerdb.txt for combined joycons to work around bug in lwjgl3"
            echo "060000004e696e74656e646f20537700,Nintendo Combined Joy-Cons 2 (joycond),a:b0,b:b1,back:b9,dpdown:b15,dpleft:b16,dpright:b17,dpup:b14,leftshoulder:b5,leftstick:b12,lefttrigger:b7,leftx:a0,lefty:a1,rightshoulder:b6,rightstick:b13,righttrigger:b8,rightx:a2,righty:a3,start:b10,x:b3,y:b2,platform:Linux," >> ../config/gamecontrollerdb.txt
            minecraft-mod-manager -v "$mc_version" --mod-loader fabric --beta --alpha install $megascript_mods $user_mods
            minecraft-mod-manager -v "$mc_version" --mod-loader fabric --beta --alpha update
            ;;
        "1")
            echo "Selected: Update/Install ONLY My Mods"
            echo "Downloading latest gamecontrollerdb.txt"
            wget "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt" -O ../config/gamecontrollerdb_temp.txt && rm -rf ../config/gamecontrollerdb.txt && mv ../config/gamecontrollerdb_temp.txt ../config/gamecontrollerdb.txt
            echo "Patching gamecontrollerdb.txt for combined joycons to work around bug in lwjgl3"
            echo "060000004e696e74656e646f20537700,Nintendo Combined Joy-Cons 2 (joycond),a:b0,b:b1,back:b9,dpdown:b15,dpleft:b16,dpright:b17,dpup:b14,guide:b11,leftshoulder:b5,leftstick:b12,lefttrigger:b7,leftx:a0,lefty:a1,rightshoulder:b6,rightstick:b13,righttrigger:b8,rightx:a2,righty:a3,start:b10,x:b3,y:b2,platform:Linux," >> ../config/gamecontrollerdb.txt
            minecraft-mod-manager -v "$mc_version" --beta --alpha update
            ;;
        "2")
            echo "Skipped Mod install/update"
            ;;
	esac
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
modmenu
lazydfu
ferrite-core
better-beds
chunk-pregenerator-fabric
EOF

# clone the complete source
status "Downloading the MultiMC5 Source Code"
git clone --recursive https://github.com/MultiMC/Launcher.git src # You can clone from MultiMC's main repo, no need to use a fork.
cd src
git remote set-url origin https://github.com/MultiMC/Launcher.git
git checkout --recurse-submodules develop || error "Could not checkout develop branch"
git pull --recurse-submodules || error "Could Not Pull Latest MultiMC Source Code, verify your ~/MultiMC/src directory hasn't been modified. You can detete the  ~/MultiMC/src folder to attempt to fix this error."

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

set(Launcher_CommonName "MultiMC")

set(Launcher_Copyright "MultiMC Contributors" PARENT_SCOPE)
set(Launcher_Domain "multimc.org" PARENT_SCOPE)
set(Launcher_Name "${Launcher_CommonName}" PARENT_SCOPE)
set(Launcher_DisplayName "${Launcher_CommonName} 5" PARENT_SCOPE)
set(Launcher_UserAgent "${Launcher_CommonName}/5.0" PARENT_SCOPE)
set(Launcher_ConfigFile "multimc.cfg" PARENT_SCOPE)
set(Launcher_Git "https://github.com/MultiMC/Launcher" PARENT_SCOPE)

set(Launcher_Branding_ICNS "notsecrets/Launcher.icns" PARENT_SCOPE)
set(Launcher_Branding_WindowsRC "notsecrets/launcher.rc" PARENT_SCOPE)
set(Launcher_Branding_LogoQRC "notsecrets/logo.qrc" PARENT_SCOPE)
EOF

cd ..
# configure the project
cd build
# obtain the cpu info
get_system
# temporary hotfix to build with java 11 (build currently fails on java 16 autodetection)
# https://github.com/MultiMC/Launcher/issues/3949
# remove cmake cache until bug is fixed
rm -rf CMakeCache.txt
case "$dpkg_architecture" in
    "arm64") cmake -DLauncher_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-11-openjdk-arm64' -DLauncher_BUILD_PLATFORM="$model" -DLauncher_BUG_TRACKER_URL="https://github.com/cobalt2727/L4T-Megascript/issues" -DLauncher_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DLauncher_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install -DLauncher_META_URL:STRING="https://raw.githubusercontent.com/theofficialgman/meta-multimc/master-clean/index.json" ../src ;;
    "armhf") cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLauncher_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-11-openjdk-armhf' -DLauncher_BUILD_PLATFORM="$model" -DLauncher_BUG_TRACKER_URL="https://github.com/cobalt2727/L4T-Megascript/issues" -DLauncher_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DLauncher_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install -DLauncher_META_URL:STRING="https://raw.githubusercontent.com/theofficialgman/meta-multimc/master-clean-arm32/index.json" ../src ;;
    "amd64") cmake -DLauncher_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-11-openjdk-amd64' -DLauncher_BUG_TRACKER_URL="https://github.com/cobalt2727/L4T-Megascript/issues" -DLauncher_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DLauncher_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install ../src ;;
    "i386") cmake -DLauncher_EMBED_SECRETS=ON -DJAVA_HOME='/usr/lib/jvm/java-11-openjdk-i386' -DLauncher_BUG_TRACKER_URL="https://github.com/cobalt2727/L4T-Megascript/issues" -DLauncher_SUBREDDIT_URL="https://www.reddit.com/r/MultiMC/" -DLauncher_DISCORD_URL="https://discord.gg/multimc"  -DCMAKE_INSTALL_PREFIX=../install ../src ;;
esac

warning "MultiMC5 does not give support for custom builds"
warning "Only bugs that can be reproduced on official MultiMC5 builds should be posted to https://github.com/MultiMC/MultiMC5/issues"
warning "Bugs which only appear on this build should be posted to https://github.com/cobalt2727/L4T-Megascript/issues"

# build & install (use -j with the number of cores your CPU has)
status "Starting Compilation"
make -j$(nproc) install || error "Make install failed"

# enable pre-launch script
# this can always be overwritten by the user after the first installation
cd ..
if cat install/multimc.cfg | grep -q "PreLaunchCommand="; then
    if cat install/multimc.cfg | grep -q "PreLaunchCommand=."; then
        warning "Skipping Adding a Prelaunch Script as there is already one specified by the user or a previous installation"
        status "The current Prelaunch Sript is set to: $(cat install/multimc.cfg | grep "PreLaunchCommand=")"
    else
        status "Adding a Prelaunch Script to handle automatic mod installation"
        sed -i "s/PreLaunchCommand=.*/PreLaunchCommand=\/home\/$USER\/MultiMC\/scripts\/pre-launch.sh/g" install/multimc.cfg
    fi
else
    status "Adding a Prelaunch Script to handle automatic mod installation"
    echo "PreLaunchCommand=/home/$USER/MultiMC/scripts/pre-launch.sh" >> install/multimc.cfg
fi

# add Jvm Arguments for increased performance
# these can always be overwritten by the user after the first installation
if cat install/multimc.cfg | grep -q "JvmArgs="; then
    if cat install/multimc.cfg | grep -q "JvmArgs=."; then
        warning "Skipping Adding JvmArgs as they are already populated by the user or a previous installation"
        status "The current JvmArgs are set to: $(cat install/multimc.cfg | grep "JvmArgs=")"
    else
        status "Adding JvmArgs which help with performance overall in all minecraft versions"
        sed -i "s/JvmArgs=.*/JvmArgs=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1/g" install/multimc.cfg
    fi
else
    status "Adding JvmArgs which help with performance overall in all minecraft versions"
    echo "JvmArgs=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1" >> install/multimc.cfg
fi

cd
sudo rm -rf /usr/local/share/applications/MultiMC.desktop
sudo rm -rf /tmp/icon-512.png
mkdir -p ~/.local/share/applications
mkdir -p  ~/.local/share/icons/MultiMC
cd ~/.local/share/icons/MultiMC
wget "https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/MultiMC/icon-512.png" -O /tmp/icon-512.png && sudo rm -rf "$HOME/.local/share/icons/MultiMC/icon-512.png" && mv /tmp/icon-512.png "$HOME/.local/share/icons/MultiMC/icon-512.png"
cd 
# detect if script is running on RPi and if so override MESA GL Version
if grep -iE 'raspberry' <<< $model > /dev/null; then
    warning "You are running a Raspberry Pi, note that OpenGL 3.3 is not fully supported but it necessary to run Minecraft 1.17+."
    warning "Vannilla 1.17.1 and 1.17 have been tested to work but there is no guarantee that future versions and rendering mods will continute to work"
    sh -c "cat > ~/.local/share/applications/MultiMC.desktop << _EOF_
[Desktop Entry]
Type=Application
Exec=env MESA_GL_VERSION_OVERRIDE=3.3 QT_AUTO_SCREEN_SCALE_FACTOR=0 $HOME/MultiMC/install/MultiMC
Hidden=false
NoDisplay=false
Name=MultiMC
Icon=$HOME/.local/share/icons/MultiMC/icon-512.png
Categories=Game
_EOF_"
else
    sh -c "cat > ~/.local/share/applications/MultiMC.desktop << _EOF_
[Desktop Entry]
Type=Application
Exec=$HOME/MultiMC/install/MultiMC
Hidden=false
NoDisplay=false
Name=MultiMC
Icon=$HOME/.local/share/icons/MultiMC/icon-512.png
Categories=Game
_EOF_"
fi

status_green 'Installation is now done! You can open the launcher by going to Menu > Games > MultiMC'

warning "MultiMC5 does not give support for custom builds"
warning "Only bugs that can be reproduced on official MultiMC5 builds should be posted to https://github.com/MultiMC/MultiMC5/issues"
warning "Bugs which only appear on this build should be posted to https://github.com/cobalt2727/L4T-Megascript/issues or ask for help in the Discord Server"

status "Make sure to visit the MultiMC5 wiki if this is your first time using the launcher: https://github.com/MultiMC/MultiMC5/wiki"
status "If you need help installing Optifine: https://github.com/MultiMC/MultiMC5/wiki/MultiMC-and-OptiFine"
