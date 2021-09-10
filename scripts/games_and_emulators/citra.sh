#!/bin/bash


clear -x
echo "Citra script successfully started!"
echo "Credits: https://citra-emu.org/wiki/building-for-linux/"
sleep 3

echo "Running updates..."
sleep 1

if grep -q bionic /etc/os-release; then
  echo "          -------UBUNTU 18.04 DETECTED-------"
  echo
  echo "This message will close in 30 seconds and kick you back to the main menu."
  echo "If you want more time to read this, press Ctrl + C at any point to stop the script entirely."
  echo "This script will not work, as you need a newer version of QT installed."
  echo "We'll either add a script to build THAT from source later, or you can wait for Switchroot to release an upgrade to 20.04."
  echo "If you just so happen to already have that set up on your Switch, make a PR on the GitHub to get your build method incorporated into this script!"
  echo "Note that trying to upgrade L4T Ubuntu from within your existing installation is not supported and WILL BREAK YOUR LINUX INSTALL!"
  echo "When 20.04 launches you'll have to reinstall completely to upgrade."
  sleep 30
  echo "laying groundwork for gman to do his QT5 wizardry later:"
  
  echo "Adding GCC and G++ 9/10 Repo..."
  ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  sudo apt install gcc-10 g++-10 -y
  
  exit
fi

echo "Installing dependencies..."
sleep 1
sudo apt-get install git libsdl2-2.0-0 libsdl2-dev qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev libqt5multimedia5-plugins libfdk-aac-dev build-essential cmake clang clang-format libc++-dev ffmpeg libswscale-dev libavdevice* libavformat-dev libavcodec-dev -y

echo "Building Citra..."
sleep 1
cd ~
git clone --recurse-submodules -j$(nproc)  https://github.com/citra-emu/citra
cd citra
git pull --recurse-submodules -j$(nproc)
mkdir -p build
cd build
#LTO isn't used but we're leaving that in anyway in case the devs ever add it - having it there just gets skipped over currently
cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native
make -j$(nproc)
sudo make install

##echo "Removing build files..."
##sleep 1
##cd ~
##sudo rm -rf citra

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
