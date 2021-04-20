#!/bin/bash

clear
echo "Project+ script started!"
sleep 1

echo "Installing standard Dolphin dependencies first since the list for P+ is... really small."
sudo apt install --no-install-recommends ca-certificates qtbase5-dev qtbase5-private-dev git cmake make gcc g++ pkg-config libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxi-dev libxrandr-dev libudev-dev libevdev-dev libsfml-dev libminiupnpc-dev libmbedtls-dev libcurl4-openssl-dev libhidapi-dev libsystemd-dev libbluetooth-dev libasound2-dev libpulse-dev libpugixml-dev libbz2-dev libzstd-dev liblzo2-dev libpng-dev libusb-1.0-0-dev gettext -y 

echo "Installing dependencies specific to Project+"
sudo apt install libxxf86vm-dev libxmu-dev libgtk2.0-dev -y

#i don't know if these are on bionic so they get their own lines -Cobalt
sudo apt install axel -y
sudo apt install aria2 -y


sh -c "$(curl -Ls https://github.com/Birdthulu/FPM-Installer/raw/master/setup)"

echo "As per the guide on https://github.com/jlambert360/FPM-Installer"
echo "Move or copy your legally obtained Brawl ISO into [location]/bin/Games/"
echo "Run the game using the .elf file in the Project+ Dolphin build"
