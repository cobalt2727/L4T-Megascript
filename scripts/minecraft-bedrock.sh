clear
echo "Minecraft Bedrock script started!"
sleep 1
##department of redundancy department
sudo dpkg --add-architecture armhf
echo "Updating sources..."
sleep 1
echo "Double-checking to see that Flatpak is installed and Flathub added..."
sleep 1
sudo apt update
sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Installing Minecraft Bedrock..."
sudo flatpak install flathub io.mrarm.mcpelauncher -y

echo "Done!"
sleep 1
echo "Going back to the menu..."
sleep 2
