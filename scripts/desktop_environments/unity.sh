#!/bin/bash

clear -x
echo "You are about to install the Unity desktop environment."
echo "Under most cases this shouldn't break anything and install alongside of your existing desktop, but just to be sure..."
echo "Are you sure you want to continue?"

##the ubuntu-unity-desktop package tries to pull snap, plus it's not what Nvidia ships by default
sudo apt install unity-session --no-install-recommends -y || error "Could not install dependencies"

echo "Going back to the main menu..."
