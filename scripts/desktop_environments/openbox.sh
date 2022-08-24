#!/bin/bash
# all credits go out to https://www.lifewire.com/install-openbox-using-ubuntu-4051832
# there are custom changes in this script

clear -x
echo "Installing the Openbox desktop environment."
sudo apt install openbox obconf feh xcompmgr cairo-dock libappindicator3-1 -y

echo "Openbox Startup Script (bottom dock and autorotation script"

sudo dd of=/etc/xdg/openbox/autostart <<EOF
sh ~/.fehbg &
xcompmgr &cairo-dock -o &
EOF
sudo chmod +x /etc/xdg/openbox/autostart

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."
