#!/bin/bash

clear
echo "Updater script successfully started!"

############UPDATER SCANNERS - SEE BELOW FOR MANUAL UPDATERS###########
##add more of these later!

#tests if the Dolphin Emulator program exists, then ask to re-run the installer script if it's found, binding the user's response to DolphinUserInput
if test -f /usr/local/bin/dolphin-emu; then
        echo "Do you want to update Dolphin?"

        read -p "(y/n) " DolphinUserInput
fi


#######################################################################


echo "Running APT updates..."
sleep 1
sudo apt update
sudo apt upgrade -y

echo "Scanning for issues with APT packages..."
echo "If you receive a yes/no prompt in the following steps,"
echo "Make sure you carefully read over the"
echo "packages to be changed before proceeding."
echo "If not, don't worry about it."
echo "Purging, cleaning, and autoremoving are NORMALLY"
echo "fine, but double-check packages to be safe."
sleep 5
##maintenance (not passing with -y to prevent potentially breaking something for a user)
sudo dpkg --configure -a
sudo apt autoremove
sudo apt --fix-broken install
sudo apt autoclean
sudo apt autopurge

echo "Updating Flatpak packages (if you have any)..."
##two separate flatpak updaters to catch all programs regardless of whether the user installed them for the system or just the user
sudo flatpak repair
flatpak repair --user

sudo flatpak update -y
flatpak update -y

echo "Updating NPM (if you have it)..."
##this updater will fail if the user doesn't have npm installed so there's no harm in adding it
sudo npm install -g npm

echo "Marking all AppImages under ~/Applications as executable..."
chmod +x ~/Applications/*.AppImage




#################MANUAL UPDATERS - SEE ABOVE FOR SCANNERS#################

if [[ $DolphinUserInput == y || $DolphinUserInput == Y || $DolphinUserInput == yes || $DolphinUserInput == Yes ]]; then
        echo "Updating Dolphin..."
        echo -e "\e[33mTO FIX, RESET, AND/OR UPDATE CONFIGS (not game saves) YOU HAVE\e[0m"
        echo -e "\e[33mTO RE-RUN THE DOLPHIN SCRIPT FROM THE MENU\e[0m"
        sleep 5
        bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/install.sh)"
else
        echo "Skipping Dolphin updates..."
fi


##########################################################################

sleep 1

echo "Done! Sending you back to the main menu..."
sleep 4
