#!/bin/bash

clear -x
echo "Custom Theme Toolbox script started!"
echo 'This will allow you to actually USE that fancy "Install"'
echo "button on the Pling website and any of its derivatives."
echo "In addition, I've included an installer for a QT settings tool"
echo "To automatically make QT apps follow the system theme."
sleep 3

get_system

if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
    sudo apt install unity-tweak-tool indicator-bluetooth indicator-sound hud -y
    elif echo $XDG_CURRENT_DESKTOP | grep -q 'GNOME'; then  #multiple gnome variants exist out there, hence the different syntax - this'll also work on DEs like Budgie
    sudo apt install gnome-tweaks -y
    #elif echo $XDG_CURRENT_DESKTOP | grep -q 'whatever it is for the Mate desktop'; then
    #        sudo apt install mate-control-center -y
else
    echo "Not using a DE with a known theme manager, skipping theme manager install..." #plasma comes with this built in, but need to add lxappearance for corresponding DEs
    # maybe check if Unity is installed here as a fallback - CLI installs won't detect ANY desktop using the above methods
fi


grep -v 'export QT_QPA_PLATFORMTHEME="gtk2"' ~/.profile > /tmp/.profile && mv /tmp/.profile ~/.profile #nuke the old bad config if it's found

echo "Installing QT5CT for management of QT5 settings..."
# check out /etc/X11/Xsession.d/99qt5ct after installing QT5CT for info on how environment variables are set up - the environment variable doesn't apply on Plasma, maybe disable it manually on LXQT?
case "$__os_id" in
    Raspbian|Debian|LinuxMint|Linuxmint|Ubuntu|[Nn]eon|Pop|Zorin|[eE]lementary|[jJ]ing[Oo][sS])
        sudo apt install -y qt5ct git qt5-qmake make qml-module-qtquick-controls qtdeclarative5-dev libqt5svg5-dev libcanberra-gtk-module xdg-desktop-portal xdg-utils python3-dbus
        
        sudo apt install  -y
        package_available qt5-default
        if [[ $? == "0" ]]; then
            sudo apt install -y qt5-default || error "Failed to install dependencies"
        fi
        
        package_available qt6ct
        if [[ $? == "0" ]]; then
            echo "Installing QT6CT for management of QT6 settings..."
            sudo apt install -y qt6ct qt6-gtk-platformtheme qt6-xdgdesktopportal-platformtheme || error "Failed to install QT6 settings!"
        else
            echo "Compiling QT6CT for management of QT6 settings..."
            # use Owen Kirby's QT6 PPA when testing this
            #add if statement for supported versions on next line?
            if grep -q 'bionic|focal|impish' /etc/os-release; then
                ppa_name="okirby/qt6-backports" && ppa_installer
            fi

            sudo apt install -y qt6-base-dev libqt6svg6-dev qt6-tools-dev libgtk2.0-dev qt6-base-private-dev || error "Failed to install dependencies!" #this is definitely missing dependencies, add more
            
            #GTK support for QT6
            cd ~
            git clone https://github.com/trialuser02/qt6gtk2
            cd qt6gtk2
            git pull
            qmake6 . || error "qmake failed!"
            make -j$(nproc) || error "make failed!"
            sudo make install || error "make install failed!"
            cd ~
            
            #theme selection tool for QT6
            cd ~
            git clone https://github.com/trialuser02/qt6ct
            cd qt6ct
            git pull
            qmake6 . || error "qmake failed!"
            make -j$(nproc) || error "make failed!"
            sudo make install || error "make install failed!"
            cd ~
        fi
        
        ##### only uncomment the following line if it's discovered that the Debian package doesn't auto set this in an env var like the Ubuntu package does
        # same goes for the Fedora package, of course
        # grep -qxF 'export QT_QPA_PLATFORMTHEME=qt5ct' ~/.profile || echo 'export QT_QPA_PLATFORMTHEME=qt5ct' | sudo tee --append ~/.profile
    ;;
    Fedora)
        #what RPM contains the GTK2 QT6 platform theme?
        sudo dnf install -y qt5ct qt6ct || error "Failed to install dependencies!" # untested dep list, please run this script on Fedora and use the automatic error reporter!
        #note to self: check if the RPM automatically sets up an environment variable like the Ubuntu package does
    ;;
    *)
        echo -e "\\e[91mUnknown distro detected - please press Ctrl+C now, then manually install QT5CT (and QT6CT if possible) via your package manager.\\e[39m"
        sleep 10
    ;;
esac

echo "Setting QT themes to automatically follow GTK themes when NOT running on KDE Plasma..."
mkdir -p ~/.config/qt5ct
mkdir -p ~/.config/qt6ct
touch ~/.config/qt5ct/qt5ct.conf
touch ~/.config/qt6ct/qt6ct.conf
tee ~/.config/qt5ct/qt5ct.conf <<'EOF' >>/dev/null
[Appearance]
standard_dialogs=gtk2
style=gtk2
EOF
tee ~/.config/qt6ct/qt6ct.conf <<'EOF' >>/dev/null
[Appearance]
standard_dialogs=gtk2
style=gtk2
EOF
# the previously mentioned env var - when set to "qt5ct" - is compatible qt6ct too

echo ""
echo "Please reboot or log out then back in to see QT applications match the (GTK) system theme!"
sleep 5

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
