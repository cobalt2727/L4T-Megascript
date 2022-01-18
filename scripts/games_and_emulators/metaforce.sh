#!/bin/bash

#TODO:
# instructions for users to extract their copy of Metroid Prime 1/2/3/Trilogy via Metaforce running on a PC (doing so on a Switch would probably take like a week)
# possibly an AntiMicroX profile since Metaforce only supports keyboard or the Wii U GameCube adapter right now

echo "Metaforce script started!"

echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
sudo apt install udev libudev1 libudev-dev -y
sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo touch /etc/udev/rules.d/51-gcadapter.rules
echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules > /dev/null
sudo udevadm control --reload-rules
sudo systemctl restart udev.service


echo "Installing dependencies..."
if grep -q bionic /etc/os-release; then

  echo "18.04 detected - let's get you a newer version of Clang/LLVM/QT..."
  sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" || error "apt.llvm.org installer failed!"
  ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  ppa_name="theofficialgman/opt-qt-5.15.2-bionic-arm" && ppa_installer

  sudo apt install -y build-essential curl git ninja-build clang lld-13 zlib1g-dev libcurl4-openssl-dev \
  libglu1-mesa-dev libdbus-1-dev libvulkan-dev libxi-dev libxrandr-dev libasound2-dev libpulse-dev \
  libudev-dev libpng-dev libncurses5-dev cmake libx11-xcb-dev python3.8 libpython3.8-dev python3.8-dev \
  qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libclang-dev qt5-default qt515base \
  clang-13 libclang-13-dev libmlir-13-dev libstdc++-11-dev libvulkan1 libvulkan-dev || error "Failed to install dependencies!" #libfmt-dev

else
 sudo apt install -y build-essential curl git ninja-build clang lld zlib1g-dev libcurl4-openssl-dev \
 libglu1-mesa-dev libdbus-1-dev libvulkan-dev libxi-dev libxrandr-dev libasound2-dev libpulse-dev libudev-dev \
 libpng-dev libncurses5-dev cmake libx11-xcb-dev python3 python-is-python3 qtbase5-dev qtchooser qt5-qmake \
 qtbase5-dev-tools libclang-dev libvulkan1 libvulkan-dev || error "Failed to install dependencies!" #libfmt-dev
fi

git clone --recursive https://github.com/AxioDL/metaforce.git -j$(nproc)
cd metaforce
git pull -j$(nproc)
git submodule update --recursive
cd ..
mkdir metaforce-build
cd metaforce-build

#cmake
if grep -q bionic /etc/os-release; then
 CC=clang-13 CXX=clang++-13 cmake -DCMAKE_BUILD_TYPE=Release -DMETAFORCE_VECTOR_ISA=native -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE -G Ninja ../metaforce || error "Cmake failed!"
else
 CC=clang CXX=clang++ cmake -DCMAKE_BUILD_TYPE=Release -DMETAFORCE_VECTOR_ISA=native -G Ninja ../metaforce || error "Cmake failed!"
fi

#ninja
if grep -q bionic /etc/os-release; then
 CC=clang-13 CXX=clang++-13 ninja || error "Build failed!"
else
 CC=clang CXX=clang++ ninja || error "Build failed!"
fi

cd ~

#install metaforce and all associated programs
sudo cp metaforce-build/Binaries/* /usr/local/bin/
#install icons for .desktop files
sudo cp -r metaforce/metaforce-gui/platforms/freedesktop/*/ /usr/local/share/icons/hicolor/
sudo cp -r metaforce/Runtime/platforms/freedesktop/*/ /usr/local/share/icons/hicolor/
#install .desktop files themselves - possibly rewrite that first line if the file gets renamed as per my suggestion in https://github.com/AxioDL/metaforce/pull/438
sudo cp metaforce/metaforce-gui/platforms/freedesktop/metaforce.desktop /usr/local/share/applications/metaforce-gui.desktop
sudo cp metaforce/Runtime/platforms/freedesktop/metaforce.desktop /usr/local/share/applications/metaforce.desktop

#maybe prompt user to delete build folder(s) considering how big they are?
