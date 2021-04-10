echo "Discord aarch64 script started!"
echo "CREDITS: https://github.com/SpacingBat3/electron-discord-webapp"
sleep 2

echo "Installing dependencies..."
sudo apt install git curl -y

cd ~
mkdir -p discord-tmp/
cd discord-tmp/

echo "Removing previous legacy Discord installs..."
sudo dpkg -r electron-discord-webapp

echo "Downloading the most recent .deb from SpacingBat3's repository..."
curl -s https://api.github.com/repos/SpacingBat3/electron-discord-webapp/releases/latest \
  | grep "browser_download_url.*arm64.deb" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -qi -

echo "Done! Installing the package (and maybe fixing dependencies)..."
sudo dpkg -i *arm64.deb
sudo apt --fix-broken install -y

cd ..
rm -rf discord-tmp/

echo "Done!"
echo "Sending you back to the menu..."
sleep 1
