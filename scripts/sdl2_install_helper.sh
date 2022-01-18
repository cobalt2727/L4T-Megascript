#!/bin/bash

#make sure this is updated
#note that this is an apt package in the Switchroot repository, its ok for it to fail on other devices
sudo apt install joycond -y

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d%03d\n", $1,$2,$3,$4,$5); }'; }

sdlv=$(dpkg -s libsdl2-dev | sed -n 's/Version: //p')
sdlv=${sdlv/+/.}
if [ $(version $sdlv) -ge $(version "2.0.14.0") ]; then
    echo ""
    echo "Already Installed Newest SDL2 Version"
    sleep 1
else
    get_system
    if [[ "$dpkg_architecture" == "arm64" ]]; then
        mkdir -p /tmp/sdl2
        cd /tmp/sdl2 || error "Could not change directory"
        rm -rf ./*
        wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.0.14%2B5_arm64.deb --progress=bar:force:noscroll
        wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-dbg_2.0.14%2B5_arm64.deb --progress=bar:force:noscroll
        wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-dev_2.0.14%2B5_arm64.deb --progress=bar:force:noscroll

        sudo apt install ./* -y --allow-change-held-packages || error "SDL2 Packages Failed to install"
        rm -rf ./*

        # keep this old code for compiling SDL2 if its ever needed

        # sudo apt-get --assume-yes install git
        # cd /tmp
        # mkdir -p temp_install_sdl2
        # cd temp_install_sdl2
        # curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/retropie_packages.sh' > retropie_packages.sh
        # chmod -R 777 retropie_packages.sh
        # curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/retropie_setup.sh' > retropie_setup.sh
        # mkdir -p scriptmodules
        # cd ./scriptmodules
        # curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/system.sh' > system.sh
        # curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/helpers.sh' > helpers.sh
        # curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/packages.sh' > packages.sh
        # curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/inifuncs.sh' > inifuncs.sh
        # mkdir -p supplementary
        # cd ./supplementary
        # curl -s 'https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/scriptmodules/supplementary/sdl2.sh' > sdl2.sh
        # cd /tmp/temp_install_sdl2

        # #auto install sdl2 and then remove unneeded files
        # sudo ./retropie_packages.sh sdl2
        # cd /tmp
        # sudo rm -rf temp_install_sdl2

        cd
        echo ""
        echo "Successfully Installed Newest SDL2 Version"
        sleep 3
    else
        echo "Sorry we don't host binaries on the megascript for non-arm64 architectures"
        echo "Skipping updated SDL2 install"
    fi
fi
