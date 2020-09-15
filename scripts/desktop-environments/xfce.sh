clear
echo "You are about to install the UKUI desktop environment."
echo "Under most cases this shouldn't break anything and install alongside of your existing desktop, but just to be sure..."
echo "Are you sure you want to continue?"

##prompt yes/no
sudo apt update
sudo apt install xfce4 xfce4-goodies -y

echo "If your screen goes black, don't panic, that's normal. Give it a minute..."
sleep 5

sudo systemctl restart gdm
echo "Going back to the main menu..."
sleep 1
