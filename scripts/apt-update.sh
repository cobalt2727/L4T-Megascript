clear
echo "Running updates..."
sleep 1
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo flatpak update
curl https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/core.sh | bash
