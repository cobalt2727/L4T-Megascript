#!/bin/bash
clear -x
echo "You are about to install the Budgie desktop environment."
sudo apt install budgie-core budgie-desktop budgie-indicator-applet pocillo-icon-theme ubuntu-budgie-themes -y || error "Could not install dependencies"

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."
