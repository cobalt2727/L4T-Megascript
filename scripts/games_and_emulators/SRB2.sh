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
sudo rm -rf /usr/local/SRB2/models
cd ~

status "Installing dependencies..."
case "$__os_id" in
Raspbian | Debian | Ubuntu)
  sudo apt install git git-lfs gcc g++ wget libsdl2-dev libsdl2-mixer-dev cmake extra-cmake-modules subversion libupnp-dev libgme-dev libopenmpt-dev curl libcurl4-gnutls-dev libpng-dev freepats libgles2-mesa-dev -y || error "Dependency installs failed"
  ;;
Fedora)
  sudo dnf install -y wget cmake gcc gcc-c++ unzip git git-lfs SDL2-devel SDL2_mixer-devel libcurl-devel libopenmpt-devel game-music-emu-devel libpng-devel zlib-devel || error "Dependency installs failed"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.srb2.org/wiki/Source_code_compiling/CMake if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

cd /tmp
status "Downloading game source code..."
# STJR's CMakeLists.txt fails if the source folder isn't a git folder - missing a /HEAD file or something. so instead...
git clone https://github.com/stjr/srb2 --depth=1 -j$(nproc) SRB2-Source-Code || error "Failed to download assets!"
mkdir -p SRB2-Source-Code/build/ SRB2-Source-Code/assets/
rm -rf /tmp/SRB2-Source-Code/assets/installer

status "Downloading assets..."
#this needs git-lfs installed due to how the assets are hosted
git clone --depth=1 https://git.do.srb2.org/STJr/srb2assets-public.git -b SRB2_2.2 /tmp/SRB2-Source-Code/assets/installer/
rm -rf /tmp/SRB2-Source-Code/assets/installer/.git*

status "Compiling the game..."
sudo rm -rf *

# GCC 7 stopped working. covering Focal for good measure
case "$__os_codename" in
bionic | focal)
  echo "Adding Ubuntu Toolchain Test PPA to install GCC 11..."
  ubuntu_ppa_installer "ubuntu-toolchain-r/test" || error "PPA failed to install"
  sudo apt install gcc-11 g++-11 build-essential libnghttp2-dev libssl-dev zlib1g-dev wget -y || error "Failed to install dependencies!"
  cd /tmp

  # 18.04's version of curl throws errors reporting that it can't connect to the master server when a dedicated server is run
  SRB2_CURL_VERSION="8.5.0" #I figure matching 24.04 is a safe bet
  wget "https://curl.se/download/curl-$SRB2_CURL_VERSION.tar.gz"
  tar -xzf "curl-$SRB2_CURL_VERSION.tar.gz"
  cd "curl-$SRB2_CURL_VERSION"
  ./configure --prefix=/usr/local --with-ssl --with-nghttp2 --with-rpath=/usr/local/lib
  make -j$(nproc) || error "Compilation failed!"
  sudo make install || error "Installation failed!"
  cd ..
  sudo ldconfig
  sudo rm -rf curl*

  # 18.04's MiniUPnPc lib is too old to work. this is really more trouble than it's worth.
  # considered submitting a PR to the source to allow the old version to work but there's probably a boatload of network vulnerabilities
  wget https://miniupnp.tuxfamily.org/files/miniupnpc-2.2.6.tar.gz
  tar xf miniupnpc-2.2.6.tar.gz
  cd miniupnpc-2.2.6
  make -j$(nproc) || error "Compilation failed!"
  sudo make install PREFIX=/usr/local || error "Installation failed!"
  cd ..
  sudo ldconfig
  sudo rm -rf miniupnpc*

  # anyway, getting back on topic...
  cd /tmp/SRB2-Source-Code/build/
  cmake .. -DCMAKE_INSTALL_PREFIX="/usr/local/SRB2/" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11
  ;;
*)
  cd /tmp/SRB2-Source-Code/build/
  cmake .. -DCMAKE_INSTALL_PREFIX="/usr/local/SRB2/" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native
  ;;
esac

make -j$(nproc) || error "Compilation failed!"
status_green "Game compiled!"
sudo make install || error "Installation failed!"
status_green "Game installed!"
cd ~

status "Setting up desktop files..."
#create a blank dedicated server script file so people aren't confused where to put it
mkdir -p /tmp/SRB2-Megascript-Assets/
cd /tmp/SRB2-Megascript-Assets/
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/SRB2.sh
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/SRB2Icon.png
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/Sonic%20Robo%20Blast%202.desktop
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/config.cfg
wget -q --show-progress --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/SRB2-A/dedicated-server-howto.txt

sudo mv SRB2.sh /usr/local/SRB2/SRB2.sh || error "The game installed, but we couldn't properly set up one or more desktop files!"
sudo mv SRB2Icon.png /usr/local/SRB2/SRB2Icon.png || error "The game installed, but we couldn't properly set up one or more desktop files!"
#why would I bother testing if I formatted spaces correctly when I can just wildcard
sudo mv *.desktop /usr/share/applications/ || error "The game installed, but we couldn't properly set up one or more desktop files!"
#don't break the user's configs if they already have one in there
mkdir -p ~/.srb2/
test -f ~/.srb2/config.cfg || mv config.cfg ~/.srb2/config.cfg || error "The game installed, but we couldn't properly set up one or more desktop files!"

#hardly anyone will use this but I'm putting it in anyway. it's neat.
xdg-open /usr/local/SRB2/ || echo ""
sudo mv dedicated-server-howto.txt /usr/local/SRB2/dedicated-server-howto.txt && sudo touch /usr/local/SRB2/adedserv.cfg

#why does 'sudo make install' not cover this properly.
yes | sudo cp -rf /tmp/SRB2-Source-Code/assets/installer/models/ /usr/local/SRB2/models
yes | sudo cp -rf /tmp/SRB2-Source-Code/assets/installer/*.pk3 /usr/local/SRB2/
yes | sudo cp -rf /tmp/SRB2-Source-Code/assets/installer/*.dat /usr/local/SRB2/

status "Erasing temporary build files to save space..."
sudo rm -rf /tmp/SRB2* /tmp/srb2*
echo

status "Sending you back to the main menu..."
