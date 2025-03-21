#!/bin/bash

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

  if ! [[ "$dpkg_architecture" =~ ^("arm64"|"armhf")$ ]]; then
    warning "You are not running an ARMhf/ARM64 architecture, your system is not supported and this may not work"
    ubuntu_ppa_installer "beineri/opt-qt-5.15.2-bionic"
  else
    ubuntu_ppa_installer "theofficialgman/opt-qt-5.15.2-bionic-arm"
  fi
  ppa_installer
  ubuntu_ppa_installer "theofficialgman/melonds-depends" || error "PPA failed to install"
  ubuntu_ppa_installer "theofficialgman/cmake-bionic" || error "PPA failed to install"

  echo "Adding Ubuntu Toolchain Test PPA to install GCC 11..."
  ubuntu_ppa_installer "ubuntu-toolchain-r/test" || error "PPA failed to install"

  # sudo apt install cmake gcc-11 g++-11 qt5123d qt512base qt512canvas3d qt512declarative qt512gamepad qt512graphicaleffects qt512imageformats qt512multimedia qt512xmlpatterns -y || error "Could not install dependencies"
  sudo apt install -y cmake gcc-11 g++-11 qt515base qt515multimedia qt515gamepad || error "Could not install dependencies"
  ;;
*)
  package_available qt5-default
  if [[ $? == "0" ]]; then
    sudo apt install -y qt5-default qtbase5-private-dev qtmultimedia5-dev || error "Failed to install dependencies"
  else
    sudo apt install -y qtbase5-dev qtchooser qtbase5-private-dev qtmultimedia5-dev || error "Failed to install dependencies"
  fi
  sudo apt install -y cmake gcc g++ || error "Could not install dependencies"
  ;;
esac

echo "Installing dependencies..."
sleep 1
sudo apt install cmake git libsdl2-2.0-0 libsdl2-dev ffmpeg libelf-dev libepoxy-dev libzip-dev zipcmp zipmerge ziptool libedit-dev libjson-c-dev libsqlite3-dev liblua5.3-dev -y || error "Could not install dependencies"

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
##sudo rm -rf mgba

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5