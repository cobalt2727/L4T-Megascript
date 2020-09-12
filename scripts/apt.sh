clear
echo "Updater script successfully started! Running updates..."
sleep 1
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo flatpak update -y
##maybe somehow add a way to automatically re-run scripts for things that were built from source?
echo "Done! Sending you back to the main menu..."
sleep 4
