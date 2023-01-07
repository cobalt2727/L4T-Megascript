#!/bin/bash

#remove htop package first
if package_installed htop ;then
  echo "Removing htop package first..."
  sudo apt purge -y --autoremove htop
fi

sudo apt install libncursesw*-dev dh-autoreconf -y || error "Could not install packages"
cd /tmp || error "Could not move to /tmp folder"
rm -rf ./htop
git clone https://github.com/htop-dev/htop.git
cd htop
git checkout 3.0.5
./autogen.sh && ./configure && make -j$(nproc)
sudo make install || error "Make install failed"
rm -rf /tmp/htop
