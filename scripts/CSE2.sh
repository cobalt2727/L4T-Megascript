echo "Downloading the files and installing needed dependencies..." 
git clone https://github.com/Lang-Kasempo/CSE2/archive/enhanced.zip
sudo apt install git cmake g++ libxext-dev libgl-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev unzip

unzip CSE2-enhanced.zip
cd CSE2-enhanced
cmake -B build -DCMAKE_BUILD_TYPE=Release
cd build
make
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
sudo rm -r .git
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
sudo mv CaveStoryIcon.png -t /usr
cd game_english
chmod 777 CaveStory.sh
sudo mv CSE2.desktop -t /usr/share/applications 
cd ..
cd ..
sudo mv CSE2-enhanced -t /usr/share
echo
echo "Game Installed!"
echo
echo
echo "[NOTE] Remember NOT to move the CSE2 folder or any file inside it or the game will stop working. If the game icon
doesn't appear inmediately, restart the system"
sleep 10

echo "Sending you back to the main menu..."
sleep 1


