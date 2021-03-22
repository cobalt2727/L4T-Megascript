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
if grep -q bionic /etc/os-release; then
  echo "Ubuntu 18.04 detected - no support for eDex-UI"
  echo "(Believe me, I tried building it myself. If you've got a cross-compiled binary, make a PR! -Cobalt)"
  echo "You'll have to wait for 20.04 to launch on L4T or, if it's out by the time you read this,"
  echo "Reinstall L4T Ubuntu yourself."
  sleep 5
  exit 1
fi

#everything is on separate lines here because the dependencies are kind of a mess
sudo apt-get install libssl-dev -y
sudo apt-get install libssl1.* -y
#libssl 2.anything doesn't even exist yet and probably won't for *years* but hey, i'm planning ahead?
sudo apt-get install libssl2.* -y
sudo apt-get install npm* nodejs* -y

echo "Downloading the source..."
git clone https://github.com/GitSquared/edex-ui
cd edex-ui

npm install
##this next step gives me errors, but it works anyway...
npm run build-linux

npm run install-linux

cd /home/$USER/edex-ui/media/
sudo mkdir -p /usr/share/edex-ui
sudo cp logo.svg /usr/share/edex-ui
cd /usr/share/applications
sudo wget https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/eDEX-UI/eDEX-UI.desktop

echo ""
echo ""
echo "Done!"
echo "Settings can be modified by changing /home/$USER/.config/eDEX-UI/settings.json"
echo "Available themes to apply in the settings text file can be listed by typing 'ls /home/$USER/.config/eDEX-UI/themes'"
echo "We'll eventually maybe do this by default, but you can turn off the mouse pointer by setting the 'nocursor' variable to true inside the settings.json file"

