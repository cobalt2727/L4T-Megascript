#!/bin/bash

#TODO:
# instructions for users to extract their copy of Metroid Prime 1/2/3/Trilogy via Metaforce running on a PC (doing so on a Switch would probably take like a week)
# possibly an AntiMicroX profile since Metaforce only supports keyboard or the Wii U GameCube adapter right now

echo "Metaforce script started!"

#removing previous LLVM 13 installs
if grep -q bionic /etc/os-release; then
  if package_installed "llvm-13"; then
    sudo apt remove llvm-13 -y
  fi
  if package_installed "clang-13"; then
    sudo apt remove clang-13 -y
  fi
  if package_installed "clang++-13"; then
    sudo apt remove clang++-13 -y
  fi
  if package_installed "libclang13-dev"; then
    sudo apt remove libclang13-dev -y
  fi
  if package_installed "libmlir-13-dev"; then
    sudo apt remove libmlir-13-dev -y
  fi
fi

echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
sudo apt install udev libudev1 libudev-dev -y
sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo touch /etc/udev/rules.d/51-gcadapter.rules
echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules >/dev/null
sudo udevadm control --reload-rules
sudo systemctl restart udev.service

echo "Installing dependencies..."
if grep -q bionic /etc/os-release; then

  echo "18.04 detected - let's get you a newer version of Clang/LLVM/QT..."
  curl https://apt.llvm.org/llvm.sh | sudo bash -s "14" || error "apt.llvm.org installer failed!"
  ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  get_system
  if ! [[ "$dpkg_architecture" =~ ^("arm64"|"armhf")$ ]]; then
    ppa_name="beineri/opt-qt-5.15.2-bionic"
  else
    ppa_name="theofficialgman/opt-qt-5.15.2-bionic-arm"
  fi
  ppa_installer

  sudo apt install -y build-essential curl git ninja-build clang lld-14 zlib1g-dev libcurl4-openssl-dev \
    libglu1-mesa-dev libdbus-1-dev libxi-dev libxrandr-dev libasound2-dev libpulse-dev \
    libudev-dev libpng-dev libncurses5-dev cmake libx11-xcb-dev python3.8 libpython3.8-dev python3.8-dev \
    qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libclang-dev qt5-default qt515base \
    clang-14 clang++-14 libclang-14-dev libmlir-14-dev libstdc++-11-dev libvulkan1 libvulkan-dev || error "Failed to install dependencies!" #libfmt-dev

else
  sudo apt install -y build-essential curl git ninja-build clang lld zlib1g-dev libcurl4-openssl-dev \
    libglu1-mesa-dev libdbus-1-dev libxi-dev libxrandr-dev libasound2-dev libpulse-dev libudev-dev \
    libpng-dev libncurses5-dev cmake libx11-xcb-dev python3 python-is-python3 qtbase5-dev qtchooser qt5-qmake \
    qtbase5-dev-tools libclang-dev || error "Failed to install dependencies!" #libfmt-dev
  sudo apt install -y --no-install-recommends libvulkan1 libvulkan-dev || error "Failed to install dependencies!"
fi

package_available libqt6svg6-dev # note to self: set up a duplicate of this install check to match the PPAs provided by https://launchpad.net/~rncbc at some point
if [[ $? == "0" ]]; then         # this 22.04+ dep is really only needed for the submodule https://github.com/AxioDL/amuse/ - it can be safely ignored
  sudo apt install -y libqt6svg6-dev libqt6core5compat6-dev || error "Failed to install QT6 development libraries!"
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
  if package_installed "llvm-7"; then
    sudo apt remove llvm-7 clang-7 -y
  fi
  if package_installed "llvm-13"; then
    sudo apt remove llvm-13 clang-13 clang++-13 lld-13 -y
  fi
  CC=clang-14 CXX=clang++-14 cmake -DCMAKE_BUILD_TYPE=Release -DMETAFORCE_VECTOR_ISA=native -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE -G Ninja ../metaforce || error "Cmake failed!"
else
  CC=clang CXX=clang++ cmake -DCMAKE_BUILD_TYPE=Release -DMETAFORCE_VECTOR_ISA=native -G Ninja ../metaforce || error "Cmake failed!"
fi

#ninja
if grep -q bionic /etc/os-release; then
  CC=clang-14 CXX=clang++-14 ninja || error "Build failed!"
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
