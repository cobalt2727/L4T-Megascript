#!/bin/bash

# Dependancies
sudo apt install git gcc cmake extra-cmake-modules \
    qttools5-dev qttools5-dev-tools libsdl2-dev \
#   libxi-dev libxtst-dev \
    libx11-dev itstool gettext -y

# Cloning
git clone https://github.com/AntiMicroX/antimicrox.git
cd antimicrox
mkdir build && cd build

# Building
cmake ..
cmake --build .
