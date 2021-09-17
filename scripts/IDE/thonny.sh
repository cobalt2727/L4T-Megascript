#!/bin/bash


echo "Thonny script started!"
##not sure why i had these lines, i know i put them in VS Code's installer for a newer GDB, but... -cobalt
#echo "Adding Ubuntu Toolchain PPA..."
#ppa_name="ubuntu-toolchain-r/ppa" && ppa_installer

echo "Installing dependencies..."
sudo apt install python2 python2.7 python3 python3-pip thonny -y

if grep -q bionic /etc/os-release; then
  sudo apt install python3.8 libpython3.8 -y
  sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 10
  #3.8 is the most modern version 18.04's ever getting unless we use a PPA
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
