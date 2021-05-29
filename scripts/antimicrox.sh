#!/bin/bash

echo "This script will install AntiMicroX, an updated fork of AntiMicro and"
echo "a graphical program used to map gamepad keys to keyboard."

# Dependancies
sudo apt install -y git gcc cmake extra-cmake-modules \
    qttools5-dev qttools5-dev-tools libsdl2-dev \
    libxi-dev libxtst-dev libx11-dev itstool gettext

# Cloning
cd ~
rm -rf antimicrox
git clone https://github.com/AntiMicroX/antimicrox.git
cd antimicrox
mkdir build && cd build

# Building
cmake ..
cmake --build .

# Installing
sudo mv -f bin/antimicrox /usr/bin/

# Desktop File
echo "[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/antimicrox
Name=AntiMicroX
Icon=/usr/share/applications/antimicrox.png" > antimicrox.desktop
sudo mv -f antimicrox.desktop /usr/share/applications/
sudo cp -f ~/antimicrox/src/images/antimicrox.png /usr/share/applications/
