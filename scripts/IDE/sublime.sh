#!/bin/bash

echo "Sublime script started!"
echo "Credits: literally just https://www.sublimetext.com/docs/3/linux_repositories.html"
sleep 3

echo "Installing dependencies..."
sudo apt-get install wget apt-transport-https

echo "Installing the GPG key..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

echo "Configuring the stable channel repository for Sublime..."
echo "If you own a license for it and want to use the dev version, you'll have to look up how to set that up yourself."
sleep 3
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

echo "Installing Sublime..."
sudo apt-get update
sudo apt-get install sublime-text

echo "Done!"
echo "Sending you back to the main menu.."
sleep 1
