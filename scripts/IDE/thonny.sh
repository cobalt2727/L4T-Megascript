#!/bin/bash


echo "Thonny script started!"
echo "Adding Ubuntu Toolchain PPA..."
sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa -y
sudo apt update

echo "Installing dependencies..."
sudo apt install python2 python2.7 python3 python3-pip thonny -y

if grep -q bionic /etc/os-release; then
  sudo apt install python3.8 libpython3.8 -y
fi

if grep -q focal /etc/os-release; then
  sudo apt install python3.9 libpython3.9 -y
fi



echo "Done!"
echo "Sending you back to the main menu..."
sleep 1
