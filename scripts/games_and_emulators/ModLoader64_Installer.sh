#!/bin/bash
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&
  sudo apt-get install -y nodejs

sudo npm install -g npm@latest electron@latest
cd /usr/local/bin
sudo rm -rf app/
sudo wget https://repo.modloader64.com/launcher/update/app.zip
sudo unzip app.zip
sudo rm app.zip
cd /usr/local/share/applications
sudo bash -c 'cat <<EOF > modloader64.desktop
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=electron /usr/local/bin/app/index.js
Name=ModLoader64
Comment=ModLoader64 is a network capable mod loading system for Nintendo 64 games.
Icon=/usr/local/bin/app/ml64.png
Categories=Game;Emulator;
Name[en_US]=ModLoader64
EOF'
