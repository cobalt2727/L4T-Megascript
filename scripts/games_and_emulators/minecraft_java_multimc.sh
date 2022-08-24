#!/bin/bash
# NOTE: This build is NOT a fork BUT it does use a custom native library repo for the arm64 builds, which is necessary as microsoft and the multimc5 devs do not provide arm64 native libraries

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}

# obtain the cpu and os info
get_system
case "$dpkg_architecture" in
    "arm64"|"amd64"|"i386"|"armhf") ;;
    *) error_user "Error: your cpu architecture ($dpkg_architecture) is not supporeted by MultiMC and will fail to compile" ;;
esac

status "Installing Necessary Dependencies"
case "$__os_id" in
    # Raspbian is not reported as a derivative of Debian (no /etc/upstream-release/lsb-release file)
    Raspbian|Debian)
        case "$__os_codename" in
            bullseye|buster|stretch|jessie)
                sudo apt install -y lsb-release wget apt-transport-https gnupg || error "Failed to install dependencies"
                hash -r

                status "Adding Adoptium repository:"

                echo "- public key -> keyring"
                rm -f /tmp/adoptium-public-key /tmp/adoptium-archive-keyring.gpg
                wget -O /tmp/adoptium-public-key https://adoptium.jfrog.io/artifactory/api/security/keypair/default-gpg-key/public
                gpg --no-default-keyring --keyring /tmp/adoptium-keyring.gpg --import /tmp/adoptium-public-key
                rm -f /tmp/adoptium-public-key

                echo " - keyring -> GPG key"
                gpg --no-default-keyring --keyring /tmp/adoptium-keyring.gpg --export --output /tmp/adoptium-archive-keyring.gpg
                rm -f /tmp/adoptium-keyring.gpg

                echo " - Moving GPG key to /usr/share/keyrings"
                sudo mv -f /tmp/adoptium-archive-keyring.gpg /usr/share/keyrings

                echo " - Creating /etc/apt/sources.list.d/adoptium.list"
                echo "deb [signed-by=/usr/share/keyrings/adoptium-archive-keyring.gpg] https://adoptium.jfrog.io/artifactory/deb $__os_codename main" | sudo tee /etc/apt/sources.list.d/adoptium.list >/dev/null

                echo " - Installing temurin-8-jdk temurin-17-jdk"
                #try to install temurin and adoptopenjdk java versions; if it fails, remove repository to avoid breaking user's system
                sudo apt update
                sudo apt install temurin-8-jdk temurin-17-jdk -y
                if [ $? != 0 ];then
                    anything_installed_from_repo "https://adoptium.jfrog.io/artifactory/deb"
                    if [ $? != 0 ];then
                        # nothing installed from repo, this check is to prevent removing repos which other pi-apps scripts or the user have used successfully
                        # safe to remove
                        sudo rm -f /etc/apt/sources.list.d/adoptium.list /usr/share/keyrings/adoptium-archive-keyring.gpg
                    fi
                    warning "Failed to install temurin packages. Adoptium repository has been removed."  && warning "It is up to you to download and install a working java 8 and 17 version." && echo "" && warning "Continuing the MultiMC5 Install without Java 8 and 17"
                fi

                # remove old java installs to free up space
                rm -rf ~/MultiMC/install/java
                ;;
            *)
                error "Debian version ($__os_codename) is too old, update to debian Jessie or newer"
                ;;
        esac

        # install normal dependencies from raspbian/debian repos
        sudo apt install -y build-essential libopenal1 x11-xserver-utils subversion git clang cmake curl zlib1g-dev openjdk-11-jdk qtbase5-dev || error "Failed to install dependencies"
        ;;
    Ubuntu)
        case "$__os_codename" in
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
                if printf '%s\n' "$requiredver" "$__os_release" | sort -CV; then
                    status "Skipping OpenJDK PPA, $__os_codename already has openjdk-17 in the default repositories"
                else
                    error_user "$__os_codename appears to be too old to run/compile MultiMC5"
                fi
                ;;

        esac
        # install dependencies
        sudo apt install -y build-essential libopenal1 x11-xserver-utils git clang cmake curl zlib1g-dev openjdk-8-jre openjdk-11-jdk openjdk-17-jre qtbase5-dev || error "Failed to install dependencies"
        hash -r
        ;;
    *)
        error "$__os_id appears to be an unsupported OS"
        ;;
esac

# make all the folders
cd "$HOME"
mkdir -p "$HOME/MultiMC"
cd "$HOME/MultiMC" || error "Could not move to directory"
mkdir -p build
mkdir -p install
mkdir -p scripts

modmanager="0"
case "$__os_id" in
    Raspbian|Debian)
        case "$__os_codename" in
            bullseye) modmanager="1"; python_version="python3";;
            buster) modmanager="1"; python_version="python3.8";;
        esac
        ;;
    Ubuntu)
        case "$__os_codename" in
            bionic) modmanager="1"; python_version="python3.8";;
            *) modmanager="1"; python_version="python3";;
        esac
        ;;
esac

if [[ $modmanager == 1 ]]; then
    echo -e "IMPORTANT: Do you want to add an experimental automatic mod updater/installer script?.\
\n\nThis is used to automatically install appropriate performance mods to each of your minecraft instances on launch.\
\n\nIf you want an easy way to install the Fabric performance mods or want a way to easily update your mods, click YES.\
\nIf you ever want to remove this functionality, go to MultiMC->Settings->Custom Commands and remove the Pre-launch command." | yad --image "dialog-question" \
    --borders="20" --center --fixed\
    --text-info --fontname="@font@ 11" --wrap --width=800 --height=250 --timeout=60 --timeout-indicator=bottom \
    --show-uri \
    --button="YES, add the mod script":0 \
    --button="NO, do NOT add the mod script":1
else
    modmanager="0"
    status "Mod script uninstallable since your OS does not have python 3.8+"
fi

if [[ "$?" =~ ^(0|70)$ ]] && [[ $modmanager == 1 ]]; then
    if [[ "$__os_codename" == "buster" ]]; then
        status "Adding deb-pascalroeleven repository for python3.8 backport:"

        echo "- public key -> keyring"

        rm -f /tmp/deb-pascalroeleven-public-key /tmp/deb-pascalroeleven-archive-keyring.gpg
        wget -O /tmp/deb-pascalroeleven-public-key https://pascalroeleven.nl/deb-pascalroeleven.gpg
        gpg --no-default-keyring --keyring /tmp/deb-pascalroeleven-keyring.gpg --import /tmp/deb-pascalroeleven-public-key
        rm -f /tmp/deb-pascalroeleven-public-key

        echo " - keyring -> GPG key"
        gpg --no-default-keyring --keyring /tmp/deb-pascalroeleven-keyring.gpg --export --output /tmp/deb-pascalroeleven-archive-keyring.gpg 
        rm -f /tmp/deb-pascalroeleven-keyring.gpg

        echo " - Moving GPG key to /usr/share/keyrings"
        sudo mv -f /tmp/deb-pascalroeleven-archive-keyring.gpg /usr/share/keyrings

        echo " - Creating /etc/apt/sources.list.d/deb-pascalroeleven.list"
        echo "deb [signed-by=/usr/share/keyrings/deb-pascalroeleven-archive-keyring.gpg] http://deb.pascalroeleven.nl/python3.8 buster-backports main" | sudo tee /etc/apt/sources.list.d/deb-pascalroeleven.list >/dev/null

        sudo apt update
        (sudo apt install python3.8 -y)
        if [ $? != 0 ]; then
            anything_installed_from_repo "http://deb.pascalroeleven.nl/python3.8"
            if [ $? != 0 ]; then
                # nothing installed from repo, this check is to prevent removing repos which other pi-apps scripts or the user have used successfully
                # safe to remove
                sudo rm -f /etc/apt/sources.list.d/deb-pascalroeleven.list /usr/share/keyrings/deb-pascalroeleven-archive-keyring.gpg
            fi
            warning "Failed to install python3.8 packages. deb-pascalroeleven repository has been removed."  && warning "Forcefully skipping installing the mod installer script." && echo "" && warning "Continuing the MultiMC5 Install without automatic mod installer in 10 seconds."
            sleep 10
            modmanager="0"
        fi
    fi
    # check again if modmanager is still 1 incase python3.8 failed to install on buster
    if [[ $modmanager == 1 ]]; then
        # install modmanager python script
        sudo apt install $python_version python3-pip jq -y || error "Failed to install mod installer script dependencies"
        hash -r
        $python_version -m pip install --upgrade pip
        $python_version -m pip install --upgrade minecraft-mod-manager
        if [[ $? == 0 ]]; then
            # creating mod updater script
            wget -O scripts/pre-launch.sh "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/MultiMC/pre-launch.sh"
            chmod +x scripts/pre-launch.sh

            # fabric mods installed by default
            # mods are disabled by default until the user uses the "Install Fabric" button in MultiMC
            echo "Setting list of mods installed by the megascript by default"
            echo "Make sure to click the Install Fabric button within MultiMC to enable these mods"
            echo ""
            wget -O scripts/megascript-mods.txt "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/MultiMC/megascript-mods.txt"
            status "Mod script installed."
        else
            warning "PIP errored on install of dependencies, cannot add the Mod Installer Script."
            warning "Continuing the install without the Mod Install Script in 10 seconds."
            sleep 10
            modmanager="0"
        fi
        unset python_version
    fi
else
    modmanager="0"
    status "Mod script skipped."
fi

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

# enable pre-launch script only if $modmanager == "1"
# this can always be overwritten by the user after the first installation
cd ..
if [[ "$modmanager" == "1" ]]; then
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
    warning "Vanilla 1.17.1 and 1.17 have been tested to work but there is no guarantee that future versions and rendering mods will continute to work"
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
