#!/bin/bash


clear -x
echo "You are about to install the KDE Plasma desktop environment."
echo "You'll be prompted to choose a display manager during the install, uh, can someone tell me which one's supposed to be used with the Switch and/or update this script?"
echo "Under most cases this shouldn't break anything and install alongside of your existing desktop, but just to be sure..."
echo "Are you sure you want to continue?"

##prompt yes/no
sudo apt install kde-standard plasma-discover plasma-discover-common plasma-discover-flatpak-backend -y || error "Could not install dependencies"

echo "If your screen goes black, don't panic, that's normal. Give it a minute..."
sleep 5

sudo systemctl restart gdm
echo "Going back to the main menu..."
sleep 1
