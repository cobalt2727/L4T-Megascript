#!/bin/bash

echo "Play script started!"

sudo apt install -y cmake libalut-dev libevdev-dev libqt5x11extras5-dev libsqlite3-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools || error "Failed to install dependencies!"
package_available qt5-default
if [[ $? == "0" ]]; then
  sudo apt install -y qt5-default || error "Failed to install dependencies!"
fi

git clone https://github.com/jpd002/Play-
cd Play-/

git submodule update --init --recursive
git pull --recurse-submodules -j4

mkdir -p build
cd build

echo "Building..."
cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native || error "Cmake failed!"
cmake --build . -j$(nproc) || error "Build failed!"

sudo make install || "Make install failed!"

echo "Done!"
sleep 2
