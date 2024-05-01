#!/bin/bash

clear -x
echo "Xemu script started!"

# Install dependencies
case "$__os_codename" in
bionic)
  # ppa that contains libslirp
  ubuntu_ppa_installer "theofficialgman/melonds-depends" || error "PPA failed to install"
  ;;
esac
case "$__os_id" in
Raspbian | Debian | Ubuntu)
  sudo apt install -y build-essential libsdl2-dev libepoxy-dev libpixman-1-dev libgtk-3-dev libssl-dev libsamplerate0-dev libpcap-dev ninja-build python3 build-essential libaio-dev libslirp-dev libglu1-mesa-dev || error "Could not install dependencies!"
  #this script updates SDL2 for aarch64 devices and does nothing for others
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
  ;;
Fedora)
  sudo dnf install -y git libdrm-devel libslirp-devel mesa-libGLU-devel gtk3-devel libpcap-devel libsamplerate-devel libaio-devel SDL2-devel libepoxy-devel pixman-devel gcc-c++ ninja-build openssl-devel python3-pyyaml || error "Could not install dependencies!"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.dolphin-emu.org/index.php?title=Building_Dolphin_on_Linux if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

# Clone and build
cd ~
git clone https://github.com/mborgerson/xemu.git -j$(nproc) #not including all submodules on this, the folder is over 2 GB if I do -cobalt
cd xemu || error "Couldn't download source code!"
#do this to make my weird python changing later less likely to break things, hopefully
git reset --hard
git pull --recurse-submodules -j$(nproc) || error "Couldn't pull latest source code!"
git submodule update --init genconfig/ tomlplusplus/ #may be needed to manually specify on other systems?

case "$__os_codename" in
bionic)
  ubuntu_ppa_installer "deadsnakes/ppa" || error "PPA failed to install"
  ubuntu_ppa_installer "ubuntu-toolchain-r/test" || error "PPA failed to install"
  sudo apt install python3.8 gcc-11 g++-11 -y || error "Could not install dependencies!" #GCC 9 (the 20.04 default) also works, I'm just using 11 to future-proof -cobalt
  sed -i -e 's/python3 /python3.8 /g' build.sh                                           #this is hacky, yes, but hey, it works
  python3.8 -m pip install --upgrade pip meson PyYAML
  CFLAGS=-mcpu=native CXXFLAGS=-mcpu=native CC=gcc-11 CXX=g++-11 ./build.sh || error "Compilation failed!"
  ;;
*)
  python3 -m pip install --upgrade pip PyYAML
  #./build.sh
  CFLAGS=-mcpu=native CXXFLAGS=-mcpu=native ./build.sh || error "Compilation failed!" #I don't think CXXFLAGS actually gets used, but I'm leaving it there in case the build script ever takes it into account
  ;;
esac

cd ~
#install xemu itself
sudo install -D xemu/dist/xemu /usr/local/bin/xemu
#install icons for .desktop files
sudo install -m 644 -D xemu/ui/icons/xemu.svg /usr/local/share/icons/hicolor/scalable/apps/xemu.svg

sudo install -m 644 -D xemu/ui/icons/xemu_128x128.png /usr/local/share/icons/hicolor/128x128/apps/xemu.png #128
sudo install -m 644 -D xemu/ui/icons/xemu_16x16.png /usr/local/share/icons/hicolor/16x16/apps/xemu.png     #16
sudo install -m 644 -D xemu/ui/icons/xemu_24x24.png /usr/local/share/icons/hicolor/24x24/apps/xemu.png     #24
sudo install -m 644 -D xemu/ui/icons/xemu_256x256.png /usr/local/share/icons/hicolor/256x256/apps/xemu.png #256
sudo install -m 644 -D xemu/ui/icons/xemu_32x32.png /usr/local/share/icons/hicolor/32x32/apps/xemu.png     #32
sudo install -m 644 -D xemu/ui/icons/xemu_48x48.png /usr/local/share/icons/hicolor/48x48/apps/xemu.png     #48
sudo install -m 644 -D xemu/ui/icons/xemu_512x512.png /usr/local/share/icons/hicolor/512x512/apps/xemu.png #512
sudo install -m 644 -D xemu/ui/icons/xemu_64x64.png /usr/local/share/icons/hicolor/64x64/apps/xemu.png     #64

#install .desktop file itself
sudo install -m 644 -D xemu/ui/xemu.desktop /usr/local/share/applications/xemu.desktop
