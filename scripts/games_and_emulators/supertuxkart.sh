#!/bin/bash

clear -x
echo "SuperTuxKart script started!"
available_space=$(df . | awk 'NR==2 {print $4}')
if [[ $available_space > 3670016 ]]; then
    echo "Downloading the files and installing needed dependencies..."
    sleep 3
    cd ~
    sudo apt install build-essential libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 \
    libsdl2-image-dev curl libcurl4 libcurl4-openssl-dev libvorbis-dev libogg-dev \
    cmake extra-cmake-modules libopenal-dev libglew-dev libboost-dev libboost-all-dev subversion \
    libbluetooth-dev libenet-dev libfreetype6-dev libharfbuzz-dev \
    libjpeg-dev libpng-dev \
    libssl-dev nettle-dev pkg-config zlib1g-dev -y
    mkdir -p supertuxkart
    cd supertuxkart
    git clone https://github.com/supertuxkart/stk-code stk-code --depth=1 || (cd stk-code && git pull --depth=1 ; cd ..)
    svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets || (cd stk-assets && svn up ; cd ..)
    cd stk-code
    mkdir build
    cd build
    echo "Compiling the game..."
    cmake .. -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native
    make -j$(nproc)
    echo
    echo "Game compiled!"
    echo "Installing game...."
    echo
    sudo make install || error "Make install failed"
    echo
    echo "Erasing temporary build files to save space..."
    cd ~
    rm -rf supertuxkart
    echo
    echo "Game installed!"
else
    echo "Not enough free space to comepile/install SuperTuxKart"
    echo "you need at least 3.5GB free"
    sleep 10
fi
echo "Sending you back to the main menu..."

