clear
echo "Updater script successfully started! Running updates..."
sleep 1
apt update
apt upgrade -y
apt autoremove -y
flatpak update -y
##maybe somehow add a way to automatically re-run scripts for things that were built from source?
echo "Done! Sending you back to the main menu..."
sleep 4
