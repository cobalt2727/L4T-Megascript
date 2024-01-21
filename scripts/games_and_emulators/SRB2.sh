#!/bin/bash

status "SRB2 script started!"

#nuke pre-rewrite files (save data is unaffected)
sudo rm -rf /usr/share/SRB2/ ~/SRB2-master/ ~/SRB2-DT/ ~/SRB2-A/ ~/SRB2-Data/

#prep folders
cd /tmp
sudo rm -rf srb2* SRB2*
cd /usr/share/applications
sudo rm "Sonic Robo Blast 2.desktop"
cd ~/RetroPie/roms/ports
rm SRB2_retropie.sh
cd ~

status "Installing dependencies..."
case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
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
# lastversion download stjr/srb2 --assets --filter Full.zip
wget $(curl --silent "https://api.github.com/repos/STJr/SRB2/releases/latest" | grep "SRB2" | grep "Full" | cut -c 31- | cut -d '"' -f 2)
unzip -o SRB2-v*-Full.zip "*.dta" "*.pk3" "*.dat" "models/*" -d SRB2-Assets/
sudo rm SRB2-v*-Full.zip

#lastversion download stjr/srb2 --source
#mkdir SRB2-Source-Code
#tar -xzvf srb2-SRB2_release_*.tar.gz -C SRB2-Source-Code --strip-components=1
#rm srb2*tar.gz
# STJR's CMakeLists.txt fails if the source folder isn't a git folder - missing a /HEAD file or something. so instead...
git clone https://github.com/stjr/srb2 --depth=1 -j$(nproc) SRB2-Source-Code || error "Failed to download assets!"
mkdir -p SRB2-Source-Code/build/ SRB2-Source-Code/assets/installer
cd SRB2-Source-Code/build/
sudo rm -rf *

status "Compiling the game..."
cmake .. -DCMAKE_INSTALL_PREFIX="/usr/local/SRB2/" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native
make -j$(nproc) || error "Compilation failed!"
status_green "Game compiled!"
sudo make install || error "Installation failed!"
status_green "Game installed!"
cd ~

status "Setting up desktop files..."
#create a blank dedicated server script file so people aren't confused where to put it
mkdir -p /tmp/SRB2-Megascript-Assets/
cd /tmp/SRB2-Megascript-Assets/
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/SRB2.sh
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/SRB2Icon.png
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/Sonic%20Robo%20Blast%202.desktop
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/config.cfg
wget https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/dedicated-server-howto.txt

sudo mv SRB2.sh /usr/local/SRB2/SRB2.sh || error "The game installed, but we couldn't properly set up one or more desktop files!"
sudo mv SRB2Icon.png /usr/local/SRB2/SRB2Icon.png || error "The game installed, but we couldn't properly set up one or more desktop files!"
#why would I bother testing if I formatted spaces correctly when I can just wildcard
sudo mv *.desktop /usr/share/applications/ || error "The game installed, but we couldn't properly set up one or more desktop files!"
#don't break the user's configs if they already have one in there
mv -vn config.cfg ~/.srb2/config.cfg || error "The game installed, but we couldn't properly set up one or more desktop files!"

#hardly anyone will use this but I'm putting it in anyway. it's neat.
xdg-open /usr/local/SRB2/
sudo mv dedicated-server-howto.txt /usr/local/SRB2/dedicated-server-howto.txt && sudo touch /usr/local/SRB2/adedserv.cfg

status "Erasing temporary build files to save space..."
sudo mv /tmp/SRB2-Assets/* /usr/local/SRB2/ || error "The game installed, but we couldn't properly set up one or more desktop files!"
sudo rm -rf /tmp/SRB2* /tmp/srb2*
echo

status "Sending you back to the main menu..."
