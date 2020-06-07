clear
echo "Updater script successfully started! Running updates..."
sleep 1
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo flatpak update
echo "Done! Sending you back to the main menu..."
sleep 5
bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/core.sh)"
