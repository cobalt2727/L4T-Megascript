#!/bin/bash

echo "Thonny script started!"
#do NOT add ubuntu-toolchain-r/ppa, known slightly broken python3.6

echo "Installing dependencies..."
sudo apt install python2 python2.7 python3 python3-pip thonny -y

if grep -q bionic /etc/os-release; then
  sudo rm /etc/alternatives/python
  sudo apt install --reinstall python-minimal -y #fix up a thing we broke
  sudo apt install python3.8 libpython3.8 -y
fi

if grep -q focal /etc/os-release; then
  sudo apt install python3.9 libpython3.9 -y
fi

if grep -q hirsute /etc/os-release; then
  sudo apt install python3.10 libpython3.10 -y
fi

echo "Done!"
echo "Sending you back to the main menu..."
sleep 1
