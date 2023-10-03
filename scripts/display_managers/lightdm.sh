#!/bin/bash
clear -x
echo "You are about to install the LightDM display manager."
sudo apt install lightdm -y || error "Could not install dependencies"

sudo dpkg-reconfigure lightdm

echo "Going back to the main menu..."