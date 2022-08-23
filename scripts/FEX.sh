#!/bin/bash

#run L4T Megascript's initial setup script prior for modern cmake, SDL2, etc, before this
sudo apt install cmake ninja-build clang build-essential git libglfw3-dev libepoxy-dev g++-x86-64-linux-gnu nasm libsdl2-dev -y # THIS NEEDS MORE DEPENDENCIES
#add some redundant checks for that here

#wipe LLVM 13 installs from previous setups
if grep -q bionic /etc/os-release || grep -q focal /etc/os-release; then
  if package_installed "llvm-13"; then
    sudo apt remove llvm-13 -y
  fi
  if package_installed "clang-13"; then
    sudo apt remove clang-13 -y
  fi
  if package_installed "libclang-13-dev"; then
    sudo apt remove libclang-13-dev -y
  fi
  if package_installed "libmlir-13-dev"; then
    sudo apt remove libmlir-13-dev -y
  fi
fi

if grep -q bionic /etc/os-release || grep -q focal /etc/os-release; then
  #installs latest stable LLVM toolchain (may need this on Focal now or in the future, untested)
  curl https://apt.llvm.org/llvm.sh | sudo bash -s "14" || error "apt.llvm.org installer failed!"

  ppa_name="ubuntu-toolchain-r/test" && ppa_installer
  sudo apt install -y libstdc++-11-dev libstdc++6 libclang-14-dev gcc-11 g++-11 clang-14 || error "Failed to install dependencies!"
else #this might be insufficient on Focal, needs testing
  sudo apt install -y libstdc++-11-dev libstdc++6 libclang-dev gcc g++ clang || error "Failed to install dependencies!"
fi

if grep -q bionic /etc/os-release; then
  sudo apt install -y python3-pip || error "failed to install pip3!"
  python3 -m pip install --upgrade pip dataclasses || error "Failed to install module for backwards compatibility for Python3.6!"
fi

git clone https://github.com/FEX-Emu/FEX.git --recurse-submodules -j$(nproc)
cd FEX

git submodule update --init
git pull --recurse-submodules -j$(nproc)

mkdir Build
cd Build

#nuke unneeded versions
if package_installed "llvm-13"; then
  sudo apt remove llvm-13 clang-13 -y
fi

#NOTE: make sure to set -DBUILD_TESTS=True when testing to ensure maximum compatibility (broken as of Jan 10, 2022) https://github.com/FEX-Emu/FEX/issues/1423
if grep -q bionic /etc/os-release || grep -q focal /etc/os-release; then
  CC=clang-14 CXX=clang++-14 AR=llvm-ar-14 LINKER=lld-14 NM=llvm-nm-14 OBJDUMP=llvm-objdump-14 RANLIB=llvm-ranlib-14 cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DENABLE_LTO=True -DCMAKE_C_FLAGS_INIT="-static" -DBUILD_TESTS=False -G Ninja .. || error "cmake failed!"
  CC=clang-14 CXX=clang++-14 AR=llvm-ar-14 LINKER=lld-14 NM=llvm-nm-14 OBJDUMP=llvm-objdump-14 RANLIB=llvm-ranlib-14 ninja || error "Failed to build!"
else
  CC=clang CXX=clang++ cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DENABLE_LTO=True -DBUILD_TESTS=False -G Ninja .. || error "cmake failed!"
  CC=clang CXX=clang++ ninja || error "Failed to build!"
fi

sudo ninja install

#fix for https://github.com/ninja-build/ninja/issues/1302
sudo chown $USER:$USER .ninja_*

sudo ninja binfmt_misc_32
sudo ninja binfmt_misc_64
