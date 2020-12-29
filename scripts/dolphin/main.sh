echo "Dolphin script successfully started!"
sleep 1
echo "What would you like to do?"
echo
echo
echo "1...............Install Dolphin (use the updater on the main menu to update!)"
##echo "2...............Build other variants of Dolphin from source (Primehack, Project+, etc)"
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
  echo "not ready yet"
  sleep 3
  ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/primehack.sh)"

elif [[ $userInput == 3 ]]; then
  echo "not ready yet"
  sleep 3
  ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/slippi.sh)"

elif [[ $userInput == 4 ]]; then
  echo "not ready yet"
  sleep 3
  ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/projectplus.sh)"

else
  echo ""
  
fi

echo "Sending you back to the main menu..."
sleep 3
