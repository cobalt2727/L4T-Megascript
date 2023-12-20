#!/bin/bash

clear -x
echo "You are about to install the MATE desktop environment."
echo "Under most cases this shouldn't break anything and install alongside of your existing one, but just to be sure..."
echo "Are you sure you want to continue?"

ubuntu_ppa_installer "ubuntu-mate-dev/welcome" || error "PPA failed to install"

case "$__os_codename" in
bionic)
  echo "" ;;
*)
  ubuntu_ppa_installer "ubuntu-mate-dev/fresh-mate" || error "PPA failed to install" ;;
esac

##prompt yes/no
sudo apt install ubuntu-mate-desktop ubuntu-mate-themes plank mate-notification-daemon ubuntu-mate-welcome -y || error "Could not install dependencies"
##should we add these?
##echo "Installing extras..."
##sudo apt-get install mate-session-manager mate-themes mate-screensaver mate-power-manager mate-indicator-applet mate-indicator-applet-common mate-tweak dconf-editor mate-applet-appmenu -y

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/common.sh)"

echo "Going back to the main menu..."
