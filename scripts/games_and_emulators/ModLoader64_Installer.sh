#!/bin/bash
sudo -i
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&
  sudo apt-get install -y nodejs

sudo npm install -g npm@latest electron@latest
cd /usr/local/bin
sudo rm -rf app/
wget https://repo.modloader64.com/launcher/update/app.zip
unzip app.zip
rm app.zip
cd /usr/local/share/Applications
wget https://download1337.mediafire.com/86cbfxm971bg96E-KK1kh6OuzBEMC4qZUU31v1Cp2GQKW7EKlf0jPaSXcG8CvNVMNizNIVR1WhBC-tyn415u6bk58sAJnqEQ6nhtd2LgHeIv-h0EjmMM-MVNMxDf5u5RBzjFzPDV39-rTOxv_KAZvmgUIOLLQOlBYL4UsrcWXzUa/cc7c7thkf8dvssi/ModLoader64.desktop
