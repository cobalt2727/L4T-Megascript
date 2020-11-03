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
  cd ~
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/install.sh)"
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/config.sh)"


elif [[ $userInput == 2 ]]; then
  echo "not ready yet"
  sleep 3
  ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/config.sh)"

else
  echo ""
  
fi

echo "Sending you back to the main menu..."
sleep 3
