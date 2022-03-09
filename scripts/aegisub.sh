#!/bin/bash

echo "Aegisub script started!"
echo -e "Credits: \e[36mhttps://github.com/wangqr/Aegisub\e[0m"
sleep 2

echo "Installing dependencies..."

get_system

case "$__os_id" in
    Raspbian|Debian|LinuxMint|Linuxmint|Ubuntu|[Nn]eon|Pop|Zorin|[eE]lementary|[jJ]ing[Oo][sS])
        sudo apt install make git libass-dev libboost-dev libopengl0 libicu-dev wx-common zlib1g-dev fontconfig luajit --no-install-recommends libffms2-dev libfftw3-dev libhunspell-dev libopenal-dev uchardet libuchardet-dev  -y || error "Failed to install dependencies!"
    ;;
    Fedora)
        #TODO
        sudo dnf install git -y  || error "Failed to install dependencies!"
    ;;
    *)
        echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.dolphin-emu.org/index.php?title=Building_Dolphin_on_Linux if you haven't already...\\e[39m"
        sleep 5
    ;;
esac

cd /tmp/
rm -rf /tmp/Aegisub/

git clone https://github.com/wangqr/Aegisub.git || error_user "Failed to download source code from GitHub!" 
cd Aegisub

echo "Starting the build..."
./autogen.sh || error "Aegisub's autogen script failed!"
./configure || error "Aegisub's build configuration script failed!"
make -j$(nproc) || error "make failed!"
sudo make install || error "Installation failed!"

echo "Cleaning up..."
rm -rf /tmp/Aegisub/
sleep 1

echo "Done!"
