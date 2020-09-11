clear
echo "SuperMario64 Port script started!"
echo "Downloading the files and installing needed dependencies..."
sleep 3
cd ~
sudo apt install build-essential git python3 libglew-dev libsdl2-dev subversion -y
wget https://github.com/sm64pc/sm64ex/archive/master.zip
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/SM64
cd SM64
mv SM64.sh -t ~/RetroPie/roms/ports
cd
unzip master.zip
cd sm64ex-master
echo "To build this port, you need a Super Mario 64 rom with the extension .z64."
echo "Due to copyright restrictions, we will not provide the game file ourselves."
echo "Please legally acquire a copy and put the rom into the repository's root (sm64ex-master) and rename it to baserom.VERSION.z64."
echo "VERSION can be us, jp, or eu (We recommend US, because EU has some issues such as broken audio)"
sleep 10
read -p "Do you want to continue? (y/n) " userInput
if [[ $userInput == n || $userInput == no ]]; then
echo "Stopping the script..."
cd ~
rm -r sm64ex-master
rm -r SM64
rm master.zip
echo
echo "Sending you back to the main menu..."
sleep 1
exit
elif [[ $userInput == y || $userInput == yes ]]; then
echo "Continuing the script..."
sleep 3
fi
read -p "Please select the ROM's region (us/eu/jp) " userInput
if [[ $userInput == us || $userInput == US ]]; then
make -j$(nproc) BETTERCAMERA=1 TEXTURE_FIX=1 EXT_OPTIONS_MENU=1 NODRAWINGDISTANCE=1
cd build
mv us_pc SM64
cd SM64
mv sm64.us.f3dex2e sm64
elif [[ $userInput == eu || $userInput == EU ]]; then
make -j$(nproc) VERSION=eu BETTERCAMERA=1 TEXTURE_FIX=1 EXT_OPTIONS_MENU=1 NODRAWINGDISTANCE=1
cd build
mv eu_pc SM64
cd SM64
mv sm64.eu.f3dex2e sm64
elif [[ $userInput == jp || $userInput == JP ]]; then
make -j$(nproc) VERSION=jp BETTERCAMERA=1 TEXTURE_FIX=1 EXT_OPTIONS_MENU=1 NODRAWINGDISTANCE=1
cd build
mv jp_pc SM64
cd SM64
mv sm64.jp.f3dex2e sm64
fi
echo
echo "Game compiled!"
echo
echo "Erasing files to save space..."
sleep 2
echo
echo
cd ~/SM64
mv SM64Icon.png -t ~/sm64ex-master/build/SM64
cd ~/sm64ex-master/build
sudo mv SM64 -t /usr/share
cd ~
sudo rm -r sm64ex-master
rm master.zip
echo
echo "Installing the direct access and configuration files.."
echo
cd ~/SM64
sudo mv "Super Mario 64.desktop" -t /usr/share/applications
cd ~/.local/share
mkdir sm64pc
cd sm64pc
svn export https://github.com/gabomdq/SDL_GameControllerDB/trunk/gamecontrollerdb.txt
cd ~/SM64
mv sm64config.txt -t ~/.local/share/sm64pc
cd ~
rm -r SM64
echo
echo "Game Installed!"
echo
echo
echo "[NOTE] Remember NOT to move the SM64 folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo
echo "Sending you back to the main menu..."
sleep 1


