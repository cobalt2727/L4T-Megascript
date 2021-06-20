#!/bin/bash


clear
echo "You are about to install the GNOME desktop environment."
echo "Under most cases this shouldn't break anything and install alongside of your existing one, but just to be sure..."
echo "Are you sure you want to continue?"

##prompt yes/no
sudo apt update
sudo apt install gnome-session gnome-tweaks gnome-tweak-tool -y

#automatically sorts Gnome app layout alphabetically
gsettings reset org.gnome.shell app-picker-layout

echo "Going back to the main menu..."