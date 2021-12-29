#!/bin/bash

clear -x
echo "Dolphin script successfully started!"
sleep 1

echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
sudo apt install udev libudev1 libudev-dev -y
sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo touch /etc/udev/rules.d/51-gcadapter.rules
echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules > /dev/null
sudo udevadm control --reload-rules
sudo systemctl restart udev.service
cd ~

echo "What would you like to do?"
echo -e "\e[36mNote that a FIRST-TIME install can take up to 40-60 minutes on a Switch.\e[0m"
echo -e "\e[1;31mConnect your Switch to a charger!\e[0m"
echo -e "\e[1;33mPlease close down ALL OTHER PROGRAMS while installing Dolphin to prevent crashes.\e[0m"
echo
echo
sleep 2
# ##echo "3...............Build other variants of Dolphin from source (Primehack, Project+, etc)"
# #echo "5...............Install Project+ (builds correctly, performance untested, PROBABLY SLOW)"

table=('Install Dolphin (use the updater on the main menu to update!)' "Run the RiiConnect24 Patcher")
description="What would you like to do?\
\nNote that a FIRST-TIME install of Dolphin can take up to 40-60 minutes on a Switch.\
\n\nConnecting your Switch to a charger is recommended.\
\n\nYour Choices of Install are:"
userinput_func "$description" "${table[@]}"


if [[ $output == 'Install Dolphin (use the updater on the main menu to update!)' ]]; then
	echo "Building from source with device-specific optimizations..."
	cd ~
	bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/install.sh)"
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/config.sh)"

elif [[ $output == "Run the RiiConnect24 Patcher" ]]; then
  sudo apt install xdelta3 -y
  bash -c "$(curl -s https://raw.githubusercontent.com/RiiConnect24/RiiConnect24-Patcher/master/RiiConnect24Patcher.sh)"


elif [[ $userInput == 3 ]]; then
  echo "not ready yet"
  sleep 3
  ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/primehack.sh)"

elif [[ $userInput == 4 ]]; then
  echo "not ready yet"
  sleep 3
  ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/slippi.sh)"

elif [[ $userInput == 5 ]]; then
  echo "Loading Project+ script..."
  sleep 3
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/projectplus.sh)"  

fi

echo "Sending you back to the main menu..."
sleep 3
