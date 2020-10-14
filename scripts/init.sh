clear
echo "Initial setup script started!"
cd ~
sleep 2

echo "Checking for updates and installing a few extra recommended packages."
echo "This might take a while, depending on your internet speed."
echo "Pull up a chair!"
echo "CREDITS:"
echo "  https://gbatemp.net/threads/l4t-ubuntu-applcation-install-guides.537579/"
echo "  Optional tab on https://gbatemp.net/threads/installing-moonlight-qt-on-l4t-ubuntu.537429/"
sleep 10
#allow support for 32-bit architecture
sudo dpkg --add-architecture armhf

#bionic's flatpak app is out of date, i'll probably leave this line in even after the focal upgrade as long as it's not hurting anything
sudo add-apt-repository ppa:alexlarsson/flatpak

#updates whee
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

#install some recommended dependencies - the fonts packages are there to support a lot of symbols and foreign language characters
sudo apt install wget indicator-cpufreq flatpak gnome-software-plugin-flatpak openssh-sftp-server fonts-migmix fonts-noto-color-emoji -y

#automatically sets QT applications to follow the system theme
grep -qxF 'export QT_QPA_PLATFORMTHEME=gtk2' ~/.profile || echo 'export QT_QPA_PLATFORMTHEME=gtk2' | sudo tee --append ~/.profile
#and now i force it on anyway so that the user doesn't have to reboot to see the effect
export QT_QPA_PLATFORMTHEME=gtk2

#if you're reading this and i haven't credited Faster Melee for this file in the README yet, please yell at me -Cobalt
echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
cd /etc/udev/rules.d/
wget https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/51-gcadapter.rules
cd ~

#kinda hard to install flatpaks without flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sleep 1

clear
echo "Do you want to install the swapfile (You need 2 GB. Very important to avoid lag and potential crashes)"
read -p "(y/n) " userInput
if [[ $userInput == y || $userInput == Y ]]; then
echo "Installing the swapfile..."
bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/swapfile.sh)"
elif [[ $userInput == n || $userInput == N ]]; then
echo "Skipping swapfile setup..."
fi
sleep 1

clear
echo "Do you want to install configurations that will let you use the joycons as a mouse?"
read -p "(y/n) " userInput
if [[ $userInput == y || $userInput == Y ]]; then
echo "Installing the Joycon Mouse..."
bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/joycon-mouse.sh)"
elif [[ $userInput == n || $userInput == N ]]; then
echo "Going to the next option"
fi
sleep 1

clear
echo "Do you want to build and install SDL2? (Required for many games in the script)"
read -p "(y/n) " userInput
if [[ $userInput == y || $userInput == Y ]]; then
echo "Building and installing SDL2..."
bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
elif [[ $userInput == n || $userInput == N ]]; then
echo "Going to the next option"
fi
sleep 1

clear
echo "Placeholder for the overclock script (Coming Soon™)"
sleep 1


echo "All done! Would you like to restart now?"
echo "Required for some of the init script's components to take effect. (y/n)"
sleep 1
read -p "Make a selection: " userInput

if [[ $userInput == y || $userInput == Y ]]; then
reboot
elif [[ $userInput == n || $userInput == N ]]; then
echo "Sending you back to the main menu..."
sleep 3
