clear
echo "Initial setup script started!"

sleep 2

echo "Checking for updates and installing a few extra recommended packages."
echo "This might take a while, depending on your internet speed."
echo "Pull up a chair!"
echo "CREDITS:"
echo "  https://gbatemp.net/threads/l4t-ubuntu-applcation-install-guides.537579/"
echo "  Optional tab on https://gbatemp.net/threads/installing-moonlight-qt-on-l4t-ubuntu.537429/"
sleep 10
sudo dpkg --add-architecture armhf
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install indicator-cpufreq flatpak gnome-software-plugin-flatpak -y

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sleep 1

clear
echo "Do you want to install the swapfile (You need 2 GB. Pretty important to avoid lag and even crashes)"
read -p "(y/n) " userInput
if [[ $userInput == y || $userInput == Y ]]; then
echo "Installing the swapfile..."
bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/swapfile.sh)"
elif [[ $userInput == n || $userInput == N ]]; then
echo "Going to the next option"
fi
sleep 1

clear
echo "Do you want to install the Joycon Mouse (It let you use the Joycons as a mouse!)"
read -p "(y/n) " userInput
if [[ $userInput == y || $userInput == Y ]]; then
echo "Installing the Joycon Mouse..."
bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/joycon-mouse.sh)"
elif [[ $userInput == n || $userInput == N ]]; then
echo "Going to the next option"
fi
sleep 1

clear
echo "Do you want to build and install SDL2? (Require for some games in the script)"
read -p "(y/n) " userInput
if [[ $userInput == y || $userInput == Y ]]; then
echo "Building and installing SDL2..."
bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/sdl2_install_helper.sh)"
elif [[ $userInput == n || $userInput == N ]]; then
echo "Going to the next option"
fi
sleep 1

clear
echo "Placeholder for getting Bluetooth audio/input and USB input working (Coming Soon)"
sleep 5

clear
echo "Placeholder for the overclock script (Coming Soon)"
sleep 5

echo "All done! Would you like to restart now? (y/n)"
read -p "Make a selection: " userInput

if [[ $userInput == y || $userInput == Y ]]; then
reboot
elif [[ $userInput == n || $userInput == N ]]; then
echo "Sending you back to the main menu..."
sleep 3
