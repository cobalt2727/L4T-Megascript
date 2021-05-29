#!/bin/bash

echo "This script will install AntiMicroX, an updated fork of AntiMicro and"
echo "a graphical program used to map gamepad keys to keyboard."

# Dependancies
sudo apt install -y git gcc cmake extra-cmake-modules \
    qttools5-dev qttools5-dev-tools libsdl2-dev \
    libxi-dev libxtst-dev libx11-dev itstool gettext

# Cloning
cd ~
git clone https://github.com/AntiMicroX/antimicrox.git
cd antimicrox
mkdir build && cd build

# Building
cmake ..
cmake --build .
