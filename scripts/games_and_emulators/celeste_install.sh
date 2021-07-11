clear -x
cd /tmp
echo "Celeste Pico 8 script started!"
echo "Installing Dependencies"
echo
sudo apt install --assume-yes subversion libsdl1.2-dev libsdl2-mixer-dev libsdl2-dev libsdl-mixer1.2-dev libsdl2-image-dev
sudo apt install --assume-yes libsndio*
bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
echo
echo "Downloading the game"
git clone https://github.com/lemon32767/ccleste.git --depth=1
cd ccleste
rm -rf gamecontrollerdb.txt
make -j4
wget https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt

echo "Compiling the game"

path="/usr/share/celeste"

sudo rm -rf $path
sudo mkdir $path
sudo mv ccleste $path
sudo mv gamecontrollerdb.txt $path
sudo mv icon.png $path
sudo mv screenshot.png $path
sudo mv data $path

sudo tee $path/ccleste-start-fullscreen.txt <<'EOF'
True
EOF

sudo rm -rf /tmp/ccleste

echo "Adding to applications menu"

sudo tee /usr/share/applications/celeste.desktop <<'EOF'
[Desktop Entry]
Type=Application
Exec=/usr/share/celeste/ccleste
Path=/usr/share/celeste
Name=Celeste
Comment=celeste
Icon=/usr/share/celeste/icon.png
Categories=Game
EOF

echo
echo "Game installed!"
sleep 2
echo
echo "Sending you back to the main menu..."
