#!/bin/bash
#Fun fact, the original version of this script had an aprox 50 more lines of code

cd
clear -x
echo "SRB2 script started!"
echo "Downloading the files, removing old files and installing needed dependencies..." 
sleep 2
sudo rm -r /usr/share/SRB2 
cd ~/.srb2
rm config.cfg
cd /usr/share/applications
sudo rm "Sonic Robo Blast 2.desktop"
cd ~/RetroPie/roms/ports
rm SRB2_retropie.sh
cd

if grep -q bionic /etc/os-release; then
    ppa_name="rncbc/libs-bionic" && ppa_installer
    if [[ -f "/usr/bin/cmake" ]]; then
        #remove manually installed cmake versions (as instructed by theofficialgman) only if apt cmake is found
        sudo rm -rf '/usr/local/bin/cmake' '/usr/local/bin/cpack' '/usr/local/bin/ctest'
        hash -r
    fi
fi

sudo apt install wget libsdl2-dev libsdl2-mixer-dev cmake extra-cmake-modules subversion libupnp-dev libgme-dev libopenmpt-dev curl libcurl4-gnutls-dev libpng-dev -y
wget https://github.com/STJr/SRB2/archive/master.zip
wget $(curl --silent "https://api.github.com/repos/STJr/SRB2/releases/latest" | grep "SRB2" | grep "Full" | cut -c 31- | cut -d '"' -f 2) -O SRB2-Data.zip
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/SRB2-A
mkdir -p SRB2
cd
unzip master.zip
mkdir -p SRB2-DT
mv SRB2-Data.zip -t ~/SRB2-DT
cd ~/SRB2-DT
unzip SRB2-Data.zip
rm SRB2-Data.zip
cd ~/SRB2-master/assets
mkdir -p installer
cd ..
mkdir -p build
cd ~
mkdir -p .srb2
cd ~/SRB2-A
chmod 777 SRB2.sh
mv config.cfg -t ~/.srb2
mv SRB2.sh SRB2Icon.png -t ~/SRB2
sudo mv "Sonic Robo Blast 2.desktop" -t /usr/share/applications 
cd ~
rm master.zip
rm -r SRB2-A
cd ~/SRB2-DT
mv music.dta patch.pk3 patch_music.pk3 player.dta srb2.pk3 zones.pk3 -t ~/SRB2-master/assets/installer
cd ~/SRB2-master/build
echo
echo "Compiling the game..."
sleep 1
echo
cmake ..
make -j$(nproc)
echo
echo "Game compiled!"
sleep 1
echo
echo
echo "Erasing temporary build files to save space..."
sleep 2
echo
cd ~/SRB2-master
mv assets build -t ~/SRB2
cd ~
rm -r SRB2-DT
rm -r SRB2-master
sudo mv SRB2 -t /usr/share
echo 
echo "Game installed!"
echo
echo
echo "[NOTE] Remember NOT to move the SRB2 folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo
echo "Sending you back to the main menu..."
sleep 1


