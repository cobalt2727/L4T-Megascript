clear
echo "You are about to install the MATE desktop environment."
echo "Under most cases this shouldn't break anything and install alongside of your existing one, but just to be sure..."
echo "Are you sure you want to continue?"

##prompt yes/no
sudo apt update
sudo apt install mate-desktop-environment mate-desktop-environment-extras ubuntu-mate-themes plank -y
##should we add these?
##echo "Installing extras..."
##sudo apt-get install mate-session-manager mate-themes mate-screensaver mate-power-manager mate-indicator-applet mate-indicator-applet-common mate-tweak dconf-editor mate-applet-appmenu -y

echo "If your screen goes black, don't panic, that's normal. Give it a minute..."
sleep 5

sudo systemctl restart gdm
echo "Going back to the main menu..."
sleep 1
