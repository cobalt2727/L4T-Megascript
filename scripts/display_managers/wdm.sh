#!/bin/bash
clear -x
echo "You are about to install the WINGs display manager."
sudo apt install wdm -y || error "Could not install dependencies"

sudo dpkg-reconfigure wdm

echo "Going back to the main menu..."