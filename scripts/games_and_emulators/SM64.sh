#!/bin/bash

clear -x
echo "SuperMario64 Port script started!"
echo "Downloading the files, removing old files and installing needed dependencies..."
cd ~/RetroPie/roms/ports
rm SM64.sh
sudo rm -r /usr/share/SM64
cd /usr/share/applications
sudo rm "Super Mario 64.desktop"
cd ~/.local/share/sm64pc
rm sm64config.txt
sleep 3
cd ~
sudo apt install build-essential git python3 libglew-dev libsdl2-dev subversion -y || error "Dependency installs failed"
wget https://github.com/sm64pc/sm64ex/archive/nightly.zip
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/SM64
cd
unzip nightly.zip
cd sm64ex-nightly
description="To build this port, you need a Super Mario 64 rom with the extension .z64.\
 \nDue to copyright restrictions, we will not provide the game file ourselves.\
 \nPlease legally acquire a copy and put the rom into the repository's root (sm64ex-nightly) and rename it to baserom.version.z64.\
 \nVERSION can be us, jp, or eu (We recommend US, because EU has some issues such as broken audio) \
 \n \n Do you want to continue?"
table=("yes" "no")
userinput_func "$description" "${table[@]}"
if [[ $output == "no" ]]; then
    echo "Stopping the script..."
    cd ~
    rm -r sm64ex-nightly
    rm -r SM64
    rm nightly.zip
    echo
    echo "Sending you back to the main menu..."
    sleep 1
    exit
elif [[ $output == "yes" ]]; then
    echo "Continuing the script..."
fi
description="Please select the ROM's region (us/eu/jp) \
 \nThe rom needs to be in the repository's root directory (sm64ex-nightly) and renamed to baserom.version.z64 (all lowercase)"
table=("us" "eu" "jp")
userinput_func "$description" "${table[@]}"
if [[ $output == "us" ]]; then
    make -j$(nproc) BETTERCAMERA=1 TEXTURE_FIX=1 EXT_OPTIONS_MENU=1 NODRAWINGDISTANCE=1 EXTERNAL_DATA=1 || error "Compilation failed"
    cd build
    mv us_pc SM64
    cd SM64
    mv sm64.us.f3dex2e sm64
elif [[ $output == "eu" ]]; then
    make -j$(nproc) VERSION=eu BETTERCAMERA=1 TEXTURE_FIX=1 EXT_OPTIONS_MENU=1 NODRAWINGDISTANCE=1 EXTERNAL_DATA=1 || error "Compilation failed"
    cd build
    mv eu_pc SM64
    cd SM64
    mv sm64.eu.f3dex2e sm64
elif [[ $output == "jp" ]]; then
    make -j$(nproc) VERSION=jp BETTERCAMERA=1 TEXTURE_FIX=1 EXT_OPTIONS_MENU=1 NODRAWINGDISTANCE=1 EXTERNAL_DATA=1 || error "Compilation failed"
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
mv SM64Icon.png -t ~/sm64ex-nightly/build/SM64
cd ~/sm64ex-nightly/build
sudo mv SM64 -t /usr/share
cd ~
sudo rm -r sm64ex-nightly
rm nightly.zip
echo
echo "Installing the direct access and configuration files.."
echo
cd ~/SM64
sudo mv "Super Mario 64.desktop" -t /usr/share/applications
cd ~/.local/share
mkdir -p sm64ex
cd sm64ex
svn export https://github.com/gabomdq/SDL_GameControllerDB/trunk/gamecontrollerdb.txt
cd ~/SM64
mv sm64config.txt -t ~/.local/share/sm64ex
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
