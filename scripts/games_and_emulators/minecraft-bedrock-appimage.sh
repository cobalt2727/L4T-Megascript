#!/bin/bash

clear -x

echo "Minecraft Bedrock script started!"
echo "Installing dependencies..."
sleep 1

cd ~
sudo apt install curl -y || error "Could not install dependencies"
rm -rf minecraft-bedrock
mkdir minecraft-bedrock
cd minecraft-bedrock
# get dpkg_architecture using function
get_system
case "$dpkg_architecture" in
    "arm64") type="arm_aarch64";type2="arm64";;
    "armhf") type="arm";type2="armhf";;
    "i386") type="i386";type2="$type1";;
    "amd64") type="x86_64";type2="amd64";;
    *) echo "Error: your userspace architecture ($dpkg_architecture) is not supporeted by Minecraft Bedrock Launcher and will fail to run"; echo ""; echo "Exiting the script"; sleep 3; exit $? ;;
esac
curl https://api.github.com/repos/ChristopherHX/linux-packaging-scripts/releases/latest | grep "browser_download_url.*Launcher-$type" | cut -d : -f 2,3 | tr -d \" | wget -i -
mv *.AppImage MC.AppImage
chmod +x *.AppImage
curl https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | grep "browser_download_url.*bionic_$type2" | cut -d : -f 2,3 | tr -d \" | wget -i -
sudo dpkg -i *bionic_*.deb
hash -r
ail-cli integrate MC.AppImage
cd ~
rm -rf minecraft-bedrock

echo "Install Dependencies..."
cd ~

if grep -q bionic /etc/os-release; then

    if $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libc6) lt 2.28);then
        echo "Continuing the install"
    else
        echo "Force Downgrading libc and related packages"
        echo "You may need to recompile other programs such as Dolphin and BOX64 if you see this message"
        sudo rm -rf /etc/apt/sources.list.d/zorinos-ubuntu-stable-bionic.list*
        sudo rm -rf /etc/apt/preferences.d/zorinos*
        sudo rm -rf /etc/apt/sources.list.d/debian-stable.list*
        sudo rm -rf /etc/apt/preferences.d/freetype*

        sudo apt update
        sudo apt install libc-bin=2.27* libc-dev-bin=2.27* libc6=2.27* libc6-dbg=2.27* libc6-dev=2.27* libfreetype6=2.8* libfreetype6-dev=2.8* locales=2.27* -y --allow-downgrades        
    fi
fi

echo "Please Reboot before launching!"
sleep 5
echo "Going back to the menu..."
sleep 2
