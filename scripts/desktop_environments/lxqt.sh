#!/bin/bash

clear -x
echo "Installing the LXQT desktop environment."

sudo apt install lxqt -y || error "Could not install dependencies"

cp /etc/xdg/openbox/lxqt-rc.xml $HOME/.config/openbox
# ~/.config/lxqt/session.conf

echo "Going back to the main menu..."
