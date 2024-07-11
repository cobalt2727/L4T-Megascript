#!/bin/bash

clear -x
arch=$(dpkg --print-architecture)
echo "Installing the $arch build of Visual Studio Code directly from Microsoft..."
sleep 1

if
  command -v apt >/dev/null
then

  case "$__os_codename" in
  bionic | focal | jammy)
    ##need a newer debugger?
    ubuntu_ppa_installer "ubuntu-toolchain-r/test" || error "PPA failed to install"
    ;;
  esac
  sudo apt install wget gpg gdb apt-transport-https -y

  case $arch in
  "arm64" | "armhf" | "amd64")
    sudo sh -c "cat > /etc/apt/sources.list.d/vscode.list << _EOF_
deb [arch=$arch] http://packages.microsoft.com/repos/code stable main
_EOF_"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    rm -rf packages.microsoft.gpg
    sudo apt update
    sudo apt install code -y
    ;;
  *)
    echo "Not installing VS Code, your architecture isn't supported"
    ;;
  esac

elif
  command -v dnf >/dev/null
then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
  sudo dnf check-update
  sudo dnf install -y code || error "Failed to install VS Code!"

else
  error_user "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

echo "Done! You can now launch VS Code from your app list or by typing 'code' into a terminal."
sleep 3
