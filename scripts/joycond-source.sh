#!/bin/bash

sudo apt install git cmake libevdev-dev -y
cd ~
git clone https://github.com/DanielOgorchock/joycond
cd joycond/
git pull
cmake .
sudo make install || error "Make install failed"
sudo systemctl enable --now joycond
cd ~
