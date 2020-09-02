clear
echo "Minecraft Bedrock script started!"
echo "this will probably currently fail and give you a warning about broken dependencies. it currently doesn't support 64-bit ARM, which the switch uses. we're working on it"
sleep 1
##department of redundancy department
sudo dpkg --add-architecture armhf
echo "Updating sources..."
sleep 1
echo "Double-checking to see that Flatpak is installed and Flathub added..."
sleep 1
sudo apt update
sudo apt install flatpak unity-gtk-module canberra-gtk-module -y

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Installing Minecraft Bedrock..."
sudo flatpak install flathub io.mrarm.mcpelauncher -y

echo "Done!"
sleep 1
echo "Going back to the menu..."
sleep 2
