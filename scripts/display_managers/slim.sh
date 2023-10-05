#!/bin/bash
clear -x
echo "You are about to install the Simple log-in manager."
sudo apt install slim -y || error "Could not install dependencies"

sudo dpkg-reconfigure slim

echo "Going back to the main menu..."