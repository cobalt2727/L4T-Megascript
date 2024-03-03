#!/bin/bash

clear -x
echo "Dolphin script successfully started!"
sleep 1

echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
# previous line this massive case statement replaced: sudo apt install udev libudev1 libudev-dev -y || error "Failed to install dependencies!"
case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
  package_available libudev-dev #this will install on mainstream distros
  if [[ $? == "0" ]]; then
    sudo apt install -y libudev-dev udev || error "Failed to install udev development libraries!"
  fi
  package_available libeudev-dev #this is a udev replacement that works without systemd, you can't even install it on a regular Debian/Ubuntu spin
  if [[ $? == "0" ]]; then
    sudo apt install -y libeudev-dev eudev || error "Failed to install eudev development libraries!"
  fi
  ;;
Fedora)
  sudo dnf install -y systemd-devel || error "Failed to install dependencies!"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install udev development libraries yourself...\\e[39m"
  sleep 5
  ;;
esac

sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo touch /etc/udev/rules.d/51-gcadapter.rules
echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules >/dev/null
sudo udevadm control --reload-rules
sudo systemctl restart udev.service
cd ~

echo -e "\e[36mNote that a FIRST-TIME install can take up to 40-60 minutes on a Switch.\e[0m"
echo -e "\e[1;31mConnect your Switch to a charger!\e[0m"
echo -e "\e[1;33mPlease close down ALL OTHER PROGRAMS while installing Dolphin to prevent crashes.\e[0m"
echo
echo
sleep 2
# ##echo "3...............Build other variants of Dolphin from source (Primehack, Project+, etc)"
# #echo "5...............Install Project+ (builds correctly, performance untested, PROBABLY SLOW)"

table=('Install Dolphin WITH performance settings' "Install Dolphin WITHOUT performance settings")
description="What would you like to do?\
\nNote that a FIRST-TIME install of Dolphin can take up to 40-60 minutes on a Switch.\
\n\nConnecting your Switch to a charger is recommended.\
\nUsing our performance settings will REPLACE your configuration (game save data unaffected).\
\n\nYour Choices of Install are:"
userinput_func "$description" "${table[@]}"

echo "Building from source with device-specific optimizations..."
cd ~
if [[ $output == 'Install Dolphin (use our Auto Updater to update!)' ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/install.sh)" || exit $?
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/config.sh)" || exit $?

elif [[ $output == "Install Dolphin WITHOUT performance settings" ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/install.sh)" || exit $?

elif
  [[ $output == 3 ]]
then
  echo "not ready yet"
  sleep 3
##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/primehack.sh)"

elif [[ $output == 4 ]]; then
  echo "not ready yet"
  sleep 3
##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/slippi.sh)"

fi

echo "Sending you back to the main menu..."
sleep 3
