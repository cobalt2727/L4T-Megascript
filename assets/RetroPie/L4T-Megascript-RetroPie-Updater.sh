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

window_id=$(xdotool getactivewindow || true)
xdotool key F11 --window $window_id || true

sudo -k
state="0"
while [[ "$state" == "0" ]]; do
  zenity --password | sudo -S echo "" 2>&1 >/dev/null | grep -q "incorrect"
  state=$?
done

xdotool key F11 --window $window_id || true

unset functions_downloaded
source <(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/functions.sh)
[[ ! -z ${functions_downloaded+z} ]] && status "Functions Loaded" || error_fatal "Oh no! Something happened to your internet! Exiting the Megascript, pleast fix your internet and try again!"

echo "Updating RetroPie binaries only..."
curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/retropie_auto.sh | bash -s "install_binaries"