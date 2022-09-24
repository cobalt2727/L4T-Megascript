#!/bin/bash

echo "Thonny script started!"
#do NOT add ubuntu-toolchain-r/ppa, known slightly broken python3.6

echo "Installing dependencies..."
sudo apt install python2 python2.7 python3 python3-pip thonny -y

case "$__os_codename" in
bionic)
  sudo rm /etc/alternatives/python
  sudo apt install --reinstall python-minimal -y #fix up a thing we broke
  sudo apt install python3.8 libpython3.8 -y
  ;;
focal)
  sudo apt install python3.9 libpython3.9 -y
  ;;
esac

echo "Done!"
echo "Sending you back to the main menu..."
sleep 1
