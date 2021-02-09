#!/bin/bash

clear
echo "Updater script successfully started! Running updates..."
sleep 1
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo flatpak update -y
##maybe somehow add a way to automatically re-run scripts for things that were built from source?



##echo "Placeholder for the RetroPie updater (we NEED to y/n prompt this if we decide to add it)"
##sudo ~/RetroPie-Setup/retropie_packages.sh setup update_packages
sleep 1


echo "Done! Sending you back to the main menu..."
sleep 4
