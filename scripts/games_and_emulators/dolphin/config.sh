#!/bin/bash


##Import config files
cd ~
sudo apt install subversion -y
cd .config/
mkdir -p dolphin-emu
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin-Config
cd Dolphin-Config/
ls
mv * ../dolphin-emu/
cd ..
rm -rf Dolphin-Config/
cd ~

##Import themes, game-specific settings, etc
##why does dolphin store these separately from the above files on Linux smh
cd .local/share/
mkdir -p dolphin-emu
cd dolphin-emu/
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin
cd Dolphin/
mv * ..
cd ..
rm -rf Dolphin/
cd ~

##Enable Switch/Wii U Gamecube adpater use
echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo rm -f /etc/udev/rules.d/51-usb-devices.rules
sudo wget https://raw.githubusercontent.com/dolphin-emu/dolphin/master/Data/51-usb-device.rules -O /etc/udev/rules.d/51-usb-devices.rules
sudo udevadm control --reload-rules
sudo systemctl restart udev.service