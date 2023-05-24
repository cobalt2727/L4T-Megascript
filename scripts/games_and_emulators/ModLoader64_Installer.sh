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
sudo wget https://download1337.mediafire.com/xc23tvmbfkjg9p8zvwUbph52N85Slb1LcQXRSLePdq-qFNOOU18AQwPceGNnvAu4bTSj58XfRUK5T-MbbBiyMZ6UFle1c-P3AM6EDKpvTDi0tleureaa3gnIZrD2GGxKmbmOLj4ViX_vJcPwyBESiSdFKjQYVyilMevh7WcT3FTiiMj6/cc7c7thkf8dvssi/ModLoader64.desktopp
