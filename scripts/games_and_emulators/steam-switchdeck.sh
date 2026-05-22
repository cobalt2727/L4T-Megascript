#!/bin/bash

echo "Steam (via SildurFX's Switchdeck project) script started!"
sleep 1

echo "Making sure box64 is installed..."
bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/box64.sh)" || exit $?

bash -c "$(curl -s https://raw.githubusercontent.com/SildurFX/Switchdeck/main/install-steam.sh)" || error "Failed to install Switchdeck!"

if [[ $gui == "gui" ]]; then
  if yad --class L4T-Megascript --name "L4T Megascript" --center --image "dialog-information" --width="500" --height="250" --title "Steam is now installed! " \
    --text "To get your games set up, there's some extra work you'll have to do. \
    \nWe just did the installation step for you, but the rest of Sildur's documentation to configure Steam will have to be followed manually. \
    \n\nFor support, please create an <a href=\"https://github.com/SildurFX/Switchdeck/issues\">Issue in the Switchdeck repo</a> or ask for help in #steam-on-arm in the <a href=\"https://wiki.switchroot.org/wiki#resources\">Linux 4 Switch Discord Server</a>. \
    \nA web browser will launch with the instructions after you hit OK!" --window-icon=/usr/share/icons/L4T-Megascript.png
  then
    setsid x-www-browser "https://github.com/SildurFX/Switchdeck#installation" >/dev/null 2>&1 &
  fi
else
  clear
  cat <<EOF | fold -s -w "${COLUMNS:-80}"
Steam is now installed! To get your games set up, please visit the following link by holding CTRL and clicking it:
https://github.com/SildurFX/Switchdeck#installation

We just did the installation step for you, but the rest of the documentation will have to be followed manually per Sildur's directions above.
For support, please create an Issue in the Switchdeck repo (https://github.com/SildurFX/Switchdeck/issues)
or ask for help in #steam-on-arm in the Linux 4 Switch Discord Server (https://wiki.switchroot.org/wiki#resources).

EOF
  if [ -t 0 ]; then
    read -n 1 -p "Press any key to continue" mainmenuinput
    echo ""
  else
    echo "Non-interactive environment detected, skipping user prompt to open documentation."
  fi
fi

