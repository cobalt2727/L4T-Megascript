#download git
apt-get --assume-yes install git dialog unzip xmlstarlet
cd
rm -rf RetroPie-Setup
sudo -u "$SUDO_USER" git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git

#auto install retropie with most important emulators (which don't take up much space)
cd RetroPie-Setup
# unfortunatly I can't use this this not all main packages work ... ./retropie_packages.sh setup basic_install
# manually install all of the required and good stuff

./retropie_packages.sh retroarch
./retropie_packages.sh emulationstation
./retropie_packages.sh retropiemenu
./retropie_packages.sh runcommand
#./retropie_packages.sh ports-enable configure
./retropie_packages.sh lr-mupen64plus-next
./retropie_packages.sh lr-atari800
./retropie_packages.sh lr-beetle-ngp
./retropie_packages.sh lr-beetle-pce-fast
./retropie_packages.sh lr-beetle-supergrafx
./retropie_packages.sh lr-fbneo
./retropie_packages.sh lr-fceumm
./retropie_packages.sh lr-gambatte
./retropie_packages.sh lr-genesis-plus-gx
./retropie_packages.sh lr-handy
# ./retropie_packages.sh lr-mame2003
./retropie_packages.sh lr-mgba
./retropie_packages.sh lr-nestopia
./retropie_packages.sh lr-prosystem
./retropie_packages.sh lr-quicknes
./retropie_packages.sh lr-stella2014
./retropie_packages.sh lr-vba-next
./retropie_packages.sh lr-vecx
./retropie_packages.sh lr-bsnes
./retropie_packages.sh lr-flycast
# ./retropie_packages.sh lr-mame2016
# ./retropie_packages.sh lr-mame2010
#./retropie_packages.sh lr-mame
./retropie_packages.sh lr-pcsx-rearmed
./retropie_packages.sh lr-ppsspp
./retropie_packages.sh lr-snes9x
./retropie_packages.sh lzdoom
# ./retropie_packages.sh scraper
# ./retropie_packages.sh skyscraper
# ./retropie_packages.sh usbromservice
if dpkg -s libsdl2-dev | grep -q "2.0.10+5"; then
  echo ""
  echo "Already Installed Newest SDL2 Version"
  sleep 3
else
  ./retropie_packages.sh sdl2
  echo ""
  echo "Successfully Installed Newest SDL2 Version"
  sleep 3
fi
