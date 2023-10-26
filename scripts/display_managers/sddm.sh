#!/bin/bash
clear -x
echo "You are about to install the Simple Desktop display manager."
sudo apt install sddm -y || error "Could not install dependencies"

sudo dpkg-reconfigure sddm

echo "Going back to the main menu..."