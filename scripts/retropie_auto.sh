cd
clear
echo "TheXTech script started!"
echo -e "\e[31m            .+sys//.            
           :hyyyy/.s/           
           syyyyyyyys           
           -hyyyyyyh-           
            `/hssy/`            
              o  o              
              o  o              
       `-/+oosd  hsso+/-`       
     :syyyyyydN-.Ndyyhyyhs/     
    /yyyyyyyyhddddyshysshyys    
    :hyyyyyyyyyyyy//ohyyyyys    
     :dhhyyyyyyyyyyyyyyyhd/     
      -ddddddhhhdhhdddddd+      
       +hhhhhddhhddhhhhhs       
        +hhhhhhhhhhhhhhs`       
         `:osyhhhhyso/`         \e[0m"
echo
echo "Downloading the files and installing needed dependencies..."
sleep 3
cd 

#download git
sudo apt install git dialog unzip xmlstarlet lsb-release -y
cd
rm -rf RetroPie-Setup
sudo -u "$SUDO_USER" git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git

#auto install retropie with most important emulators (which don't take up much space)
cd RetroPie-Setup
# unfortunatly I can't use this this not all main packages work ... ./retropie_packages.sh setup basic_install
# manually install all of the required and good stuff

sudo ./retropie_packages.sh retroarch
sudo ./retropie_packages.sh emulationstation
sudo ./retropie_packages.sh retropiemenu
sudo ./retropie_packages.sh runcommand
#./retropie_packages.sh ports-enable configure
sudo ./retropie_packages.sh lr-mupen64plus-next
sudo ./retropie_packages.sh lr-atari800
sudo ./retropie_packages.sh lr-beetle-ngp
sudo ./retropie_packages.sh lr-beetle-pce-fast
sudo ./retropie_packages.sh lr-beetle-supergrafx
# ./retropie_packages.sh lr-beetle-saturn
sudo ./retropie_packages.sh lr-bsnes
sudo ./retropie_packages.sh lr-desmume
# ./retropie_packages.sh lr-desmume2015
sudo ./retropie_packages.sh lr-fbneo
sudo ./retropie_packages.sh lr-fceumm
sudo ./retropie_packages.sh lr-flycast
sudo ./retropie_packages.sh lr-gambatte
sudo ./retropie_packages.sh lr-genesis-plus-gx
sudo ./retropie_packages.sh lr-handy
#./retropie_packages.sh lr-mame
# ./retropie_packages.sh lr-mame2003
# ./retropie_packages.sh lr-mame2010
# ./retropie_packages.sh lr-mame2016
# ./retropie_packages.sh lr-mesen
sudo ./retropie_packages.sh lr-mgba
sudo ./retropie_packages.sh lr-nestopia
sudo ./retropie_packages.sh lr-pcsx-rearmed
sudo ./retropie_packages.sh lr-ppsspp
sudo ./retropie_packages.sh lr-prosystem
sudo ./retropie_packages.sh lr-quicknes
sudo ./retropie_packages.sh lr-smsplus-gx
sudo ./retropie_packages.sh lr-stella2014
sudo ./retropie_packages.sh lr-vba-next
sudo ./retropie_packages.sh lr-vecx
sudo ./retropie_packages.sh lr-tgbdual
sudo ./retropie_packages.sh lr-snes9x
# ./retropie_packages.sh lr-yabasanshiro
sudo ./retropie_packages.sh lr-yabause
sudo ./retropie_packages.sh lzdoom
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
