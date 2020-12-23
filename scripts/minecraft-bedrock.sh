clear
echo "Minecraft Bedrock script started!"
echo -e "\e[37myyddddddddyy++yyyy++yyddddyyddyy
ddyyyy++yy++yy++dd++++yymmddyydd
ddmmddddmmdddddd++ddyyyyyy++yyyy
yy++yyyyyymmyy++yyyyddddddddddyy
mmdd++ddddddddyyddddyy++++yyyydd
ddyyyyyyddyyyyddddmmyyyyddddmmdd
++++yyyyyy++++yyyyyy++++yy++ddmm
yyyyyyddyyyyyyddddmmddddyyddyyyy
yy++++yyddddyyyyyy++++yy++++++++
yyddddmmddyyddyyddyyyydddddd++yy
yyyy++ddyy++++ddmmdd++++++yydddd
mmyyyyyyddddyyyy++++yyyyyy++++mm
yyddddddyyyyddddyy++ddddddddddyy
yy++yy++yymmyyddddddmmddyyyy++++
yyyyyyddddyyddddyyyy++++yyddddyy
ddmmddddmm++++yyddyyyymmddddyyyy\e[0m"
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

#fix up an issue with the L4T kernel not being able to run flatpaks by enabling non-privileged user namespaces
sudo chmod u+s /usr/libexec/flatpak-bwrap

#according to the Minecraft PE Linux Launcher Discord, this line is needed to ensure the flatpak saves server lists and skins after a launcher restart
sudo flatpak override --persist=../../../data io.mrarm.mcpelauncher

echo "Done!"
sleep 1
echo "Going back to the menu..."
sleep 2
