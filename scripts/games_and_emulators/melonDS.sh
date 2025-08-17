#!/bin/bash

clear -x
echo "MelonDS script successfully started!"
echo "Credits: https://github.com/Arisotura/melonDS"
sleep 3

echo "Running updates..."
sleep 1

case "$__os_codename" in
bionic | focal)
  echo "          -------UBUNTU 18.04 DETECTED-------"
  echo
  echo "theofficialgman has done his PPA Qt5 wizardry"
  echo "enjoy MelonDS on Ubuntu Bionic, Focal, Hirsute, and beyond"

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
  sudo apt install -y cmake gcc-11 g++-11 qt515base qt515multimedia qt515gamepad qt515svg || error "Could not install dependencies"
  ;;
jammy)
  sudo apt install -y cmake gcc g++ qt6-base-dev qt6-base-private-dev qt6-multimedia-dev libqt6svg6-dev || error "Failed to install dependencies"
  ;;
*)
  sudo apt install -y cmake gcc g++ qt6-base-dev qt6-base-private-dev qt6-multimedia-dev qt6-svg-dev || error "Failed to install dependencies"
  ;;
esac

echo "Installing dependencies..."
sleep 1
sudo apt install cmake extra-cmake-modules libcurl4-openssl-dev libpcap0.8-dev libsdl2-dev libslirp-dev libarchive-dev libepoxy-dev libzstd-dev libwayland-dev libenet-dev libfaad-dev -y || error "Could not install dependencies"

echo "Building MelonDS..."
sleep 1
cd ~
git clone https://github.com/Arisotura/melonDS.git
cd melonDS
git pull || error "Could Not Pull Latest MelonDS Source Code, verify your ~/melonDS directory hasn't been modified. You can delete the ~/melonDS folder to attempt to fix this error."
mkdir -p build
cd build
rm -rf CMakeCache.txt
case "$__os_codename" in
bionic | focal)
  cmake .. -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11 -DUSE_QT6=OFF
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
