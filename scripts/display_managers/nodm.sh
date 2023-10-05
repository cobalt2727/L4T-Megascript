#!/bin/bash
clear -x
echo "You are about to install the NoDM autologin manager."
sudo apt install nodm -y || error "Could not install dependencies"

sudo dpkg-reconfigure nodm

echo "Going back to the main menu..."