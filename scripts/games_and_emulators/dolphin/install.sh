#!/bin/bash

clear
echo "Dolphin script started!"
sleep 1
cd ~
echo "Installing dependencies..."
sleep 1
sudo apt install --no-install-recommends ca-certificates qtbase5-dev qtbase5-private-dev git cmake make gcc g++ pkg-config udev libudev1 libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxi-dev libxrandr-dev libudev-dev libevdev-dev libsfml-dev libminiupnpc-dev libmbedtls-dev libcurl4-openssl-dev libhidapi-dev libsystemd-dev libbluetooth-dev libasound2-dev libpulse-dev libpugixml-dev libbz2-dev libzstd-dev liblzo2-dev libpng-dev libusb-1.0-0-dev gettext -y 


echo "Downloading the source..."
git clone https://github.com/dolphin-emu/dolphin
cd dolphin
git pull
mkdir -p build
cd build
echo "Building..."
echo
#if you're looking at this script as a reference for building Dolphin on your own hardware,
#you can do "cmake .." and nothing else on the next line for a slight performance hit with a much faster build time

if grep -q bionic /etc/os-release; then
  
  echo "Ubuntu 18.04 detected, skipping LTO optimization..."
  echo "If that means nothing to you, don't worry about it."
  echo "That being said, we need to get you a newer compiler to prevent some bugs."
  #oddly enough the only *known* bug here is that emulated wii remote cursors don't work with GCC 7 builds
  echo "Adding Ubuntu Toolchain Test PPA to install GCC 11..."
  sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
  sudo apt update
  sudo apt install gcc-11 g++-11 -y
  echo "Alright, NOW we can start the building process."
  echo -e "\e[1;33mIf it freezes, especially around 80% or 100%, even for a few minutes, that's normal.\e[0m"
  sleep 10
  cmake .. -D -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static" -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11

else  
  
  echo -e "\e[1;33mIf it freezes, especially around 80%, even for a few minutes, that's normal.\e[0m"
  sleep 10
  cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static"

fi




make -j$(nproc)
echo "Installing..."
sudo make install
cd ~
#commenting out the below line since the first build takes way too long to do on weak hardware like the Switch
#leaving the source folder there will make future builds faster
##sudo rm -rf dolphin
echo "Done!"
echo "Sending you back to the main menu..."
sleep 2
