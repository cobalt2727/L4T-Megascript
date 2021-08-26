#!/bin/bash

clear -x
echo "ocs-url script started!"
echo 'This will allow you to actually USE that fancy "Install"'
echo "button on the Pling website and any of its derivatives."
sleep 3

sudo apt install git qt5-qmake make qml-module-qtquick-controls qtdeclarative5-dev libqt5svg5-dev libcanberra-gtk-module xdg-desktop-portal -y
if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
        sudo apt install unity-tweak-tool hud -y
else
        echo "Not using Unity as the current desktop, skipping theme manager install..."
fi


cd ~
rm -rf ocs-url/
##using my fork temporarily until the original maintainer merges my changes to fix manual builds
git clone https://www.opencode.net/cobalt2727/ocs-url

cd ocs-url

##switch over to my commits
git checkout patch-1

./scripts/prepare

#this line is broken on Debian 10, but with the proper PREFIX path (that I don't remember currently) this script WILL run correctly
#version detection may be needed if Debian 11 hasn't fixed the qmake setup, but I haven't checked that -Cobalt
qmake PREFIX=/usr

make -j$(nproc)

sudo make install

cd ~
rm -rf ocs-url/

echo "Done!"

if [[ $DISPLAY ]]; then
        echo "Find a theme you like and install it - enjoy!"
        sleep 3
        
        #open up the default web browser
        xdg-open 'https://www.pling.com/browse/cat/381/ord/rating/'
        if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
                unity-tweak-tool
        else
                echo "Not using Unity as the current desktop, not launching tweak tool..."
        fi


else
        echo "Open up https://www.pling.com on your device"
        echo "and find a theme you like - enjoy!"
        sleep 4
fi
