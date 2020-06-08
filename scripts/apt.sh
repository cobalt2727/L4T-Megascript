clear
echo "Updater script successfully started! Running updates..."
sleep 1
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo flatpak update -y
echo "Done! Sending you back to the main menu..."
sleep 4
