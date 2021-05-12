#!/bin/bash

clear

echo "Minecraft Bedrock script started!"
echo "Installing dependencies..."
sleep 1

cd ~
sudo apt install curl -y
rm -rf minecraft-bedrock
mkdir minecraft-bedrock
cd minecraft-bedrock
curl https://api.github.com/repos/ChristopherHX/linux-packaging-scripts/releases/latest | grep "browser_download_url.*Launcher-arm_aarch64" | cut -d : -f 2,3 | tr -d \" | wget -qi -
mv *.AppImage MC.AppImage
chmod +x *.AppImage
curl https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | grep "browser_download_url.*bionic_arm64" | cut -d : -f 2,3 | tr -d \" | wget -qi -
sudo dpkg -i *bionic_arm64.deb
hash -r
ail-cli integrate MC.AppImage
cd ~
rm -rf minecraft-bedrock

echo "Install Dependencies..."
cd ~

if grep -q bionic /etc/os-release; then

sudo add-apt-repository ppa:zorinos/stable -y
sudo sh -c "cat > /etc/apt/preferences.d/zorinos << _EOF_
Explanation: Allow installing glibc from zorinos.
Package: glibc*
Pin: release o=*zorinos*
Pin-Priority: 500

Explanation: Allow installing libc6 from zorinos.
Package: locales*
Pin: release o=*zorinos*
Pin-Priority: 500

Explanation: Allow installing libc from zorinos.
Package: libc*
Pin: release o=*zorinos*
Pin-Priority: 500

Explanation: Avoid other packages from the zorinos repo.
Package: *
Pin: release o=*zorinos*
Pin-Priority: 1
_EOF_"

sudo apt-get install -y debian-archive-keyring

sudo sh -c "cat > /etc/apt/sources.list.d/debian-stable.list << _EOF_
deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian buster main
deb-src [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian buster main

deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian-security/ buster/updates main
deb-src [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian-security/ buster/updates main

deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian buster-updates main
deb-src [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian buster-updates main
_EOF_"

sudo sh -c "cat > /etc/apt/preferences.d/freetype << _EOF_
Explanation: Allow installing freetype from the debian repo.
Package: *freetype*
Pin: origin "*.debian.org"
Pin-Priority: 500

Explanation: Avoid other packages from the debian repo.
Package: *
Pin: origin "*.debian.org"
Pin-Priority: 1
_EOF_"


fi

sudo apt update
sudo apt install libc6 libc6-dev libc-dev-bin libc-bin locales  -y
sudo apt upgrade -y

echo "Please Reboot before launching!"
sleep 5
echo "Going back to the menu..."
sleep 2
