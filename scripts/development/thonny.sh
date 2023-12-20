#!/bin/bash

echo "Thonny script started!"
#do NOT add ubuntu-toolchain-r/ppa, known slightly broken python3.6

echo "Installing dependencies..."

case "$__os_codename" in
bionic)
  ubuntu_ppa_installer "deadsnakes/ppa" || error "PPA failed to install"
  sudo apt install python3.8 libpython3.8 -y
  ;;
focal)
  sudo apt install python3.9 libpython3.9 -y
  ;;
esac

package_available python-is-python3
if [[ $? == "0" ]]; then
  sudo apt install -y python-is-python3 || error "Could not install dependencies"
fi
sudo apt install python3 python3-pip thonny -y

echo "Done!"
echo "Sending you back to the main menu..."
sleep 1
