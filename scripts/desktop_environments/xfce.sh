#!/bin/bash

clear -x
echo "Installing the XFCE desktop environment."

##prompt yes/no
sudo apt install xfce4 xfce4-goodies -y

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."
