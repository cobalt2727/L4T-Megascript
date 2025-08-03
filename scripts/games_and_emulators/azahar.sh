#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}

clear -x
echo "Azahar script successfully started!"
echo "Credits: https://github.com/azahar-emu/azahar/wiki/Building-From-Source#linux"
sleep 3

echo "Installing dependencies..."
sleep 1

case "$__os_id" in
Raspbian | Debian | Ubuntu)

  case "$__os_codename" in
  bionic | focal)
    echo "Adding GCC/G++ 11 repo..."
    ubuntu_ppa_installer "ubuntu-toolchain-r/test" || error "PPA failed to install"
    echo "Adding QT6 repo..."
    #it's not redneck if it works.
    #TODO: get https://github.com/oskirby/qt6-packaging/issues/2 resolved, or just build QT6 ourselves
    ubuntu_ppa_installer "okirby/qt6-backports" || error "PPA failed to install"
    ubuntu_ppa_installer "okirby/qt6-testing" || error "PPA failed to install"
    #installs LLVM-14 toolchain
    curl https://apt.llvm.org/llvm.sh | sudo bash -s "14" || error "apt.llvm.org installer failed!"

    sudo apt install -y libstdc++-11-dev libstdc++6 libclang-14-dev gcc-11 g++-11 clang-14 llvm-14 || error "Could not install dependencies"
    ;;
  *)
    sudo apt install -y clang llvm || error "Could not install dependencies"
    ;;
  esac

  # refer to https://github.com/azahar-emu/azahar/blob/d59ea25cbe75161fd90f7f5cd56279176d456d2d/src/common/dynamic_library/ffmpeg.h#L7-L16 for required ffmpeg development headers
  sudo apt-get install git libsdl2-2.0-0 libsdl2-dev qt6-base-dev qt6-base-private-dev libqt6opengl6-dev qt6-multimedia-dev libqt6multimedia6 qt6-l10n-tools libfdk-aac-dev build-essential cmake libc++-dev libswscale-dev libavformat-dev libavcodec-dev libavfilter-dev libssl-dev glslang-tools glslang-dev spirv-tools spirv-headers -y || error "Could not install dependencies"

  ;;

Fedora)
  sudo dnf install -y git cmake SDL2-devel openssl-devel libXext-devel qt6-qtbase-devel qt6-qtbase-private-devel qt6-qtmultimedia-devel cmake make clang llvm glslang-devel spirv-tools-devel spirv-headers-devel || error "Could not install dependencies!"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.dolphin-emu.org/index.php?title=Building_Dolphin_on_Linux if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

echo "Building Azahar..."
sleep 1
cd ~
# if [ -d "$HOME/azahar" ] && (cd "$HOME/azahar"; git remote get-url origin | grep -q "azahar-emu/azahar"); then
#   rm -rf ~/azahar
# fi
git clone --recurse-submodules -j$(nproc) https://github.com/azahar-emu/azahar
cd azahar
git pull --recurse-submodules -j$(nproc) || error "Could Not Pull Latest Source Code"
git submodule update --init --recursive || error "Could Not Pull All Submodules"
mkdir -p build
cd build
rm -rf CMakeCache.txt
case "$__os_codename" in
bionic | focal)
  cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_OPENGL=ON -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_COMPILER=clang-14 -DCMAKE_CXX_COMPILER=clang++-14
  ;;
*)
  cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_OPENGL=ON -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
  ;;
esac
if [ "$?" != 0 ]; then
  # add debug logs about integrity of repo
  git fsck --no-dangling --full
  git submodule foreach --recursive git fsck --no-dangling --full
  error "Calling cmake failed"
fi

make -j$(nproc) || error "Compilation failed"
sudo make install || error "Make install failed"

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
