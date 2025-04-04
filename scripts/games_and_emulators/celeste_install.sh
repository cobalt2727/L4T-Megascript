#!/bin/bash

cd /tmp || error "Could not move to /tmp folder"
status "Installing Dependencies"
sudo apt install -y libsdl2-mixer-dev libsdl2-dev libsdl2-image-dev libsndio-dev || exit 1
status "Downloading the game"
sudo rm -rf /tmp/ccleste
git clone https://github.com/lemon32767/ccleste.git --depth=1 && cd ccleste || error "Could Not Pull Latest Source Code"
rm -rf gamecontrollerdb.txt
status "Compiling the game"
make -j$(nproc) || error "Compilation failed"
wget https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt

path="/usr/local/share/celeste"

sudo rm -rf $path
sudo mkdir $path
sudo mv ccleste $path
sudo mv gamecontrollerdb.txt $path
sudo mv icon.png $path
sudo mv screenshot.png $path
sudo mv data $path

sudo tee $path/ccleste-start-fullscreen.txt <<'EOF'
True
EOF

# set file ownership
sudo chown root:root $path/* || error "Could not set file ownership"
sudo chown root:root $path/data/* || error "Could not set file ownership"

sudo rm -rf /tmp/ccleste

# remove old folder location if it exists
if [ -f /usr/share/celeste/ccleste ]; then
  sudo rm -rf /usr/share/celeste /usr/share/applications/celeste.desktop
fi

status "Adding to applications menu"

sudo tee /usr/local/share/applications/celeste.desktop <<'EOF'
[Desktop Entry]
Type=Application
Exec=/usr/local/share/celeste/ccleste
Path=/usr/local/share/celeste
Name=Celeste Classic
Icon=/usr/local/share/celeste/icon.png
Categories=Game
EOF

status_green "Game installed!"
