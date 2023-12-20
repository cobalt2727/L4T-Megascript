#!/bin/bash

clear -x
echo "This script will install AntiMicroX, an updated fork of AntiMicro and"
echo "a graphical program used to map gamepad keys to keyboard."

# Dependancies
sudo apt install -y git build-essential cmake extra-cmake-modules \
  qttools5-dev qttools5-dev-tools libsdl2-dev \
  libxi-dev libxtst-dev libx11-dev itstool gettext python3-libxml2 || error "Could not install dependencies"

hash -r

# Cloning
cd /tmp || error "No /tmp directory"
rm -rf antimicrox
git clone https://github.com/AntiMicroX/antimicrox.git --depth=1
cd antimicrox
mkdir build && cd build

# Building
cmake .. || error "Cmake failed"
make -j$(nproc) || error "Compilation failed"

# Installing
sudo make install || error "Make install failed"

# Removing source
cd ~
rm -rf /tmp/antimicrox
