#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}

clear -x
echo "Citra script successfully started!"
echo "Credits: https://citra-emu.org/wiki/building-for-linux/"
sleep 3

echo "Running updates..."
sleep 1

if grep -q bionic /etc/os-release; then
  echo "          -------UBUNTU 18.04 DETECTED-------"
  echo
  echo "theofficialgman has done his PPA Qt5 wizardry"
  echo "enjoy Citra on Ubuntu Bionic, Focal, Hirsute, and beyond"
  
  ###uncomment these lines in the future to resolve possible build errors
  # echo "Adding GCC and G++ 11 Repo..."
  # ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  # sudo apt install gcc-11 g++-11 -y
  get_system
  if ! [[ "$dpkg_architecture" =~ ^("arm64"|"armhf")$ ]]; then
    warning "You are not running an ARMhf/ARM64 architecture, your system is not supported and this may not work"
    ppa_name="beineri/opt-qt-5.12.0-bionic"
  else
    ppa_name="theofficialgman/opt-qt-5.12.0-bionic-arm"
  fi
  ppa_installer
  sudo apt install qt512-meta-minimal qt5123d qt512base qt512canvas3d qt512declarative qt512gamepad qt512graphicaleffects qt512imageformats qt512multimedia qt512xmlpatterns -y || error "Could not install dependencies"
fi

echo "Installing dependencies..."
sleep 1
sudo apt-get install git libsdl2-2.0-0 libsdl2-dev qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev libqt5multimedia5-plugins libfdk-aac-dev build-essential cmake clang clang-format libc++-dev ffmpeg libswscale-dev libavdevice* libavformat-dev libavcodec-dev -y || error "Could not install dependencies"

echo "Building Citra..."
sleep 1
cd ~
git clone --recurse-submodules -j$(nproc)  https://github.com/citra-emu/citra
cd citra
git pull --recurse-submodules -j$(nproc) || error "Could Not Pull Latest Source Code"
git submodule update --init --recursive || error "Could Not Pull All Submodules"
mkdir -p build
cd build
rm -rf CMakeCache.txt
#LTO isn't used but we're leaving that in anyway in case the devs ever add it - having it there just gets skipped over currently
if grep -q bionic /etc/os-release; then
  cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native -DCMAKE_PREFIX_PATH=/opt/qt512 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
else
  if grep -iE 'raspberry' <<< $model > /dev/null; then
#   https://github.com/citra-emu/citra/issues/5921
    warning "You are running a Raspberry Pi, building without ASM since Broadcom is apparently allergic to cryptography extensions..."
    cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native -DCRYPTOPP_OPT_DISABLE_ASM=1
  else
    cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native
  fi

  
fi
make -j$(nproc) || error "Compilation failed"
sudo make install || error "Make install failed"

##echo "Removing build files..."
##sleep 1
##cd ~
##sudo rm -rf citra

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
