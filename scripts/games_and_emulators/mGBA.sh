#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}

clear -x
echo "mGBA script successfully started!"
echo "Credits: https://github.com/mgba-emu/mgba"
sleep 3

echo "Running updates..."
sleep 1

case "$__os_codename" in
bionic)
  echo "          -------UBUNTU 18.04 DETECTED-------"
  echo
  echo "theofficialgman has done his PPA Qt5 wizardry"
  echo "enjoy mGBA on Ubuntu Bionic, Focal, Hirsute, and beyond"

  ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  echo "Adding QT5.15 repo..."
  if ! [[ "$dpkg_architecture" =~ ^("arm64"|"armhf")$ ]]; then
    warning "You are not running an ARMhf/ARM64 architecture, your system is not supported and this may not work"
    ppa_name="beineri/opt-qt-5.15.2-bionic"
  else
    ppa_name="theofficialgman/opt-qt-5.15.2-bionic-arm"
  fi
  ppa_installer
  # sudo apt install qt512-meta-minimal qt5123d qt512base qt512canvas3d qt512declarative qt512gamepad qt512graphicaleffects qt512imageformats qt512multimedia qt512xmlpatterns -y || error "Could not install dependencies"
  sudo apt install gcc-11 g++-11 qt515base qt515multimedia qt515gamepad -y || error "Could not install dependencies"
  ;;
esac

echo "Installing dependencies..."
sleep 1
# Dependencies to check!!
# melonDS      //sudo apt install cmake extra-cmake-modules libcurl4-openssl-dev libpcap0.8-dev libsdl2-dev libslirp-dev libarchive-dev libepoxy-dev -y || error "Could not install dependencies"
# Citra        // sudo apt-get install git libsdl2-2.0-0 libsdl2-dev qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev libqt5multimedia5-plugins libfdk-aac-dev build-essential cmake clang clang-format libc++-dev ffmpeg libswscale-dev libavdevice* libavformat-dev libavcodec-dev libssl-dev
# mGBA manual  //sudo apt install libjson-c-dev libelf-dev libedit-dev libminizip-dev libsqlite3-dev lua5.3-dev

# There's probably a couple packages that I have to look more into, namel related to Qt5 and libav
cmake git libsdl2-2.0-0 libsdl2-dev ffmpeg libelf-dev libepoxy-dev libminizip-dev libedit-dev libjson-c-dev libsqlite3-dev lua5.3-dev -y || error "Could not install dependencies"

echo "Building mGBA..."
sleep 1
cd ~
git clone https://github.com/mgba-emu/mgba.git
cd mGBA
git pull || error "Could Not Pull Latest mGBA Source Code, verify your ~/mGBA directory hasn't been modified. You can detete the ~/mGBA folder to attempt to fix this error."
mkdir -p build
cd build
rm -rf CMakeCache.txt
case "$__os_codename" in
bionic)
  cmake .. -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11
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
##sudo rm -rf melonDS

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
