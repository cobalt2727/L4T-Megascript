clear
echo "Joycon mouse script started!"
sleep 1
cd ~
sudo apt install xserver-xorg-input-joystick -y
sudo rm -rf /usr/share/X11/xorg.conf.d/50-joystick.conf
wget https://cdn.discordapp.com/attachments/527677698672427008/770290009638174750/50-joystick.conf && sudo mv 50-joystick.conf /usr/share/X11/xorg.conf.d

echo "Done! Restart your Switch when you're ready to gain access to using your joycons as a mouse."

sleep 2
