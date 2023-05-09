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

echo "Cleaning up unneeded files from old versions, if found..."
# https://github.com/citra-emu/citra/issues/6397
sudo rm -rf /usr/local/include/Zydis/ /usr/local/include/dynarmic/ /usr/local/include/fmt/ /usr/local/include/mcl/ /usr/local/include/tsl/ /usr/local/include/xbyak/ /usr/local/lib/cmake/ /usr/local/lib/libZydis.a /usr/local/lib/libdynarmic.a /usr/local/lib/libfmt.a /usr/local/lib/libmcl.a /usr/local/lib/pkgconfig/fmt.pc /usr/local/share/cmake/tsl-robin-map/ 

echo "Installing dependencies..."
sleep 1

case "$__os_codename" in
bionic | focal)
  echo "Adding GCC/G++ 10 repo..." #11 is available from here, but there's a compiler bug with QT 5.15.2, which we're stuck on
  ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  echo "Adding QT6 repo..."
  #it's not redneck if it works.
  #TODO: get https://github.com/oskirby/qt6-packaging/issues/2 resolved, or just build QT6 ourselves
  ppa_name="okirby/qt6-backports" && ppa_installer
  ppa_name="okirby/qt6-testing" && ppa_installer

  sudo apt install gcc-10 g++-10
  ;;
*)
  sudo apt install gcc g++
  ;;
esac

sudo apt-get install git libsdl2-2.0-0 libsdl2-dev qt6-base-dev qt6-base-private-dev libqt6opengl6-dev 	qt6-multimedia-dev libqt6multimedia6 libfdk-aac-dev build-essential cmake libc++-dev ffmpeg libswscale-dev libavdevice* libavformat-dev libavcodec-dev libssl-dev -y || error "Could not install dependencies"

echo "Building Citra..."
sleep 1
cd ~
git clone --recurse-submodules -j$(nproc) https://github.com/citra-emu/citra
cd citra
git pull --recurse-submodules -j$(nproc) || error "Could Not Pull Latest Source Code"
git submodule update --init --recursive || error "Could Not Pull All Submodules"
mkdir -p build
cd build
rm -rf CMakeCache.txt
case "$__os_codename" in
bionic | focal)
  cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_COMPILER=gcc-10 -DCMAKE_CXX_COMPILER=g++-10
  ;;
*)
  if grep -iE 'raspberry' <<<$model >/dev/null; then
    #   https://github.com/citra-emu/citra/issues/5921
    warning "You're running a Raspberry Pi, building without ASM since Broadcom is allergic to cryptography extensions..."
    sleep 1
    cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCRYPTOPP_OPT_DISABLE_ASM=1
  else
    cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native
  fi
  ;;
esac

make -j$(nproc) || error "Compilation failed"
sudo make install || error "Make install failed"

##echo "Removing build files..."
##sleep 1
##cd ~
##sudo rm -rf citra

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
