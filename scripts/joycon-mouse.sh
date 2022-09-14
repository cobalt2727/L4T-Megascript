#!/bin/bash

clear -x
echo "Joycon mouse script started!"
get_system
sleep 1
cd /tmp
sudo rm -rf 50-joystick.conf

echo "Installing dependencies..."
case "$__os_id" in
    Raspbian | Debian | Ubuntu | Kali)
        
        sudo apt install xserver-xorg-input-joystick wget -y
        
        package_available joycond
        if [[ $? == "0" ]]; then
            sudo apt install -y joycond || error "Failed to install dependencies"
        else
            echo "Installing joycond from source..."
            sudo apt install -y libevdev-dev git cmake || error "Failed to install dependencies"
            git clone https://github.com/DanielOgorchock/joycond --depth=1
            cd joycond
            git pull
            cmake . || error "Cmake failed"
            sudo make install || error "Failed to make install"
            sudo systemctl enable --now joycond || error "Couldn't enable the joycond service for some reason - PLEASE send us this error!"
        fi
        
    ;;
    Fedora)
        #TODO
        sudo dnf install joycond wget -y || error "Failed to install dependencies!"
    ;;
    *)
        echo -e "\\e[91mUnknown distro detected - this script should work, but you'll need to install xserver-xorg-input-joystick yourself...\\e[39m"
        sleep 5
    ;;
esac

# sudo rm -rf /usr/share/X11/xorg.conf.d/50-joystick.conf
wget https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/50-joystick.conf && sudo mv 50-joystick.conf /usr/share/X11/xorg.conf.d

description="Joy-Con Mouse Primary Default Mapping\
\nMappings for all supported controlers are in the config file: https://github.com/cobalt2727/L4T-Megascript/blob/master/assets/50-joystick.conf\
\n| Button | Key |\
\n|------------- | ----- |\
\n| B | Left Click |\
\n| A | Right Click|\
\n| X | Middle Mouse Button|\
\n| L | Volume Down|\
\n| R | Volume Up  |\
\n|ZR| Brightness Up|\
\n|ZL| Brightness Down|\
\n|D-PAD| Keyboard Arrow Keys|\
\n|Screenshot| Turn the mouse off and on (leave off when playing games)| \
\n|Home | Escape |\
\n|+| Enter |\
\n|-| Back |\
\n| Right Stick Click | F5 |\
\n| Left Stick XY | Mouse XY |\
\n| Right Stick XY | Scroll XY |"

table=("ok")
userinput_func "$description" "${table[@]}"

description="Done!\
\n\n Restart your Switch when you're ready to gain access to using your joycons as a mouse.\n And just to reiterate, since people sometimes gloss over it on the previous screen, remember to use the SCREENSHOT button to turn the mouse on/off."
table=("ok")
userinput_func "$description" "${table[@]}"
