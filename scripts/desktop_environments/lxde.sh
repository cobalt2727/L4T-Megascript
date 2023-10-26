#!/bin/bash
# all credits go out to https://github.com/jetsonhacks/installLXDE and the blogpost along with it
# there are custom changes in this script

clear -x
echo "Installing the LXDE desktop environment."
if package_installed libappindicator3-1 ; then
  sudo apt install lxde lxappearance compton libappindicator3-1 notify-osd -y || error "Could not install dependencies"
else
  sudo apt install lxde lxappearance compton libayatana-appindicator3-1 notify-osd -y || error "Could not install dependencies"
fi

# This tells LXDE to use the Compton compositor
sudo dd of=/etc/xdg/autostart/lxde-compton.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Compton (X Compositor)
GenericName=X compositor
Comment=A X compositor
TryExec=compton
Exec=compton --backend glx -b
OnlyShowIn=LXDE
EOF

if [[ $(grep -L "cairo-dock" /etc/xdg/openbox/autostart) ]]; then
  echo "removing extra openbox listing from available desktops"
  sudo rm -rf /usr/share/xsessions/openbox.desktop
fi

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."
