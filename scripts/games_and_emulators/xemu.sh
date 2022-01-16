#!/bin/bash

clear -x
echo "Xemu script started!"

# Install dependencies
sudo apt install -y build-essential libsdl2-dev libepoxy-dev libpixman-1-dev libgtk-3-dev libssl-dev libsamplerate0-dev libpcap-dev ninja-build python3 gcc g++ || error "Could not install dependencies!"
#this script updates SDL2 for aarch64 devices and does nothing for others
bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"

# Clone and build
cd ~
git clone https://github.com/mborgerson/xemu.git -j$(nproc) #not including all submodules on this, the folder is over 2 GB if I do -cobalt
cd xemu || error "Couldn't download source code!"
#do this to make my weird python changing later less likely to break things, hopefully
git reset --hard
git pull --recurse-submodules -j$(nproc) || error "Couldn't pull latest source code!"

if grep -q bionic /etc/os-release; then
  ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  #ppa_name="ubuntu-toolchain-r/ppa" && ppa_installer
  sudo apt install python3.8 gcc-11 g++-11 -y || error "Could not install dependencies!" #GCC 9 (the 20.04 default) also works, I'm just using 11 to future-proof -cobalt
  sed -i -e 's/python3 /python3.8 /g' build.sh #this is hacky, yes, but hey, it works
  CFLAGS=-mcpu=native CXXFLAGS=-mcpu=native CC=gcc-11 CXX=g++-11 ./build.sh || error "Compilation failed!"
else
  #./build.sh
  CFLAGS=-mcpu=native CXXFLAGS=-mcpu=native ./build.sh || error "Compilation failed!" #I don't think CXXFLAGS actually gets used, but I'm leaving it there in case the build script ever takes it into account
fi


cd ~
#install xemu itself
sudo cp xemu/dist/xemu /usr/local/bin/xemu
#install icons for .desktop files
sudo cp -r xemu/ui/icons/xemu.svg /usr/local/share/icons/hicolor/scalable/apps/xemu.svg

sudo cp -r xemu/ui/icons/xemu_128x128.png /usr/local/share/icons/hicolor/128x128/apps/xemu.png #128
sudo cp -r xemu/ui/icons/xemu_16x16.png /usr/local/share/icons/hicolor/16x16/apps/xemu.png #16
sudo cp -r xemu/ui/icons/xemu_24x24.png /usr/local/share/icons/hicolor/24x24/apps/xemu.png #24
sudo cp -r xemu/ui/icons/xemu_256x256.png /usr/local/share/icons/hicolor/256x256/apps/xemu.png #256
sudo cp -r xemu/ui/icons/xemu_32x32.png /usr/local/share/icons/hicolor/32x32/apps/xemu.png #32
sudo cp -r xemu/ui/icons/xemu_48x48.png /usr/local/share/icons/hicolor/48x48/apps/xemu.png #48
sudo cp -r xemu/ui/icons/xemu_512x512.png /usr/local/share/icons/hicolor/512x512/apps/xemu.png #512
sudo cp -r xemu/ui/icons/xemu_64x64.png /usr/local/share/icons/hicolor/64x64/apps/xemu.png #64


#install .desktop files themselves - possibly rewrite that first line if the file gets renamed as per my suggestion in https://github.com/AxioDL/metaforce/pull/438
sudo cp xemu/ui/xemu.desktop /usr/local/share/applications/xemu.desktop
