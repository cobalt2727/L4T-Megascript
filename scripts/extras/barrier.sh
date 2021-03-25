#!/bin/bash

##Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install git cmake make xorg-dev g++ libcurl4-openssl-dev \
libavahi-compat-libdnssd-dev libssl-dev libx11-dev \
libqt4-dev qtbase5-dev -y

##Build Barrier From Source
cd
git clone https://github.com/debauchee/barrier.git
cd barrier
git submodule update --init --recursive
./clean_build.sh
cd build
sudo make install
cd
rm -rf barrier
