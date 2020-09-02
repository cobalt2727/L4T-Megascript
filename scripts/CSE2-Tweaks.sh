clear
echo "CSE2-Tweaks script started!"
echo "Downloading the files and installing needed dependencies..."
sleep 3
wget https://github.com/calvarado194/CSE2-tweaks/archive/tweaks.zip
unzip tweaks.zip
sudo apt install snapd g++ subversion x11proto-dev libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libopengl0 libglvnd-dev mesa-common-dev libgles2-mesa-dev libsdl2-dev libfreetype6-dev libglfw3-dev -y
sudo snap install cmake --classic
hash -r
svn export https://github.com/cobalt2727/L4T-Megascript/trunk/assets/CSE2-Tweaks
cd CSE2-tweaks-tweaks
echo
read -p "Select the game language (jp/en) " userInput
echo
if [[ $userInput == jp || $userInput == JP ]]; then
echo
echo "You selected Japanese"
echo
sleep 2
cmake -B build -DCMAKE_BUILD_TYPE=Release -DJAPANESE=ON
cmake --build build --config Release
mv game_japanese CSE2-Tweaks
elif [[ $userInput == en || $userInput == EN ]]; then
echo
echo "You selected English"
echo
sleep 2
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
mv game_english CSE2-Tweaks
fi
echo
echo "Game compiled!"
echo
echo "Erasing files to save space..."
sleep 2
echo
cd /$HOME/CSE2-Tweaks 
mv ConfigCSE2E.dat CSE2-TweaksIcon.png -t /$HOME/CSE2-tweaks-tweaks/CSE2-Tweaks
cd /$HOME/CSE2-tweaks-tweaks
sudo mv CSE2-Tweaks -t /usr/share
cd /$HOME
sudo rm -r CSE2-tweaks-tweaks
rm tweaks.zip
echo
echo "Installing the direct access"
echo
cd /$HOME/CSE2-Tweaks 
sudo mv CSE2-Tweaks.desktop -t /usr/share/applications
cd /$HOME
rm -r CSE2-Tweaks
echo
echo "Game Installed!"
echo
echo
echo "[NOTE] Remember NOT to move the CSE2-Tweaks folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo
echo "Sending you back to the main menu..."
sleep 1


