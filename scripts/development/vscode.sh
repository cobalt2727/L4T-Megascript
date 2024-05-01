#!/bin/bash

clear -x
arch=$(dpkg --print-architecture)
echo "Installing the $arch build of Visual Studio Code directly from Microsoft..."
sleep 1


case "$__os_codename" in
bionic|focal|jammy)
  ##need a newer debugger?
  ubuntu_ppa_installer "ubuntu-toolchain-r/test" || error "PPA failed to install"
  ;;
esac
##i'd be surprised if the first two weren't already installed, but...
sudo apt install wget gpg gdb -y

case $arch in
"arm64" | "armhf" | "amd64")
  sudo sh -c "cat > /etc/apt/sources.list.d/vscode.list << _EOF_
deb [arch=$arch] http://packages.microsoft.com/repos/code stable main
_EOF_"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  rm -rf packages.microsoft.gpg
  sudo apt update
  sudo apt install code -y
  echo "Done! You can now launch VS Code from your app list or by typing 'code' into a terminal."
  ;;
*)
  echo "Not installing VS-Code, your architecture isn't supported"
  ;;
esac

echo "Done! Going back to the main menu..."
