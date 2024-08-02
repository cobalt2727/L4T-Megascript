#!/bin/bash

if command -v apt >/dev/null; then
  ubuntu_ppa_installer "phoerious/keepassxc"
  sudo apt install keepassxc -y || error "Failed to install KeePassXC!"
elif command -v dnf >/dev/null; then
  sudo dnf install keepassxc -y || error "Failed to install KeePassXC!"
else
  error "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

echo "Done!"
sleep 1
