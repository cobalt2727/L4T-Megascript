#!/bin/bash

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&
  sudo apt-get install -y nodejs

sudo npm install -g npm@latest electron@latest

cd /tmp/
sudo rm -rf app/
wget https://repo.modloader64.com/launcher/update/app.zip
unzip app.zip

cd app/
# mv app/ $FILEPATH

electron index.js
