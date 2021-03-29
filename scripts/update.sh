#!/bin/bash

clear
echo "Updater script successfully started!"
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
##this updater will fail if the user doesn't have npm installed so there's no harm in adding it, as it's used by some scripts here
sudo npm install -g npm

echo "Anything you've installed from source will"
echo "have to be manually recompiled until/unless we"
echo "get an automatic updater for those programs running."
##maybe somehow add a way to automatically re-run scripts for things that were built from source?


##echo "Placeholder for the RetroPie updater (we NEED to y/n prompt this if we decide to add it)"
##sudo ~/RetroPie-Setup/retropie_packages.sh setup update_packages
sleep 1


echo "Done! Sending you back to the main menu..."
sleep 4
