clear
cd ~
echo "eDEX-UI script started!"
sleep 1

cd ~
sudo apt install curl -y
rm -rf edex-ui-appimage
mkdir edex-ui-appimage
cd edex-ui-appimage
curl https://api.github.com/repos/GitSquared/edex-ui/releases/latest | grep "browser_download_url.*Linux-arm64" | cut -d : -f 2,3 | tr -d \" | wget -qi -
mv *.AppImage eDEX-UI.AppImage
chmod +x *.AppImage
curl https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | grep "browser_download_url.*bionic_arm64" | cut -d : -f 2,3 | tr -d \" | wget -i -
sudo dpkg -i *bionic_arm64.deb
hash -r
ail-cli integrate eDEX-UI.AppImage
cd ~
rm -rf edex-ui-appimage

echo "Install Dependencies..."
cd ~
echo "THIS DEPENDENCY LIST IS PROBABLY MISSING STUFF"
echo "PLEASE FILE A GITHUB ISSUE LOGGING ANY ERRORS YOU RECEIVE WHEN RUNNING EDEX-UI"
sudo apt-get install libssl1.* -y

echo "Done!"
echo "Sending you back to the main menu...
