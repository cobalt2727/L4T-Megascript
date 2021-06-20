#!/bin/bash

clear
echo "You are about to install the Unity desktop environment."
echo "Under most cases this shouldn't break anything and install alongside of your existing desktop, but just to be sure..."
echo "Are you sure you want to continue?"

##prompt yes/no
sudo apt update
sudo apt install ubuntu-unity-desktop --install-suggests -y

echo "Going back to the main menu..."