#!/bin/bash

clear -x
status_green "SuperMario64 Port script started!"
status "Downloading the files, removing old files and installing needed dependencies..."

rm -rf "~/RetroPie/roms/ports/SM64.sh"
sudo rm -rf /usr/share/SM64
sudo rm -rf "/usr/share/applications/Super Mario 64.desktop"
rm -rf "~/.local/share/sm64pc/sm64config.txt"

cd /tmp || error "You don't have a /tmp folder....HOW?"
rm -rf sm64ex-nightly
rm -rf SM64
rm -rf nightly.zip
sudo apt install build-essential git python3 libglew-dev libsdl2-dev subversion -y || error "Dependency installs failed"
wget https://github.com/sm64pc/sm64ex/archive/nightly.zip
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/SM64
unzip nightly.zip
cd sm64ex-nightly || error "Could not find folder"
description="To build this port, you need a Super Mario 64 rom with the extension .z64.\
 \nDue to copyright restrictions, we will not provide the game file ourselves.\
 \nPlease legally acquire a copy and put the rom into the repository's root (/tmp/sm64ex-nightly) and rename it to baserom.version.z64.\
 \nVERSION can be us, jp, or eu (We recommend US, because EU has some issues such as broken audio) \
 \n \n Do you want to continue?"
table=("yes" "no")
userinput_func "$description" "${table[@]}"
if [[ $output == "no" ]]; then
    echo "Stopping the script..."
    cd /tmp
    rm -rf sm64ex-nightly
    rm -rf SM64
    rm -rf nightly.zip
    echo
    echo "Sending you back to the main menu..."
    sleep 1
    exit
elif [[ $output == "yes" ]]; then
    echo "Continuing the script..."
fi
description="Please select the ROM's region (us/eu/jp) \
 \nThe rom needs to be in the repository's root directory (/tmp/sm64ex-nightly) and renamed to baserom.version.z64 (all lowercase)"
table=("us" "eu" "jp")
userinput_func "$description" "${table[@]}"

case "$output" in
    "us"|"eu"|"jp")
        make -j$(nproc) VERSION="$output" BETTERCAMERA=1 TEXTURE_FIX=1 EXT_OPTIONS_MENU=1 NODRAWINGDISTANCE=1 EXTERNAL_DATA=1 || error "Compilation failed"
        cd build
        mv "$output"_pc SM64
        cd SM64
        mv sm64."$output".f3dex2e sm64
        ;;
    *)
        cd /tmp
        rm -rf sm64ex-nightly
        rm -rf SM64
        rm -rf nightly.zip
        error "Somehow you didn't select a rom region... Cleaning up files and stopping the script"
        ;;
esac

echo
echo "Game compiled!"
echo
echo "Erasing files to save space..."
sleep 2
echo
echo
mv /tmp/SM64/SM64Icon.png -t /tmp/sm64ex-nightly/build/SM64
sudo mv /tmp/sm64ex-nightly/build/SM64 -t /usr/share
sudo rm -rf /tmp/sm64ex-nightly
rm -rf /tmp/nightly.zip
echo
echo "Installing the direct access and configuration files.."
echo
sudo mv "/tmp/SM64/Super Mario 64.desktop" -t /usr/share/applications
mkdir -p ~/.local/share/sm64ex
cd ~/.local/share/sm64ex || error "Could not find folder"
svn export https://github.com/gabomdq/SDL_GameControllerDB/trunk/gamecontrollerdb.txt
mv /tmp/SM64/sm64config.txt -t ~/.local/share/sm64ex
rm -rf /tmp/SM64

status_green "Game Installed!"
status "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
