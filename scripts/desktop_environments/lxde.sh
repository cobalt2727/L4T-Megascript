#!/bin/bash
# all credits go out to https://github.com/jetsonhacks/installLXDE and the blogpost along with it
# there are custom changes in this script

clear -x
echo "Installing the LXDE desktop environment."
sudo apt install lxde compton libappindicator3-1 -y


# This tells LXDE to use the Compton compositor
sudo dd of=/etc/xdg/autostart/lxde-compton.desktop << EOF
[Desktop Entry]
Type=Application
Name=Compton (X Compositor)
GenericName=X compositor
Comment=A X compositor
TryExec=compton
Exec=compton --backend glx -b
OnlyShowIn=LXDE
EOF

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."