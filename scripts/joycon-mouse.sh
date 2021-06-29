#!/bin/bash


clear -x
echo "Joycon mouse script started!"
sleep 1
cd ~
sudo apt install joycond xserver-xorg-input-joystick wget -y
sudo rm -rf /usr/share/X11/xorg.conf.d/50-joystick.conf
wget https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/50-joystick.conf && sudo mv 50-joystick.conf /usr/share/X11/xorg.conf.d

echo "Done! Restart your Switch when you're ready to gain access to using your joycons as a mouse."

sleep 2
