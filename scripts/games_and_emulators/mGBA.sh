#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}

clear -x
echo "mGBA script successfully started!"
echo "Credits: https://github.com/mgba-emu/mgba.git"
sleep 3

echo "Running updates..."
sleep 1

case "$__os_codename" in
bionic)
  echo "          -------UBUNTU 18.04 DETECTED-------"

  sudo apt install -y cmake gcc-11 g++-11 qt515base qt515multimedia qt515gamepad || error "Could not install dependencies"
  ;;
*)
  package_available qt5-default
  if [[ $? == "0" ]]; then
    sudo apt install -y qt5-default qtmultimedia5-dev || error "Failed to install dependencies"
  else
    sudo apt install -y qtbase5-dev qtchooser qtmultimedia5-dev || error "Failed to install dependencies"
  fi
esac

echo "Installing dependencies..."
sleep 1
sudo apt install zipmerge ziptool git cmake extra-cmake-modules libsdl2-dev libsdl2-2.0-0 libpng-dev zlib1g-dev libedit-dev ffmpeg libavcodec-dev libavcodec-extra libzip-dev sqlite3 libelf-dev lua5.3 libjson-c-dev -y || error "Could not install dependencies"

echo "Building mGBA..."
sleep 1
cd ~
git clone https://github.com/mgba-emu/mgba
cd mgba
git pull || error "Could Not Pull Latest Source Code"
mkdir -p build
cd build
rm -rf CMakeCache.txt
case "$__os_codename" in
bionic)
  cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11 || error "Cmake failed"
  ;;
*)
  cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native || error "Cmake failed"
  ;;
esac
make -j$(nproc) || error "Compilation failed"
sudo make install || error "Make install failed"

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
