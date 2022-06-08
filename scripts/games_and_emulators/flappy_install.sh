clear -x
cd /tmp
echo "Flappy Bird script started!"
echo "Installing Dependencies"
echo
sudo apt install --assume-yes subversion subversion libsdl1.2-dev libsdl2-mixer-dev libsdl2-dev libsdl-mixer1.2-dev libsdl2-image-dev || error "Dependency installs failed"
sudo apt install --assume-yes libsndio* || error "Dependency installs failed"
echo
status "Downloading and compiling the game"
rm -rf flappy
git clone https://github.com/theofficialgman/flappy.git --depth=1 || error "Could not download the source code"
cd flappy
make 7b_1 || error "Compilation failed"
echo
echo "Erasing files to save space..."
echo
rm .gitignore
rm Makefile
rm -rf ./Code
rm -rf ./.git
rm -rf ./DevDox
rm -rf ./Promotion
rm -rf flappy_install.sh
sudo rm -f /usr/share/applications/flappy.desktop
sudo mv flappy.desktop -t /usr/share/applications
cd /tmp
cp /usr/share/flappy/Builds/Linux/hiscore hiscore
sudo rm -rf /usr/share/flappy
sudo mv flappy -t /usr/share
sudo cp hiscore /usr/share/flappy/Builds/Linux/hiscore
status_green "Game installed!"
sleep 2
echo
echo "Sending you back to the main menu..."
