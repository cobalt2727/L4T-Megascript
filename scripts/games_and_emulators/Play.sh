#!/bin/bash

# TODO: apt install deps
# example from gh README:
### sudo apt install cmake libalut-dev qt5-default libevdev-dev libqt5x11extras5-dev libsqlite3-dev

git clone https://github.com/jpd002/Play-

cd Play-/

git submodule update --init --recursive
git pull --recurse-submodules -j4

mkdir -p build 
cd build

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native
cmake --build . -j$(nproc)

sudo make install
