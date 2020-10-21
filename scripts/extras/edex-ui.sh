clear
cd ~
echo "eDEX-UI script started!"
sleep 1
echo "Installing dependencies..."

sudo apt-get install npm* nodejs*

echo "Downloading the source..."
git clone https://github.com/GitSquared/edex-ui
cd edex-ui

npm install
##this next step gives me errors, but it works anyway...
npm run build-linux

npm run install-linux

echo "We'll make a desktop file later, but to launch the program, navigate to /home/$USER/edex-ui/ and type 'npm start'"
#note: the icon should already be in an assets folder somewhere
cd ~
