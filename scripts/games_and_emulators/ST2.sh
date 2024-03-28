#!/bin/bash

status "SuperTux2 script started!"
echo "Downloading the files and installing needed dependencies..."
sleep 3
rm -f ~/RetroPie/roms/ports/supertux2.sh
case "$__os_codename" in
bionic)
  sudo apt install -y gcc-8 g++-8 || error "Failed to install dependencies!"
;;
esac
sudo apt install git build-essential libfreetype* libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev curl libcurl4 libcurl4-openssl-dev libvorbis-dev libogg-dev cmake extra-cmake-modules libopenal-dev libglew-dev libgles2-mesa-dev libboost-dev libboost-all-dev libglm-dev subversion libpng-dev libpng++-dev -y || error "Failed to install dependencies!"
cd /tmp || exit 1
rm -rf supertux
git clone --recursive https://github.com/SuperTux/supertux || exit 1
rm -f supertux/data/images/engine/menu/logo_dev.png
mv supertux/data/images/engine/menu/logo.png supertux/data/images/engine/menu/logo_dev.png
mkdir -p supertux/build
cd supertux/build || exit 1
status "Compiling the game..."
case "$__os_codename" in
bionic)
  cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_C_COMPILER=gcc-8 -DCMAKE_CXX_COMPILER=g++-8 || exit 1
  ;;
*)
  cmake .. -DCMAKE_BUILD_TYPE=RELEASE || exit 1
  ;;
esac
make -j$(nproc) || exit 1
status "Game compiled!"
echo "Installing game...."
sudo make install || error "Make install failed"
echo "Erasing temporary build files to save space..."
cd ~
rm -rf /tmp/supertux
mkdir -p ~/.local/share/supertux2
wget https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/ST2/config -O ~/.local/share/supertux2/config
status "Game installed!"
echo
status "[NOTE] Remember NOT to move the SuperTux2 folder or any file inside it or the game will stop working."
status "If the game icon doesn't appear inmediately, restart the system."
