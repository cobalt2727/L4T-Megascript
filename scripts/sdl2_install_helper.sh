if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
cd
if dpkg -s libsdl2-dev | grep -q "2.0.10+5"; then
echo ""
echo "Already Installed Newest SDL2 Version"
sleep 1
else
apt-get --assume-yes install git
cd /tmp
mkdir temp_install_sdl2
cd temp_install_sdl2
curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/retropie_packages.sh' > retropie_packages.sh
chmod -R 777 retropie_packages.sh
curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/retropie_setup.sh' > retropie_setup.sh
mkdir scriptmodules
cd ./scriptmodules
curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/system.sh' > system.sh
curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/helpers.sh' > helpers.sh
curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/packages.sh' > packages.sh
curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/inifuncs.sh' > inifuncs.sh
mkdir supplementary
cd ./supplementary
curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/supplementary/sdl2.sh' > sdl2.sh
cd /tmp/temp_install_sdl2


#auto install sdl2 and then remove unneeded files
./retropie_packages.sh sdl2
cd /tmp
rm -rf temp_install_sdl2
cd
echo ""
echo "Successfully Installed Newest SDL2 Version"
sleep 3
fi
