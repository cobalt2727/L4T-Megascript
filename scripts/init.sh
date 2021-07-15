#!/bin/bash

clear -x
echo "Initial setup script started!"
cd ~
echo "Checking for updates and installing a few extra recommended packages."
echo "This might take a while, depending on your internet speed."
echo "Grab your charger, and pull up a chair!"
echo "CREDITS:"
echo "  https://gbatemp.net/threads/l4t-ubuntu-a-fully-featured-linux-on-your-switch.537301/"
echo "  Optional tab on https://gbatemp.net/threads/installing-moonlight-qt-on-l4t-ubuntu.537429/"
echo "  https://flatpak.org/setup/"
sleep 10

if grep -q bionic /etc/os-release; then
  echo
  ##snap store is not preinstalled on 18.04, nothing to do here
else
  description="Do you want to remove the snap store? If unsure, think of it as\
  \nbloatware from Canonical\
  \nIt's controversial for a few reasons:\
  \n - the store is closed source, which is a bit weird for a Linux company...\
  \n - programs installed from them are in containers,\
  \n   which means they won't run as well\
  \n - the biggest issue, especially on a weaker device like\
  \n   the Tegra hardware you're using right now, is that\
  \n   it automatically updates snap packages whenever it wants\
  \n   to, with no input from the user - which can obviously\
  \n   slow anything you're doing at the moment down.\
  \nThat being said, if you've already been using this device for a while,\
  \nYou may want to keep it for now since you might have installed stuff\
  \nusing it. It's recommended by us to switch from snaps to apt, flatpak, and\
  \nbuilding from source whenever possible.\
  \nSo as you can probably tell, we're extremely biased against\
  \nit and would recommend removing it. But the choice is yours:\
  \n \n Do you want to remove the Snap Store?"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  if [[ $output == "yes" ]]; then
    echo -e "\e[32mRemoving the Snap store...\e[0m"
    sudo apt purge snapd unattended-upgrades
  else
    echo "Decided to keep the Snap store..."
    echo "If you ever change your mind, type:"
    echo -e "\e[36msudo apt purge snapd unattended-upgrades -y\e[0m"
    sleep 5
  fi
fi

if grep -q bionic /etc/os-release; then
  #bionic's flatpak package is out of date
  sudo add-apt-repository ppa:alexlarsson/flatpak -y
  #bionic cmake is very old
  sudo add-apt-repository ppa:rncbc/libs-bionic -y
  #remove manually installed cmake versions (as instructed by theofficialgman)
  sudo rm -rf '/usr/local/bin/cmake' '/usr/local/bin/cpack' '/usr/local/bin/ctest'
  hash -r
fi

#focal's flatpak package is also out of date (I get LTS is supposed to put stability above all else, but seriously?)
if grep -q focal /etc/os-release; then
  sudo add-apt-repository ppa:alexlarsson/flatpak -y
fi

#updates whee
sudo apt upgrade -y
#this is an apt package in the Switchroot repo, for documentation join their Discord https://discord.gg/9d66FYg and check https://discord.com/channels/521977609182117891/567232809475768320/858399411955433493
sudo apt install switch-multimedia -y

#automatically sorts Gnome app layout alphabetically
gsettings reset org.gnome.shell app-picker-layout

#install some recommended dependencies - the fonts packages are there to support a lot of symbols and foreign language characters
sudo apt install joycond subversion wget flatpak gnome-software-plugin-flatpak qt5-style-plugins gnutls-bin -y
# fonts-noto-cjk fonts-noto-cjk-extra fonts-migmix fonts-noto-color-emoji
hash -r

#it's a very very bad idea to have this on Tegra hardware
sudo apt remove unattended-upgrades -y

#automatically sets QT applications to follow the system theme
grep -qxF 'export QT_QPA_PLATFORMTHEME=gtk2' ~/.profile || echo 'export QT_QPA_PLATFORMTHEME=gtk2' | sudo tee --append ~/.profile
#and now i (attempt to) force it on anyway so that the user doesn't have to reboot to see the effect
#i'm not entirely positive this works, they still might have to reboot or log out and log back in
#oh well
export QT_QPA_PLATFORMTHEME=gtk2

echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo touch /etc/udev/rules.d/51-gcadapter.rules
echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules >/dev/null
sudo udevadm control --reload-rules
sudo systemctl restart udev.service
cd ~

#kinda hard to install flatpaks without flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#fix up an issue with running flatpaks by enabling non-privileged user namespaces
sudo chmod u+s /usr/libexec/flatpak-bwrap

# echo "Do you want to install the swapfile (You need 2 GB. Very important to avoid lag and potential crashes)"
# read -p "(y/n) " userInput
# if [[ $userInput == y || $userInput == Y ]]; then
# echo "Installing the swapfile..."
# bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/swapfile.sh)"
# elif [[ $userInput == n || $userInput == N ]]; then
# echo "Skipping swapfile setup..."
# fi
# sleep 1

clear -x
description="Do you want to install configurations that will let you use the joycons as a mouse?"
table=("yes" "no")
userinput_func "$description" "${table[@]}"
if [[ $output == "yes" ]]; then
  echo "Installing the Joycon Mouse..."
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/joycon-mouse.sh)"
elif [[ $output == "no" ]]; then
  echo "Going to the next option"
fi

clear -x
description="Do you want to add a Application/Program/Game Helper? \
\nThis will assist you in adding program binaries you download to your applications list"
table=("yes" "no")
userinput_func "$description" "${table[@]}"
if [[ $output == "yes" ]]; then
  echo "Installing the generic program helper..."
  sudo tee /usr/share/applications/generic_helper.desktop <<'EOF'
[Desktop Entry]
Type=Application
Exec=bash -c 'bash <( wget -O - https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/generic/generic_program_helper.sh )'
Name=Generic Application Helper
Icon=/usr/share/icons/L4T-Megascript.png
Terminal=hidden
Categories=System
EOF
elif [[ $output == "no" ]]; then
  echo "Going to the next option"
fi

clear -x
description="Do you want to build and install SDL2? (Required for many games in the script)"
table=("yes" "no")
userinput_func "$description" "${table[@]}"
if [[ $output == "yes" ]]; then
  echo "Building and installing SDL2..."
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
elif [[ $output == "no" ]]; then
  echo "Going to the next option"
fi

clear -x 
description="Do you want to build and install htop?\
\n(A useful command line utility for viewing cpu/thread usage and frequency)"
table=("yes" "no")
userinput_func "$description" "${table[@]}"
if [[ $output == "yes" ]]; then
  echo "Building and installing htop 3.0.5 (newer than the package included in bionic)..."
  cd ~
  rm -rf htop
  sudo apt remove htop -y
  sudo apt install libncursesw*-dev dh-autoreconf -y
  git clone https://github.com/htop-dev/htop.git
  cd htop
  git checkout 3.0.5
  ./autogen.sh && ./configure && make -j$(nproc)
  sudo make install
  cd ~
  rm -rf htop
elif [[ $output == "no" ]]; then
  echo "Going to the next option"
fi

clear -x
