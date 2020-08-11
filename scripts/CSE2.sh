echo "Downloading the files and installing needed dependencies..." 
wget https://github.com/Clownacy/CSE2/archive/enhanced.zip
unzip enhanced.zip
sudo apt install git cmake g++ libxext-dev libgl-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev subversion svn-all-fast-export
svn export https://github.com/cobalt2727/L4T-Megascript/trunk/assets/CSE2
cd CSE2 
mv CaveStory.sh ConfigCSE2E.dat CSE2.desktop CaveStoryIcon.png -t /home/$USER/CSE2-enhanced/game_english
cd ..
rm -r CSE2
cd CSE2-enhanced
cmake -B build -DCMAKE_BUILD_TYPE=Release
cd build
make -j$(nproc)
echo
echo "Game compilated!"
echo
cd ..
echo "Erasing files to save space..."
echo
echo
rm -r assets
rm -r bin2h
rm -r build
rm -r cmake
rm -r external
rm -r game_japanese
rm -r src 
rm CMakeLists.txt 
rm PHILOSOPHY.md
rm README.md
rm screenshot.png 
rm .gitattributes
rm .gitignore 
rm .travis.yml
echo
echo "Installing the direct access"
echo
cd game_english
chmod 777 CaveStory.sh
sudo mv CSE2.desktop -t /usr/share/applications 
cd ..
cd ..
mv CSE2-enhanced CSE2
sudo mv CSE2 -t /usr/share
echo
echo "Game Installed!"
echo
echo
echo "[NOTE] Remember NOT to move the CSE2 folder or any file inside it or the game will stop working. If the game icon
doesn't appear inmediately, restart the system"
sleep 10

echo "Sending you back to the main menu..."
sleep 1


