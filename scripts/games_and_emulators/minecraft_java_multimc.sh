#!/bin/bash

sudo apt update
sudo apt install cmake curl zlib1g-dev openjdk-8-jdk openjdk-11-jdk qtbase5-dev -y
# make all the folders
cd
mkdir -p ~/MultiMC
cd ~/MultiMC
mkdir -p build
mkdir -p install
# clone the complete source
git clone --recursive https://github.com/MultiMC/MultiMC5.git src # You can clone from MultiMC's main repo, no need to use a fork.
cd src
git pull
cd ..
# configure the project
cd build
cmake -DCMAKE_INSTALL_PREFIX=../install -DMultiMC_META_URL:STRING="https://raw.githubusercontent.com/theofficialgman/meta-multimc/master/index.json" ../src
# build & install (use -j with the number of cores your CPU has)
make -j$(nproc) install
cd
sudo sh -c "cat > /usr/local/share/applications/MultiMC.desktop << _EOF_
[Desktop Entry]
Type=Application
Exec=/home/$USER/MultiMC/install/MultiMC
Hidden=false
NoDisplay=false
Name=MutiMC
Icon=/home/$USER/MultiMC/src/application/resources/multimc/scalable/multimc.svg
Categories=Game
_EOF_"