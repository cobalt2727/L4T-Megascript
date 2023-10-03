#!/bin/bash
clear -x
echo "You are about to install the LXDE display manager."
sudo apt install lxdm -y || error "Could not install dependencies"

sudo dpkg-reconfigure lxdm

echo "Going back to the main menu..."