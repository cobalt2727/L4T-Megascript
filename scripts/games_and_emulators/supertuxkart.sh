#!/bin/bash

clear -x
status "SuperTuxKart script started!"
available_space=$(df . | awk 'NR==2 {print $4}')

if [[ $available_space -lt 3670016 ]]; then
  error_user "Not enough free space to compile/install SuperTuxKart. You need at least 3.5GB free"
fi

status "Downloading the files and installing needed dependencies..."
sleep 3
cd ~
sudo apt install build-essential libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 \
  libsdl2-image-dev curl libcurl4 libcurl4-openssl-dev libvorbis-dev libogg-dev \
  cmake extra-cmake-modules libopenal-dev libglew-dev libgles2-mesa-dev libboost-dev libboost-all-dev subversion \
  libbluetooth-dev libenet-dev libfreetype6-dev libharfbuzz-dev \
  libjpeg-dev libpng-dev \
  libssl-dev nettle-dev pkg-config zlib1g-dev -y || error "Dependency installs failed"
mkdir -p supertuxkart
cd supertuxkart
git clone https://github.com/supertuxkart/stk-code stk-code --depth=1 || (
  cd stk-code && git pull --depth=1
  cd ..
)
svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets || (
  cd stk-assets && svn up
  cd ..
)
cd stk-code
mkdir build
cd build
status "Compiling the game..."
cmake .. -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native
make -j$(nproc) || error "Compilation failed"
status_green "Game compiled!"
status "Installing game...."
sudo make install || error "Make install failed"
status "Erasing temporary build files to save space..."
cd ~
rm -rf supertuxkart
echo
status_green "Game installed!"
status "Sending you back to the main menu..."
