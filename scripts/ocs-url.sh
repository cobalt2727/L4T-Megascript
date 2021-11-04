#!/bin/bash

clear -x
echo "ocs-url script started!"
echo 'This will allow you to actually USE that fancy "Install"'
echo "button on the Pling website and any of its derivatives."
sleep 3

sudo apt install git qt5-qmake make qml-module-qtquick-controls qtdeclarative5-dev libqt5svg5-dev libcanberra-gtk-module xdg-desktop-portal xdg-utils -y
package_available qt5-default
if [[ $? == "0" ]]; then
  sudo apt install -y qt5-default || error "Failed to install dependencies"
fi

if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
        sudo apt install unity-tweak-tool indicator-bluetooth indicator-sound hud -y
elif echo $XDG_CURRENT_DESKTOP | grep -q 'GNOME'; then  #multiple gnome variants exist out there, hence the different syntax - this'll also work on DEs like Budgie
        sudo apt install gnome-tweaks -y
#elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for the Mate desktop'; then
#        sudo apt install mate-control-center -y
else
        echo "Not using a DE with a known theme manager, skipping theme manager install..."
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

sudo make install || error "Make install failed"

cd ~
rm -rf ocs-url/

echo "Done!"

if [[ $DISPLAY ]]; then
        echo "Find a theme you like and install it - enjoy!"
        sleep 3
        

        if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
                unity-tweak-tool
        elif echo $XDG_CURRENT_DESKTOP | grep -q 'GNOME'; then  #multiple gnome variants exist out there, hence the different syntax - this'll also work on DEs like Budgie
                gnome-tweaks
                xdg-open 'https://www.gnome-look.org/browse?ord=rating'
        #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for the Mate desktop'; then
                #mate-appearance-properties -y
                #xdg-open 'https://www.mate-look.org/browse?ord=rating'
        #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for xfce'; then
                #command for theme chooser
                #xdg-open 'https://www.xfce-look.org/browse?ord=rating'
        #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for xfce'; then
                #command for theme chooser
                #xdg-open 'https://www.xfce-look.org/browse?ord=rating'
        else
                echo "Not using a DE with a known theme manager, not launching tweak tool..."
                #open up the default web browser
                xdg-open 'https://www.pling.com/browse/cat/381/ord/rating/'
        fi


else
        echo "Open up https://www.pling.com on your device"
        echo "and find a theme you like - enjoy!"
        sleep 4
fi
