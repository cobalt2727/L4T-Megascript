#!/bin/bash

#acquire system info for use in scripts - see functions.sh for info
get_system

##Import config files
cd ~

case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
  sudo apt install subversion -y || error "Failed to install dependencies!"
  ;;
Fedora)
  sudo dnf install subversion -y || error "Failed to install dependencies!"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.dolphin-emu.org/index.php?title=Building_Dolphin_on_Linux if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

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
case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
  sudo systemctl restart udev.service
  ;;
esac
