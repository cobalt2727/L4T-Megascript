#!/bin/bash

clear
echo "Dolphin script successfully started!"
sleep 1

echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
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
echo "1...............Install Dolphin (use the updater on the main menu to update!)"
echo "2...............Run the RiiConnect24 Patcher"
##echo "3...............Build other variants of Dolphin from source (Primehack, Project+, etc)"
echo "5...............Install Project+ (builds correctly, performance untested, PROBABLY SLOW)"
echo "any other key...Close the Dolphin script and return to the main menu"
echo
echo

read -p "Make a selection: " userInput

echo "you have chosen $userInput"
if [[ $userInput == 1 ]]; then
  
  
  ##if grep -q bionic /etc/os-release; then
	##echo "Ubuntu 18.04 detected, using the PPA..."
    
    	##echo "Making sure software-properties-common is installed..."
	##sudo apt install software-properties-common -y

	##echo "Making sure the Dolphin PPA is installed..."
	##sudo apt-add-repository ppa:dolphin-emu/ppa -y

	##sudo apt update
	##sudo apt install dolphin-emu-master -y

  ##else
	echo "Building from source with device-specific optimizations..."
	
	cd ~
	bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/install.sh)"
  ##fi
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/config.sh)"


elif [[ $userInput == 2 ]]; then
  sudo apt install xdelta3 -y
  bash -c "$(curl -s https://raw.githubusercontent.com/RiiConnect24/RiiConnect24-Patcher/master/RiiConnect24Patcher.sh)"


elif [[ $userInput == 3 ]]; then
  echo "not ready yet"
  sleep 3
  ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/primehack.sh)"


elif [[ $userInput == 4 ]]; then
  echo "not ready yet"
  sleep 3
  ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/slippi.sh)"


elif [[ $userInput == 5 ]]; then
  echo "Loading Project+ script..."
  sleep 3
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/projectplus.sh)"


else
  echo ""
  
fi

echo "Sending you back to the main menu..."
sleep 3
