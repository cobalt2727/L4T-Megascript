clear
cd ~
mkdir L4T-Megascript-Assets/
cd L4T-Megascript-Assets/

echo "Would you like to update autoconfigs from the Megascript GitHub?"

read -p "(y/n): " userInput

echo "you have chosen $userInput"

if [[ $userInput == y || $userInput == Y ]]; then
  echo "This is where the initial setup script will be!"
  
  #echo "Would you like to update everything all at once?"
  #echo "This can and will overwrite controller profiles, wallpapers, etc."
  #echo
  
  echo "Downloading ALL files from the Megascript GitHub..."
  echo "If you'd like to interrupt this, press Ctrl + C
  svn checkout https://github.com/$repository_username/L4T-Megascript/trunk/assets

elif [[ $userInput == 1 ]]; then
  echo "Returning you to the main menu since you typed something other than Y..."
