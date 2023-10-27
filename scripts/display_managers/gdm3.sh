#!/bin/bash
clear -x
echo "You are about to install the Gnome display manager."
sudo apt install gdm3 -y || error "Could not install dependencies"

sudo dpkg-reconfigure gdm3

echo "Going back to the main menu..."