#!/bin/bash

case "$__os_id" in
Raspbian | Debian | Ubuntu)
  sudo apt install git -y || error "Failed to install dependencies!"
  ;;
Fedora)
  sudo dnf install -y --refresh git || error "Failed to install dependencies!"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install Git yourself from the package manager if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

cd /tmp
rm -rf L4T-Megascript/
git clone --filter=blob:none --sparse https://github.com/cobalt2727/L4T-Megascript
cd L4T-Megascript/
git sparse-checkout add assets/Dolphin-Config
git sparse-checkout add assets/Dolphin || error "Could not download config files for Dolphin!"
cd assets/

##Import config files
cd Dolphin-Config/
mkdir -p ~/.config/dolphin-emu/
ls
cp -r * ~/.config/dolphin-emu/
cd ..

##Import themes, game-specific configs, etc
cd Dolphin/
mkdir -p ~/.local/share/dolphin-emu/
ls
cp -r * ~/.local/share/dolphin-emu/

##Clean up download
cd ~
rm -rf /tmp/L4T-Megascript/

##Enable Switch/Wii U Gamecube adpater use
echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo rm -f /etc/udev/rules.d/51-usb-devices.rules
sudo wget https://raw.githubusercontent.com/dolphin-emu/dolphin/master/Data/51-usb-device.rules -O /etc/udev/rules.d/51-usb-devices.rules
sudo udevadm control --reload-rules
case "$__os_id" in
Raspbian | Debian | Ubuntu)
  sudo systemctl restart udev.service
  ;;
esac
