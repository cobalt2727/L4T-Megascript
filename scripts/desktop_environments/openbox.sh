#!/bin/bash
# all credits go out to https://www.lifewire.com/install-openbox-using-ubuntu-4051832
# there are custom changes in this script

clear -x
echo "Installing the Openbox desktop environment."
if package_installed libappindicator3-1 ; then
  sudo apt install openbox obconf feh xcompmgr cairo-dock libappindicator3-1 -y
else
  sudo apt install openbox obconf feh xcompmgr cairo-dock libayatana-appindicator3-1 -y
fi

echo "Openbox Startup Script (bottom dock and autorotation script"

sudo dd of=/etc/xdg/openbox/autostart <<EOF
sh ~/.fehbg &
xcompmgr &cairo-dock -o &
EOF
sudo chmod +x /etc/xdg/openbox/autostart

OPENBOX_CONFIG=$HOME/.config/openbox/rc.xml
if ! test -f "$OPENBOX_CONFIG"; then
  mkdir $HOME/.config/openbox
  cp /etc/xdg/openbox/rc.xml $OPENBOX_CONFIG
fi

if ! grep -q "XF86Audio" "$OPENBOX_CONFIG"; then
  echo "Enabling Volume Buttons"
  
  LINE=$(grep -n /keyboard $OPENBOX_CONFIG | cut -d : -f 1)
  sed -i "$LINE i\
  
  " $OPENBOX_CONFIG
  sed -i "$((LINE+1)) i \ \ <!-- Volume Buttons -->" $OPENBOX_CONFIG
  sed -i "$((LINE+2)) i \ \ <keybind key=\"XF86AudioRaiseVolume\">" $OPENBOX_CONFIG
  sed -i "$((LINE+3)) i \ \ \ \ <action name=\"Execute\">" $OPENBOX_CONFIG
  sed -i "$((LINE+4)) i \ \ \ \ \ \ <execute>pactl set-sink-volume @DEFAULT_SINK@ +10%</execute>" $OPENBOX_CONFIG
  sed -i "$((LINE+5)) i \ \ \ \ </action>" $OPENBOX_CONFIG
  sed -i "$((LINE+6)) i \ \ </keybind>" $OPENBOX_CONFIG
  sed -i "$((LINE+7)) i \ \ <keybind key=\"XF86AudioLowerVolume\">" $OPENBOX_CONFIG
  sed -i "$((LINE+8)) i \ \ \ \ <action name=\"Execute\">" $OPENBOX_CONFIG
  sed -i "$((LINE+9)) i \ \ \ \ \ \ <execute>pactl set-sink-volume @DEFAULT_SINK@ -10%</execute>" $OPENBOX_CONFIG
  sed -i "$((LINE+10)) i \ \ \ \ </action>" $OPENBOX_CONFIG
  sed -i "$((LINE+11)) i \ \ </keybind>" $OPENBOX_CONFIG
fi

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."
