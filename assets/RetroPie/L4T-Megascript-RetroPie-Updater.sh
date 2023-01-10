#!/bin/bash

if [ -v $repository_username ] || [ $repository_username == cobalt2727 ]; then
  export repository_username=cobalt2727
else
  echo "Developer Mode Enabled! Repository = $repository_username"
fi
if [ -v $repository_branch ] || [ $repository_branch == master ]; then
  export repository_branch=master
else
  echo "Developer Mode Enabled! Branch = $repository_branch"
fi

hexNum=$(wmctrl -lp | grep "$(pidof gnome-terminal-server)" | grep "Terminal" | head -n 1 | awk {'print $1}')
xdotool windowactivate --sync $(($hexNum)) key F11

sudo -k
state="0"
while [[ "$state" == "0" ]]; do
  zenity --password | sudo -S echo "" 2>&1 >/dev/null | grep -q "incorrect"
  state=$?
done

xdotool windowactivate --sync $(($hexNum)) key F11

function error_fatal {
  echo -e "\\e[91m$1\\e[39m"
  sleep 10
  exit 1
}

#load functions from github source
unset functions_downloaded
source <(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/functions.sh)
[[ ! -z ${functions_downloaded+z} ]] && status "Functions Loaded" || error_fatal "Oh no! Something happened to your internet! Exiting the Megascript, please fix your internet and try again!"

echo "Updating RetroPie binaries only..."
curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/retropie_auto.sh | bash -s "install_binaries"
