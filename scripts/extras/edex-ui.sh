clear
cd ~
echo "eDEX-UI script started!"
sleep 1
echo "Removing previous installation files..."
sudo rm -rf edex-ui/
cd /usr/share/applications
sudo rm "eDEX-UI.desktop"
cd ~
echo "Installing dependencies..."
sudo apt-get install npm* nodejs*

echo "Downloading the source..."
git clone https://github.com/GitSquared/edex-ui
cd edex-ui

npm install
##this next step gives me errors, but it works anyway...
npm run build-linux

npm run install-linux

cd /home/$USER/edex-ui/media/
sudo mkdir /usr/share/edex-ui
sudo cp logo.svg /usr/share/edex-ui
cd /usr/share/applications
sudo wget https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/eDEX-UI/eDEX-UI.desktop

echo ""
echo ""
#echo "We'll make a desktop file later, but to launch the program, navigate to /home/$USER/edex-ui/ and type 'npm start'"
echo "Done!"
echo "Settings can be modified by changing /home/$USER/.config/eDEX-UI/settings.json"
echo "Available themes to apply in the settings text file can be listed by typing 'ls /home/$USER/.config/eDEX-UI/themes'"
echo "We'll eventually maybe do this by default, but you can turn off the mouse pointer by setting the 'nocursor' variable to true inside the settings.json file"

