clear
echo "Minecraft Bedrock script started!"
echo "Currently this installs correctly, but we're having trouble getting it to run properly."
sleep 1
echo "Updating sources..."
sleep 1
echo "Double-checking to see that Flatpak is installed and Flathub added..."
sleep 1
sudo add-apt-repository ppa:alexlarsson/flatpak -y
sudo apt update
sudo apt install pulseaudio glibc-source flatpak libcanberra-gtk-module -y

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Installing Minecraft Bedrock..."
sudo flatpak install flathub io.mrarm.mcpelauncher -y

echo "Done!"
sleep 1
echo "Going back to the menu..."
sleep 2
