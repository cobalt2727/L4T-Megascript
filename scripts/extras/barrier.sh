#!/bin/bash

if package_is_new_enough barrier 2.4.0 ;then
  sudo apt install barrier -y || error "Failed to install barrier"
else
  ##Dependencies
  sudo apt install git cmake make xorg-dev g++ libcurl4-openssl-dev \
    libavahi-compat-libdnssd-dev libssl-dev libx11-dev qtbase5-dev -y  || error "Failed to install dependencies"

  ##Build Barrier From Source
  cd /tmp
  rm -rf barrier
  git clone --recurse-submodules --shallow-submodules --depth=1 -b v2.4.0  https://github.com/debauchee/barrier.git
  cd barrier
  mkdir build
  cd build
  cmake ..
  make -j$(nproc)
  sudo make install || error "Make install failed"
  cd /tmp
  rm -rf barrier
fi
