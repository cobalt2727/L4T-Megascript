#!/bin/bash

sudo apt update
sudo apt install cmake curl zlib1g-dev openjdk-8-jdk openjdk-11-jdk qtbase5-dev -y
# make all the folders
cd
mkdir ~/MultiMC
cd ~/MultiMC
mkdir build
mkdir install
# clone the complete source
git clone --recursive https://github.com/MultiMC/MultiMC5.git src # You can clone from MultiMC's main repo, no need to use a fork.
# configure the project
cd build
cmake -DCMAKE_INSTALL_PREFIX=../install -DMultiMC_META_URL:STRING="https://raw.githubusercontent.com/theofficialgman/meta-multimc/master/index.json" ../src
# build & install (use -j with the number of cores your CPU has)
make -j$(nproc) install
