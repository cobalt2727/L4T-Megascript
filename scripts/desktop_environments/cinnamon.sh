#!/bin/bash
clear -x
echo "You are about to install the Cinnamon desktop environment."
if package_installed libappindicator3-1 ; then
  sudo apt install cinnamon-desktop-environment libappindicator3-1 -y || error "Could not install dependencies"
else
  sudo apt install cinnamon-desktop-environment libayatana-appindicator3-1 -y || error "Could not install dependencies"
fi

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."
