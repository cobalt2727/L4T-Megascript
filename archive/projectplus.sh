#!/bin/bash

clear -x
echo "Project+ script started!"
echo "This has only been tested for building,"
echo "not performance or actual netplay sessions."
echo "In addition, building has only been tested on 20.10,"
echo "so while I can confirm it compiles on ARM,"
echo "I don't know if it'll build on 18.04 yet... -Cobalt"
sleep 10

echo "Installing standard Dolphin dependencies first since the list for P+ is... really small."
sleep 1
sudo apt install --no-install-recommends ca-certificates qtbase5-dev qtbase5-private-dev git cmake build-essential pkg-config libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxi-dev libxrandr-dev libudev-dev libevdev-dev libsfml-dev libminiupnpc-dev libmbedtls-dev libcurl4-openssl-dev libhidapi-dev libsystemd-dev libbluetooth-dev libasound2-dev libpulse-dev libpugixml-dev libbz2-dev libzstd-dev liblzo2-dev libpng-dev libusb-1.0-0-dev gettext -y

echo "Installing dependencies specific to Project+"
sudo apt install libxxf86vm-dev libxmu-dev libgtk2.0-dev -y

#i don't know if these are on bionic so they get their own lines -Cobalt
sudo apt install axel -y
sudo apt install aria2 -y

sh -c "$(curl -Ls https://github.com/Birdthulu/FPM-Installer/raw/master/setup)"

echo "As per the guide on https://github.com/jlambert360/FPM-Installer"
echo "Move or copy your legally obtained Brawl ISO into [location]/bin/Games/"
echo "Run the game using the .elf file in the Project+ Dolphin build"
