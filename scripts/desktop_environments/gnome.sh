#!/bin/bash
clear
echo "Installing the GNOME desktop environment."

sudo apt install gnome-session gnome-tweaks gnome-tweak-tool chrome-gnome-shell wget curl jq unzip tput sed egrep gnome-shell-extension-tool sed awk cut basename -y

echo "Installing Some Common Extensions"

cd ~
rm -f ./install-gnome-extensions.sh
wget -N -q "https://raw.githubusercontent.com/cyfrost/install-gnome-extensions/7ea5327e36c35e732c6c97887c08fe3596506727/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh
chmod +x install-gnome-extensions.sh
# use this helpful script to install some desired extensions from command line
# 615 is AppIndicator and KStatusNotifyerItem Support
./install-gnome-extensions.sh --enable 615 -o

#automatically sorts Gnome app layout alphabetically
gsettings reset org.gnome.shell app-picker-layout

echo "Going back to the main menu..."
