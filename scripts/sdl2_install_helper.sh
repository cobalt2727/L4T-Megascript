cd
if dpkg -s libsdl2-dev | grep "2.0.10+5"; then
echo ""
echo "Already Installed Newest SDL2 Version"
sleep 1
else
sudo apt-get --assume-yes install git
sudo rm -rf temp_install
mkdir temp_install
cd temp_install
git clone --depth=1 https://github.com/theofficialgman/RetroPie-Setup.git
#auto install sdl2 and then remove unneeded files
cd RetroPie-Setup
sudo ./retropie_packages.sh sdl2
cd
sudo rm -rf temp_install
echo ""
echo "Successfully Installed Newest SDL2 Version"
sleep 3
fi
