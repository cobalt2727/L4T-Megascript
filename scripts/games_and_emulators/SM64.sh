#!/bin/bash

clear -x
status_green "SuperMario64 Port script started!"

function error_nonfatal {
  echo -e "\\e[91m$1\\e[39m"

}

rm -rf /tmp/SM64-rom
mkdir -p /tmp/SM64-rom || error "Could not make the rom folder"
cd /tmp/SM64-rom || error "Could not move to the rom folder"
status "Please place your US/JP/EU rom backup into /tmp/SM64-rom"

if [[ $gui == "gui" ]]; then
    xdg-open /tmp/SM64-rom 2>/dev/null
fi

description="To build this port, you need a Super Mario 64 rom with the extension .z64.\
\nDue to copyright restrictions, we will not provide the game file ourselves.\
\nPlease legally acquire a copy and put the rom into the /tmp/SM64-rom and rename it to baserom.VERSION.z64.\
\nVERSION can be us, jp, or eu (We recommend us, because eu has some issues such as broken audio) \
\n\nThe default file explorer has been opened at this location for your convenience.\
\nWhich ROM are you supplying?"
table=("us" "jp" "eu")
userinput_func "$description" "${table[@]}"

status "Checking user supplied ROM backup"
unset sha1_user
sha1_user=$( sha1sum baserom.$output.z64 2>/dev/null | awk '{print $1;}' )
sha1_us="9bef1128717f958171a4afac3ed78ee2bb4e86ce" 
sha1_jp="8a20a5c83d6ceb0f0506cfc9fa20d8f438cafe51"
sha1_eu="4ac5721683d0e0b6bbb561b58a71740845dceea9"
sha1_user_version=sha1_$output


if [[ $sha1_user != ${!sha1_user_version} ]]; then
    description="OH No! Your rom backup is bad and does not match the backup of an actual SM64 rom. Please supply a working rom file."
    table=("Exit the script")
    userinput_func "$description" "${table[@]}"
    error_nonfatal "The SM64 script has exited without installing. Any below success reports are false."
    exit 0
else
    status_green "ROM is Good, continuing the build"
fi

status "Downloading the files, removing old files and installing needed dependencies..."

rm -rf "~/RetroPie/roms/ports/SM64.sh"
sudo rm -rf /usr/share/SM64
sudo rm -rf "/usr/share/applications/Super Mario 64.desktop"
rm -rf "~/.local/share/sm64pc/sm64config.txt"

cd /tmp || error "You don't have a /tmp folder....HOW?"
rm -rf sm64ex
rm -rf SM64
sudo apt install build-essential git python3 libglew-dev libsdl2-dev subversion -y || error "Dependency installs failed"
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/SM64
git clone https://github.com/sm64pc/sm64ex.git
cd sm64ex || error "Could not find folder"
git pull || error "Could not pull latest source code"
# move the rom to the correct location for the build
mv /tmp/SM64-rom/baserom.$output.z64 /tmp/sm64ex

case "$output" in
    "us"|"eu"|"jp")
        make -j$(nproc) VERSION="$output" BETTERCAMERA=1 TEXTURE_FIX=1 EXT_OPTIONS_MENU=1 NODRAWINGDISTANCE=1 EXTERNAL_DATA=1 || error "Compilation failed"
        cd build
        mv "$output"_pc SM64
        cd SM64
        mv sm64."$output".f3dex2e sm64
        ;;
    *)
        cd ~
        rm -rf /tmp/sm64ex
        rm -rf /tmp/SM64
        rm -rf /tmp/nightly.zip
        error "Somehow you didn't select a rom region... Cleaning up files and stopping the script"
        ;;
esac

status_green "Game compiled!"
echo "Erasing files to save space..."
mv /tmp/SM64/SM64Icon.png -t /tmp/sm64ex/build/SM64
sudo mv /tmp/sm64ex/build/SM64 -t /usr/share
sudo rm -rf /tmp/sm64ex
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
