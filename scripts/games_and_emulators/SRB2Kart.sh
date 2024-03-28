#!/bin/bash

status "SRB2Kart script started!"

#nuke pre-rewrite files (save data is unaffected)
sudo rm -rf /usr/share/SRB2Kart/ ~/SRB2Kart-Data ~/SRB2Kart

cd ~
cd /tmp
sudo rm -rf SRB2Kart*
sudo rm -r /usr/share/SRB2Kart
sudo rm /tmp/AssetsLinuxOnly.zip
cd /usr/share/applications
sudo rm "SRB2 Kart.desktop"
cd ~

status "Installing dependencies..."
case "$__os_id" in
Raspbian | Debian | Ubuntu)
  sudo apt install gcc g++ wget libsdl2-dev libsdl2-mixer-dev cmake extra-cmake-modules subversion libupnp-dev libgme-dev libopenmpt-dev curl libcurl4-gnutls-dev libpng-dev freepats libgles2-mesa-dev -y || error "Dependency installs failed"
  ;;
Fedora)
  sudo dnf install -y wget cmake unzip git SDL2-devel SDL2_mixer-devel libcurl-devel libopenmpt-devel game-music-emu-devel libpng-devel zlib-devel || error "Dependency installs failed"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.srb2.org/wiki/Source_code_compiling/CMake if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

cd /tmp

status "Downloading game source code..."
git clone https://github.com/stjr/Kart-Public --depth=1 -j$(nproc) SRB2Kart-Source-Code || error "Failed to download assets!"
mkdir -p SRB2Kart-Source-Code/build/ SRB2Kart-Source-Code/assets/installer

status_green "Downloading assets... (Yes, it's running. Give it a little time.)"
#grepped twice because without the second one there's a comma in the first line that I'm too lazy to properly fix
wget -q --progress=bar:force:noscroll $(curl --silent "https://api.github.com/repos/STJr/Kart-Public/releases/latest" | grep "AssetsLinuxOnly" | cut -c 31- | cut -d '"' -f 2 | grep AssetsLinuxOnly.zip)
#unzip and move assets where cmake wants them
unzip /tmp/AssetsLinuxOnly.zip -d /tmp/SRB2Kart-Source-Code/assets/installer/
rm /tmp/AssetsLinuxOnly.zip

status "Compiling the game..."
cd /tmp/SRB2Kart-Source-Code/build/
sudo rm -rf *
#CMAKE_CXX_FLAGS doesn't get used for some reason. might be worth looking into at some point.
cmake .. -DCMAKE_INSTALL_PREFIX="/usr/local/SRB2Kart/" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native
make -j$(nproc) || error "Compilation failed!"
status_green "Game compiled!"
sudo make install || error "Installation failed!"
status_green "Game installed!"
cd ~

status "Setting up desktop files..."
mkdir -p /tmp/SRB2Kart-Megascript-Assets/
cd /tmp/SRB2Kart-Megascript-Assets/
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2Kart/kartconfig.cfg
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2Kart/SRB2%20Kart.desktop
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2Kart/SRB2KartIcon.png
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2Kart/SRB2Kart.sh

mkdir -p ~/.srb2kart
mv kartconfig.cfg -t ~/.srb2kart || error "The game installed, but we couldn't properly set up one or more desktop files!"
sudo mv *.desktop /usr/share/applications || error "The game installed, but we couldn't properly set up one or more desktop files!"
sudo mv SRB2KartIcon.png /usr/local/SRB2Kart/SRB2KartIcon.png || error "The game installed, but we couldn't properly set up one or more desktop files!"
sudo mv SRB2Kart.sh /usr/local/SRB2Kart/SRB2Kart.sh || error "The game installed, but we couldn't properly set up one or more desktop files!"

echo

status_green "Game Installed!"
warning "[NOTE] Remember NOT to move the SRB2Kart folder or any file inside it or the game will stop working."
warning "If the game icon doesn't appear inmediately, restart the system."
status "This message will close in 10 seconds."
sleep 10
status "Sending you back to the main menu..."
