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
sudo cat <<EOF > supermodel.desktop
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=supermodel
Name=Supermodel
Comment=A Sega Model 3 Arcade Emulator
Categories=Game;Emulator;
EOF
echo "The emulator can be found at ~/Supermodel3/bin/supermodel - enjoy!"
