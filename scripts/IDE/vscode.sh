#!/bin/bash


clear -x
arch=$(dpkg --print-architecture)
echo "Installing the $arch build of Visual Studio Code directly from Microsoft..."
sleep 1

##need a newer debugger?
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt update

##i'd be surprised if the first two weren't already installed, but...
sudo apt install wget gpg gdb -y

case $arch in
    "arm64"|"armhf"|"amd64")
    sudo sh -c "cat > /etc/apt/sources.list.d/vscode.list << _EOF_
deb [arch=$arch] http://packages.microsoft.com/repos/code stable main
_EOF_"
    sudo apt update
    sudo apt install code -y
    echo "Done! You can now launch VS Code from your app list or by typing 'code' into a terminal."
    ;;
    *)
    echo "Not installing VS-Code, your architecture isn't supported"
    ;;
esac

echo "Done! Going back to the main menu..."
