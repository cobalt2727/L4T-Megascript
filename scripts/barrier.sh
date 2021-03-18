#!/bin/bash

##Dependencies
sudo apt update && sudo apt upgrade
sudo apt install git cmake make xorg-dev g++ libcurl4-openssl-dev \
libavahi-compat-libdnssd-dev libssl-dev libx11-dev \
libqt4-dev qtbase5-dev

##Build Barrier From Source
git clone https://github.com/debauchee/barrier.git
cd barrier
git submodule update --init --recursive
./clean_build.sh
cd build
sudo make install
