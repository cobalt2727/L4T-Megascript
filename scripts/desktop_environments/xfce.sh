#!/bin/bash

clear -x
echo "Installing the XFCE desktop environment."

##prompt yes/no
sudo apt install xfce4 xfce4-goodies bluetooth pulseaudio-module-bluetooth blueman -y || error "Could not install dependencies"
package_available xfce4-volumed
if [[ $? == "0" ]]; then
  sudo apt install -y xfce4-volumed || error "Could not install dependencies"
fi

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."
