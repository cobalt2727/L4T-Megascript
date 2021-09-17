#!/bin/bash


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
  
  # echo "Adding GCC and G++ 9/10 Repo..."
  # ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  # sudo apt install gcc-10 g++-10 -y
  ppa_name="theofficialgman/opt-qt-5.12.0-bionic-arm" && ppa_installer
  ppa_name="theofficialgman/melonds-depends" && ppa_installer
  sudo apt install qt512-meta-minimal qt5123d qt512base qt512canvas3d qt512declarative qt512gamepad qt512graphicaleffects qt512imageformats qt512multimedia qt512xmlpatterns -y
fi

echo "Installing dependencies..."
sleep 1
sudo apt install cmake libcurl4-openssl-dev libpcap0.8-dev libsdl2-dev qt5-default libslirp-dev libarchive-dev libepoxy-dev -y

echo "Building MelonDS..."
sleep 1
cd ~
git clone https://github.com/Arisotura/melonDS.git
cd melonDS
git pull
mkdir -p build
cd build
if grep -q bionic /etc/os-release; then
  cmake .. -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native -DCMAKE_PREFIX_PATH=/opt/qt512 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
else
  cmake .. -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native
fi
make -j$(nproc)
sudo make install

##echo "Removing build files..."
##sleep 1
##cd ~
##sudo rm -rf melonDS

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
