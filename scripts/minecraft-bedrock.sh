clear
echo "Minecraft Bedrock script started!"
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
#fix up an issue with running flatpaks by enabling non-privileged user namespaces
sudo chmod u+s /usr/libexec/flatpak-bwrap

echo "Done!"
sleep 1
echo "Going back to the menu..."
sleep 2
