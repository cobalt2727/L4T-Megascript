echo "Dolphin script successfully started!"
sleep 1
##echo "What would you like to do?"
##echo
##echo
##echo "1...............Install Dolphin from the Ubuntu PPA (use the updater on the main menu to update!)"
##echo "2...............Download my latest autoconfigs for Dolphin for the Switch"
##echo "  -graphics settings"
##echo "  -game-specific controller profiles"
##echo "  -custom user interface"
##echo "3...............NOT IMPLEMENTED YET AND WON'T BE FOR A WHILE - Build other variants of Dolphin from source (Primehack, Project+, etc)"
##echo "any other key...Close the Dolphin script and return to the main menu"
##echo
##echo

##read -p "Make a selection: " userInput

##echo "you have chosen $userInput"
##if [[ $userInput == 1 ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/install.sh)"

##elif [[ $userInput == 2 ]]; then
##  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/config.sh)"

##else
##  echo ""
  
##fi
echo "Sending you back to the main menu..."
