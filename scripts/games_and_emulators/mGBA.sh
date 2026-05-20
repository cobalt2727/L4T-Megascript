#!/bin/bash

clear -x
echo "mGBA script successfully started!"
echo "Credits: https://github.com/mgba-emu/mgba"
sleep 3

echo "Running updates..."
sleep 1

case "$__os_codename" in
bionic | focal)
  echo "Adding QT6 repo..."
  #it's not redneck if it works.
  #TODO: get https://github.com/oskirby/qt6-packaging/issues/2 resolved, or just build QT6 ourselves
  ubuntu_ppa_installer "okirby/qt6-backports" || error "PPA failed to install"
  ubuntu_ppa_installer "okirby/qt6-testing" || error "PPA failed to install"
  ubuntu_ppa_installer "theofficialgman/melonds-depends" || error "PPA failed to install"
  ubuntu_ppa_installer "theofficialgman/cmake-bionic" || error "PPA failed to install"

  echo "Adding Ubuntu Toolchain Test PPA to install GCC 11..."
  ubuntu_ppa_installer "ubuntu-toolchain-r/test" || error "PPA failed to install"

  sudo apt install -y gcc-13 g++-13 || error "Could not install dependencies"
  ;;
*)
  sudo apt install -y gcc g++ || error "Could not install dependencies"
  ;;
esac

echo "Installing dependencies..."
sleep 1
sudo apt-get install -y cmake git qt6-base-dev qt6-base-private-dev qt6-multimedia-dev linguist-qt6 \
  libsdl2-2.0-0 libsdl2-dev ffmpeg libelf-dev libepoxy-dev libzip-dev zipcmp zipmerge ziptool \
  libedit-dev libjson-c-dev libsqlite3-dev liblua5.3-dev || error "Could not install dependencies"

echo "Building mGBA..."
sleep 1
cd ~
git clone https://github.com/mgba-emu/mgba.git
cd mgba
git pull || error "Could Not Pull Latest mGBA Source Code, verify your ~/mgba directory hasn't been modified. You can detete the ~/mGBA folder to attempt to fix this error."
mkdir -p build
cd build
rm -rf CMakeCache.txt
case "$__os_codename" in
bionic)
  cmake .. -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE -DCMAKE_C_COMPILER=gcc-13 -DCMAKE_CXX_COMPILER=g++-13
  ;;
*)
  cmake .. -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native
  ;;
esac
make -j$(nproc) || error "Compilation failed"
sudo make install || error "Make install failed"

##echo "Removing build files..."
##sleep 1
##cd ~
##sudo rm -rf mgba

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5