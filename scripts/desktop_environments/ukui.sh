#!/bin/bash


clear -x
echo "You are about to install the UKUI desktop environment."
echo "Under most cases this shouldn't break anything and install alongside of your existing desktop, but just to be sure..."
echo "Are you sure you want to continue?"

##prompt yes/no
sudo apt install ukui-desktop-environment -y

echo "Going back to the main menu..."
