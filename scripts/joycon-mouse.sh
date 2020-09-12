clear
echo "Joycon mouse script started!"
sleep 1
cd ~
sudo apt install xserver-xorg-input-joystick
wget https://cdn.discordapp.com/attachments/604648722491768883/684926248505704484/50-joystick.conf && sudo mv 50-joystick.conf /usr/share/X11/xorg.conf.d

echo "Done! Restart your Switch when you're ready to gain access to using your joycons as a mouse."

sleep 2
