#!/bin/bash

#remove neofetch package first
if package_installed neofetch ;then
  echo "Removing neofetch package first..."
  sudo apt purge -y --autoremove neofetch
fi

sudo apt install -y make pciutils mesa-utils || error "Could not install packages"

cd /tmp || error "Could not move to /tmp folder"
rm -rf /tmp/neofetch
git clone --branch merged-branch https://github.com/theofficialgman/neofetch.git --depth=1
cd neofetch && sudo make install || error "Make install failed"
rm -rf /tmp/neofetch
