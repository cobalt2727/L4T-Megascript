#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}

clear -x
echo "MelonDS script successfully started!"
echo "Credits: https://github.com/Arisotura/melonDS"
sleep 3

echo "Running updates..."
sleep 1

if grep -q bionic /etc/os-release; then
  echo "          -------UBUNTU 18.04 DETECTED-------"
  echo
  echo "theofficialgman has done his PPA Qt5 wizardry"
  echo "enjoy MelonDS on Ubuntu Bionic, Focal, Hirsute, and beyond"
  
  get_system
  if ! [[ "$dpkg_architecture" =~ ^("arm64"|"armhf")$ ]]; then
    warning "You are not running an ARMhf/ARM64 architecture, your system is not supported and this may not work"
    ppa_name="beineri/opt-qt-5.12.0-bionic"
  else
    ppa_name="theofficialgman/opt-qt-5.12.0-bionic-arm"
  fi
  ppa_installer
  ppa_name="theofficialgman/melonds-depends" && ppa_installer
  ppa_name="theofficialgman/cmake-bionic" && ppa_installer

  echo "Adding Ubuntu Toolchain Test PPA to install GCC 11..."
  ppa_name="ubuntu-toolchain-r/test" && ppa_installer

  sudo apt install cmake gcc-11 g++-11 qt512-meta-minimal qt5123d qt512base qt512canvas3d qt512declarative qt512gamepad qt512graphicaleffects qt512imageformats qt512multimedia qt512xmlpatterns -y || error "Could not install dependencies"
fi

echo "Installing dependencies..."
sleep 1
sudo apt install cmake libcurl4-openssl-dev libpcap0.8-dev libsdl2-dev libslirp-dev libarchive-dev libepoxy-dev -y || error "Could not install dependencies"
package_available qt5-default
if [[ $? == "0" ]]; then
  sudo apt install -y qt5-default || error "Failed to install dependencies"
fi

echo "Building MelonDS..."
sleep 1
cd ~
git clone https://github.com/Arisotura/melonDS.git
cd melonDS
git pull || error "Could Not Pull Latest MelonDS Source Code, verify your ~/melonDS directory hasn't been modified. You can detete the ~/melonDS folder to attempt to fix this error."
mkdir -p build
cd build
rm -rf CMakeCache.txt
if grep -q bionic /etc/os-release; then
  cmake .. -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native -DCMAKE_PREFIX_PATH=/opt/qt512 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11
else
  cmake .. -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native
fi
make -j$(nproc) || error "Compilation failed"
sudo make install || error "Make install failed"

##echo "Removing build files..."
##sleep 1
##cd ~
##sudo rm -rf melonDS

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
