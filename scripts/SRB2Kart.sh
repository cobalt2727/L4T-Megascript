cd ~
clear
echo "SRB2 Kart script started!"
echo -e "\e[33m          :/+oo+/++s/ooso:y+    
          s/ddds++s:yhhy:s-     
         -/shhh-d+/hhho:ss      
         s-hhhy.:oyyy/+o        
        .o+yss:.osso-s-         
        o.o+++:++//-ss          
       ss-/////++/:o            
       +-yhhhydhhh-s            
       s/hhhs-hhhho//           
      ::syyy:-syyyy:y.          
      s-yyys:d-sssss-s          
     .++sss:y+/+oooo/:/         
     o.oo+o.s y-+////-s.        
    .o:///:s. :+::::--yy        
    o.::--.s   s//:://://       
    d:://:/.                    \e[0m"
echo "Downloading the files, and installing needed dependencies..." 
sleep 2
sudo rm -r /usr/share/SRB2Kart
cd ~/.srb2kart
rm kartconfig.cfg 
cd /usr/share/applications
sudo rm "SRB2 Kart.desktop"
cd
sudo apt install wget curl libsdl2-dev libsdl2-mixer-dev cmake extra-cmake-modules subversion p7zip-full -y
wget https://github.com/STJr/Kart-Public/archive/master.zip
unzip master.zip
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/SRB2Kart
mkdir SRB2Kart-Data && cd SRB2Kart-Data
wget $(curl --silent "https://api.github.com/repos/STJr/Kart-Public/releases/latest" | grep "Installer" | grep ".exe" | cut -c 31- | cut -d '"' -f 2) -O SRB2Kart.exe
7z x SRB2Kart.exe
cd ~/Kart-Public-master/assets
mkdir installer 
cd ~/SRB2Kart-Data
mv chars.kart bonuschars.kart gfx.kart maps.kart patch.kart music.kart sounds.kart srb2.srb textures.kart -t ~/Kart-Public-master/assets/installer
cd ~/Kart-Public-master
mkdir build && cd build
echo
echo "Compiling the game..."
sleep 1
echo
cmake ..
make -j$(nproc)
echo
echo "Game compiled!"
sleep 1
cd ~ 
echo "Erasing temporary build files to save space, installing the direct access and configuration files....."
sleep 5
echo
mkdir .srb2kart
rm -r SRB2Kart-Data
cd SRB2Kart
chmod 777 SRB2Kart.sh
mv kartconfig.cfg -t ~/.srb2kart
sudo mv "SRB2 Kart.desktop" -t /usr/share/applications 
cd ~/Kart-Public-master
mv assets -t ~/SRB2Kart
cd ~/Kart-Public-master/build
mv bin -t ~/SRB2Kart
cd ~
rm master.zip
rm -r Kart-Public-master
sudo mv SRB2Kart -t /usr/share
echo
echo "Game Installed!"
echo
echo
echo "[NOTE] Remember NOT to move the SRB2Kart folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo
echo "Sending you back to the main menu..."
sleep 1


