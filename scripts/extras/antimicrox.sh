#!/bin/bash

clear -x
echo "This script will install AntiMicroX, an updated fork of AntiMicro and"
echo "a graphical program used to map gamepad keys to keyboard."

# Dependancies
sudo apt install -y git gcc cmake extra-cmake-modules \
    qttools5-dev qttools5-dev-tools libsdl2-dev \
    libxi-dev libxtst-dev libx11-dev itstool gettext python3-libxml2 || error "Could not install dependencies"

# get the $DISTRIB_RELEASE and $DISTRIB_CODENAME by calling lsb_release
# check if upstream-release is available
if [ -f /etc/upstream-release/lsb-release ]; then
    echo "This is a Ubuntu Derivative, checking the upstream-release version info"
    DISTRIB_CODENAME=$(lsb_release -s -u -c)
    DISTRIB_RELEASE=$(lsb_release -s -u -r)
else
    DISTRIB_CODENAME=$(lsb_release -s -c)
    DISTRIB_RELEASE=$(lsb_release -s -r)
fi
case "$DISTRIB_CODENAME" in
  bionic)
    #bionic cmake is very old, use theofficialgman ppa for cmake
    ppa_name="theofficialgman/cmake-bionic" && ppa_installer
    if [[ -f "/usr/bin/cmake" ]]; then
      #remove manually installed cmake versions (as instructed by theofficialgman) only if apt cmake is found
      sudo rm -rf '/usr/local/bin/cmake' '/usr/local/bin/cpack' '/usr/local/bin/ctest'
    fi
    hash -r
    ;;
esac

hash -r

# Cloning
cd /tmp || error "No /tmp directory"
rm -rf antimicrox
git clone https://github.com/AntiMicroX/antimicrox.git --depth=1
cd antimicrox
mkdir build && cd build

# Building
cmake .. || error "Cmake failed"
make -j$(nproc) || error "Compilation failed"

# Installing
sudo make install || error "Make install failed"

# Removing source
cd ~
rm -rf /tmp/antimicrox
