cd
clear
echo "SRB2 script started!"
echo "Downloading the files, and installing needed dependencies..." 
sleep 2
wget https://github.com/STJr/SRB2/archive/master.zip
sudo apt install libsdl2-dev libsdl2-mixer-dev cmake extra-cmake-modules subversion -y
wget $(curl --silent "https://api.github.com/repos/STJr/SRB2/releases/latest" | grep "Data" | grep "SRB2_release_" | cut -c 31- | cut -d '"' -f 2) -O SRB2-Data.zip
svn export https://github.com/cobalt2727/L4T-Megascript/trunk/assets/SRB2-A
cd SRB2-A
mv SRB2_retropie.sh -t ~/RetroPie/roms/ports
cd
unzip master.zip
mkdir SRB2-DT
mv SRB2-Data.zip -t ~/SRB2-DT
cd ~/SRB2-DT
unzip SRB2-Data.zip
rm SRB2-Data.zip
cd ~/SRB2-master/assets
mkdir installer
cd ..
mkdir build
cd ~
mkdir .srb2
cd ~/SRB2-A
chmod 777 SRB2.sh
mv config.cfg -t ~/.srb2
mv SRB2.sh SRB2Icon.png -t ~/SRB2-master
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
cd ~/SRB2-master/assets
rm -r debian-template
rm CMakeLists.txt
rm LICENSE.txt
rm LICENSE-3RD-PARTY.txt
rm README.txt
rm .gitignore
cd ~/SRB2-master
rm -r cmake
rm -r android
rm -r bin
rm -r debian-template
rm -r deployer
rm -r doc
rm -r extras
rm -r libs
rm -r objs
rm -r src
rm -r tools
rm -r .circleci
rm Android.mk
rm appveyor.yml
rm CMakeLists.txt
rm comptime.bat
rm comptime.mk
rm comptime.props
rm comptime.sh
rm cpdebug.mk
rm debian_template.sh
rm Doxyfile
rm LICENSE
rm README.md
rm srb2.png
rm srb2banner.png
rm srb2-vc9.sln
rm srb2-vc10.sln
rm Srb2.dev
rm SRB2.cbp
rm SRB2_common.props
rm SRB2_Debug.props
rm SRB2_Release.props
rm .gitattributes
rm .gitignore
rm .travis.yml
cd ..
rm -r SRB2-DT
mv SRB2-master SRB2
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


