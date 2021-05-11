#!/bin/bash


clear
echo "On this page we've got a lineup of most of the major desktops used across Linux distributions."
echo "Tired of how your default homescreen looks? You're in the right place!"
echo "Before proceeding it's recommended to do some research on the Linux desktop environments below."
echo "Know what you're getting into and compare their appearance, customization options, and"
echo "most importantly, performance between each one before choosing the one that's best for you."
sleep 5

echo
echo "We've got the following options:"
echo "- Budgie"
echo "- Cinnamon"
if grep -q bionic /etc/os-release; then
  echo "- Gnome (the default desktop on Ubuntu 20.04)"
else  
  echo "- Gnome (your default desktop)"
fi
echo "- KDE Plasma"
echo "- LXDE"
echo "- LXQT"
echo "- MATE"
echo "- Ukui"
echo "- XFCE"
if grep -q bionic /etc/os-release; then
  echo "- Unity (your default desktop)"
else  
  echo "- Unity (the old default desktop from Ubuntu 18.04)"
fi



read -p "Make a selection: " userInput

echo "you have chosen $userInput"

if [[ $userInput == budgie || $userInput == Budgie ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/budgie.sh)"
  
elif [[ $userInput == cinnamon || $userInput == Cinnamon ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/cinnamon.sh)"

elif [[ $userInput == gnome || $userInput == Gnome ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/gnome.sh)"

elif [[ $userInput == kde || $userInput == KDE || $userInput == kde plasma || $userInput == KDE Plasma || $userInput == plasma || $userInput == Plasma ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/cinnamon.sh)"

elif [[ $userInput == lxde || $userInput == LXDE ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/lxde.sh)"

elif [[ $userInput == lxqt || $userInput == LXQT ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/lxqt.sh)"

elif [[ $userInput == mate || $userInput == MATE ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/mate.sh)"

elif [[ $userInput == ukui || $userInput == UKUI ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/ukui.sh)"

elif [[ $userInput == unity || $userInput == Unity ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/unity.sh)"

elif [[ $userInput == xfce || $userInput == XFCE ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/desktop_environments/xfce.sh)"

else
  echo "Unidentified input detected, throwing you back to the main menu..."
  sleep 5
  exit 0
fi
