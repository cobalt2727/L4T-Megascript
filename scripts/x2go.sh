#!/bin/bash

echo "X2Go script started!"

if grep -q ubuntu /etc/os-release; then
  ppa_name="x2go/ppa" && ppa_installer
  sudo apt install -y x2goserver x2goclient x2gobroker-daemon x2godesktopsharing pyhoca-gui pyhoca-cli

elif grep -q debian /etc/os-release; then
# https://wiki.x2go.org/doku.php/wiki:repositories:debian
  sudo apt install extrepo -y
  #does this line prompt yes/no?
  sudo extrepo enable x2go && sudo apt update
  #probably want to run a sed command to switch to nightly packages as per https://wiki.x2go.org/doku.php/wiki:development:nightly-builds#nightly-builds_for_debian_gnu_linux
  sudo apt install x2go-keyring -y && sudo apt update
  sudo apt install -y x2goserver x2goclient x2gobroker-daemon x2godesktopsharing pyhoca-gui pyhoca-cli

elif grep -q fedora /etc/os-release; then
  echo ""
  #add later
fi

#TODO: copy desktop detection from ocs-url script for https://wiki.x2go.org/doku.php/wiki:advanced:desktopbindings
