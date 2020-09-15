echo "You are about to install a new desktop environment. Under most cases this shouldn't break anything and install alongside of your existing one, but just to be sure..."
echo "Are you sure you want to continue?"

##prompt yes/no
sudo apt update
sudo apt install mate-desktop-environment mate-desktop-environment-extras ubuntu-mate-themes -y


sudo systemctl restart gdm
