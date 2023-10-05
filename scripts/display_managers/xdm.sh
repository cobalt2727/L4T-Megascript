#!/bin/bash
clear -x
echo "You are about to install the X Window display manager."
sudo apt install xdm -y || error "Could not install dependencies"

sudo dpkg-reconfigure xdm

echo "Going back to the main menu..."