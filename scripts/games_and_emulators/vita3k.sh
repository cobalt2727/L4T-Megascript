#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}

clear -x
echo "Vita3k script successfully started!"
echo "Credits: https://github.com/Vita3K/Vita3K/blob/master/building.md#linux"
sleep 3

echo "Installing dependencies..."
sleep 1

case "$__os_id" in
Raspbian | Debian | Ubuntu)

  case "$__os_codename" in
  bionic | focal)
    #installs LLVM-19 toolchain
    curl https://apt.llvm.org/llvm.sh | sudo bash -s "19" || error "apt.llvm.org installer failed!"

    sudo apt install -y libc++-19-dev libc++abi-19-dev libstdc++6 libclang-19-dev clang-19 clang-tools-19 llvm-19 || error "Could not install dependencies"
    sudo apt install -y git cmake ninja-build libsdl2-dev pkg-config libgtk-3-dev xdg-desktop-portal openssl libssl-dev || error "Could not install dependencies"
    ;;
  jammy)
    echo "TODO"
    ;;
  *)
    sudo apt install -y git cmake ninja-build libsdl2-dev pkg-config libgtk-3-dev clang lld xdg-desktop-portal openssl libssl-dev || error "Could not install dependencies"
    ;;
  esac


  ;;

Fedora)
  sudo dnf install -y git cmake ninja-build SDL2-devel pkg-config gtk3-devel clang lld xdg-desktop-portal openssl openssl-devel libstdc++-static || error "Could not install dependencies!"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://github.com/Vita3K/Vita3K/blob/master/building.md#linux if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

echo "Building Vita3k..."
sleep 1
cd ~
git clone --recurse-submodules -j$(nproc) https://github.com/Vita3K/Vita3K
cd Vita3K
git pull --recurse-submodules -j$(nproc) || error "Could Not Pull Latest Source Code"
git submodule update --init --recursive || error "Could Not Pull All Submodules"

# rm -rf build/linux-ninja-clang # resets build directory

# TODO: this makes a debug build. do we want that?
case "$__os_codename" in
bionic | focal)
  cmake --preset linux-ninja-clang -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_COMPILER=clang-19 -DCMAKE_CXX_COMPILER=clang++-19
  cmake --build/linux-ninja-clang -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_COMPILER=clang-19 -DCMAKE_CXX_COMPILER=clang++-19
  ;;
*)
  cmake --preset linux-ninja-clang
  cmake --build build/linux-ninja-clang
  ;;
esac

#TODO: installation

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
