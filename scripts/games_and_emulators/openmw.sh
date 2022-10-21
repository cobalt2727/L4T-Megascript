#!/bin/bash

clear -x
echo "OpenMW script successfully started!"
echo "Credits: https://wiki.openmw.org/index.php/Development_Environment_Setup#Linux"
sleep 3

echo "Running updates..."
sleep 1

echo "Adding OpenMW PPA"
case "$__os_codename" in
bionic) echo "The build available in this PPA doesn't work on 18.04, but it contains important development libraries for compiling." ;;
esac
ppa_name="openmw/openmw" && ppa_installer

case "$__os_codename" in
bionic)
  echo "          -------UBUNTU 18.04 DETECTED-------"
  echo
  echo "theofficialgman has done his PPA Qt5 wizardry"
  echo "enjoy OpenMW on Ubuntu Bionic, Focal, Hirsute, and beyond"

  ppa_name="theofficialgman/opt-qt-5.15.2-bionic-arm"
  ppa_installer
  sudo apt install qt5153d qt515base qt515declarative qt515gamepad \
    qt515graphicaleffects qt515imageformats qt515multimedia \
    qt515xmlpatterns -y || error "Could not install dependencies"

  echo "Installing GCC/G++ 11..."
  ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  sudo apt install gcc-11 g++-11 -y

  echo "Installing dependencies..."
  sleep 1
  sudo apt-get install git build-essential cmake libopenal-dev libbullet-dev libsdl2-dev \
    libmygui-dev libunshield-dev liblz4-dev libtinyxml-dev libqt5opengl5-dev \
    libboost-filesystem-dev libboost-program-options-dev libboost-iostreams-dev \
    libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libswresample-dev \
    librecast-dev libluajit-5.1-dev libsqlite3-dev libyaml-cpp-dev -y ||
    error "Could not install dependencies"

  echo "Building OpenSceneGraph..."
  sleep 1
  cd ~
  git clone -j$(($(nproc) - 1)) https://github.com/OpenMW/osg -b 3.6
  cd osg
  git pull -j$(($(nproc) - 1)) || error "Could not pull latest source code"
  mkdir -p build
  cd build
  rm -rf CMakeCache.txt

  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native \
    -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11
  make -j$(($(nproc) - 1)) || error "Compilation failed"
  sudo make install || error "Make install failed"
  echo "Successfully installed OpenSceneGraph!"

  echo "Building OpenMW..."
  sleep 1
  cd ~
  git clone -j$(($(nproc) - 1)) https://gitlab.com/OpenMW/openmw -b openmw-47
  cd openmw
  git pull -j$(($(nproc) - 1)) || error "Could not pull latest source code"
  mkdir -p build
  cd build
  rm -rf CMakeCache.txt

  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native \
    -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11
  make -j$(($(nproc) - 1)) || error "Compilation failed"
  sudo make install || error "Make install failed"

  echo "Removing build files..."
  sleep 1
  cd ~
  rm -rf openmw osg
  ;;
*)
  echo "Installing OpenMW..."
  sudo apt install openmw openmw-launcher -y || error "Failed to install OpenMW"
  ;;
esac

echo "Successfully installed OpenMW!"
echo "Sending you back to the main menu..."
sleep 5
