clear -x
cd ~
echo "eDEX-UI script started!"
sleep 1

# get dpkg_architecture using function
get_system
case "$dpkg_architecture" in
    "arm64") type="arm64";type2="arm64";;
    "armhf") type="armv7l";type2="armhf";;
    "i386") type="i386";type2="$type1";;
    "amd64") type="x86_64";type2="amd64";;
    *) echo "Error: your userspace architecture ($dpkg_architecture) is not supporeted by eDEX-UI and will fail to run"; echo ""; echo "Exiting the script"; sleep 3; exit $? ;;
esac
cd ~
sudo apt install curl -y
rm -rf edex-ui-appimage
mkdir edex-ui-appimage
cd edex-ui-appimage
curl https://api.github.com/repos/GitSquared/edex-ui/releases/latest | grep "browser_download_url.*Linux-$type" | cut -d : -f 2,3 | tr -d \" | wget -i -
mv *.AppImage eDEX-UI.AppImage
chmod +x *.AppImage
curl https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | grep "browser_download_url.*bionic_$type2" | cut -d : -f 2,3 | tr -d \" | wget -i -
sudo dpkg -i *bionic_*.deb
hash -r
ail-cli integrate eDEX-UI.AppImage
cd ~
rm -rf edex-ui-appimage

echo "Install Dependencies..."
cd ~
echo "THIS DEPENDENCY LIST IS PROBABLY MISSING STUFF"
echo "PLEASE FILE A GITHUB ISSUE LOGGING ANY ERRORS YOU RECEIVE WHEN RUNNING EDEX-UI"
sudo apt-get install libssl1.1 -y

echo "Done!"
echo "Sending you back to the main menu...
