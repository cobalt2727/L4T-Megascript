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
# obtain the distro info
get_system

# get the $DISTRIB_RELEASE and $DISTRIB_CODENAME by calling lsb_release
# check if upstream-release is available
if [ -f /etc/upstream-release/lsb-release ]; then
  echo "This is a Ubuntu Derivative, checking the upstream-release version info"
  DISTRIB_CODENAME=$(lsb_release -s -u -c)
  DISTRIB_RELEASE=$(lsb_release -s -u -r)
else
  DISTRIB_CODENAME=$(lsb_release -s -c)
  DISTRIB_RELEASE=$(lsb_release -s -r)
fi

minimumver="20.04"

if printf '%s\n' "$minimumver" "$DISTRIB_RELEASE" | sort -CV; then
  # 20.04 and up has snaps, run the scripts
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
    case "$DISTRIB_CODENAME" in
    focal | hirsute | impish)
      bash -c "$(curl https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/snapless-chromium.sh)"
      ;;
    *)
      bash -c "$(curl https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/snapless-chromium.sh)"
      bash -c "$(curl https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/snapless-firefox.sh)"
      ;;
    esac

    echo -e "\e[33mRead the following carefully and make sure it's not breaking anything (besides snap, we want that to get purged) before confirming the next command...\e[0m"
    sleep 5
    sudo apt purge snapd unattended-upgrades && sudo apt-mark hold snapd -y
    sudo apt autoremove
    sudo apt --fix-broken install
  else
    echo "Decided to keep the Snap store..."
    echo "If you ever change your mind, run the initial setup script again"
  fi
fi

# check for bad machine-id from 3.0.0 L4T Ubuntu image and fix if necessary
# also generate if user has somehow deleted their machine-id as well
if [[ $(cat /var/lib/dbus/machine-id) == "52e66c64e2624539b94b31f8412c6a7d" ]]; then
  sudo rm /var/lib/dbus/machine-id && dbus-uuidgen | sudo tee /var/lib/dbus/machine-id
elif [[ ! -f /var/lib/dbus/machine-id ]]; then
  dbus-uuidgen | sudo tee /var/lib/dbus/machine-id
fi

if [ -f /etc/switchroot_version.conf ]; then
  swr_ver=$(cat /etc/switchroot_version.conf)
  if [ $swr_ver == "3.4.0" ]; then
    # check for bad wifi/bluetooth firmware, overwritten by linux-firmware upgrade
    # FIXME: future versions of Switchroot L4T Ubuntu will fix this and the check will be removed
    if [[ $(sha1sum /lib/firmware/brcm/brcmfmac4356-pcie.bin | awk '{print $1}') != "6e882df29189dbf1815e832066b4d6a18d65fce8" ]]; then
      warning "Wifi was probably broken after an apt upgrade to linux-firmware"
      warning "Replacing with known good version copied from L4T 3.4.0 updates files"
      sudo wget -O /lib/firmware/brcm/brcmfmac4356-pcie.bin https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/switch-firmware-3.4.0/brcm/brcmfmac4356-pcie.bin
    fi
  fi
fi

# fix ppa for out of date repos
case "$DISTRIB_CODENAME" in
bionic)
  #bionic's flatpak package is out of date
  ppa_name="alexlarsson/flatpak" && ppa_installer
  #bionic cmake is very old, use theofficialgman ppa for cmake
  ppa_name="theofficialgman/cmake-bionic" && ppa_installer
  if [[ -f "/usr/bin/cmake" ]]; then
    #remove manually installed cmake versions (as instructed by theofficialgman) only if apt cmake is found
    sudo rm -rf '/usr/local/bin/cmake' '/usr/local/bin/cpack' '/usr/local/bin/ctest'
  fi
  hash -r
  ;;
xenial | jammy)
  ppa_name="alexlarsson/flatpak" && ppa_installer
  ;;
focal)
  ppa_name="alexlarsson/flatpak" && ppa_installer

  # use kitware apt repo for 20.04 as it has x86/x64_64 and armhf/arm64 support (armhf/arm64 not available from this repo for bionic which is why its not used there)
  sudo apt install gpg wget
  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
  echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
  sudo apt-get update
  sudo rm -f /usr/share/keyrings/kitware-archive-keyring.gpg
  sudo apt-get install kitware-archive-keyring -y
  if [ $? != 0 ]; then
    anything_installed_from_repo "https://apt.kitware.com/ubuntu/"
    if [ $? != 0 ]; then
      # nothing installed from repo, this check is to prevent removing repos which other pi-apps scripts or the user have used successfully
      # safe to remove
      sudo rm -f /etc/apt/sources.list.d/kitware.list /usr/share/keyrings/kitware-archive-keyring.gpg
    fi
    sudo apt update
    warning "Could not install Kitware apt repo needed for updated cmake. Removed the Kitware repo to prevent apt errors"
  fi

  if [[ -f "/usr/bin/cmake" ]]; then
    #remove manually installed cmake versions (as instructed by theofficialgman) only if apt cmake is found
    sudo rm -rf '/usr/local/bin/cmake' '/usr/local/bin/cpack' '/usr/local/bin/ctest'
  fi
  hash -r
  ;;
esac

# install SDL2
echo "Installing SDL2..."
bash -c "$(curl https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"

#updates whee
sudo apt upgrade -y
sudo apt --fix-broken install

#this is an apt package in the Switchroot repo, for documentation join their Discord https://discord.gg/9d66FYg and check https://discord.com/channels/521977609182117891/567232809475768320/858399411955433493
if [[ $jetson_model ]]; then
  sudo apt install switch-multimedia -y
fi

if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
  sudo apt install unity-tweak-tool hud -y
else
  echo "Not using Unity as the current desktop, skipping theme manager install..."
fi

#install some recommended dependencies - the fonts packages are there to support a lot of symbols and foreign language characters
sudo apt install apt-utils subversion wget flatpak qt5-style-plugins gnutls-bin cmake-data libjsoncpp1 libuv1 cmake git -y
# fonts-noto-cjk fonts-noto-cjk-extra fonts-migmix fonts-noto-color-emoji

if [[ $jetson_model ]]; then
  # fix up an issue with running flatpaks by enabling non-privileged user namespaces
  # this is enabled in the kernel defconfig... no clue why it doesn't work
  sudo chmod u+s /usr/libexec/flatpak-bwrap
  sudo chown -R $USER ~/.local/share/flatpak
fi

#kinda hard to install flatpaks without flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#fix error at https://forum.xfce.org/viewtopic.php?id=12752
sudo chown $USER:$USER $HOME/.local/share/flatpak

hash -r

clear -x
description="Do you want to install configurations that will let you use the joycons as a mouse?"
table=("yes" "no")
userinput_func "$description" "${table[@]}"
if [[ $output == "yes" ]]; then
  echo "Installing the Joycon Mouse..."
  bash -c "$(curl https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/joycon-mouse.sh)"
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
  sudo make install || error "Make install failed"
  cd ~
  rm -rf htop
elif [[ $output == "no" ]]; then
  echo "Going to the next option"
fi

clear -x
description="Do you want to build and install neofetch?\
\n\nNeofetch displays information about your operating system,\
\nsoftware and hardware in an aesthetic and visually pleasing way."
table=("yes" "no")
userinput_func "$description" "${table[@]}"
if [[ $output == "yes" ]]; then
  echo "Building and installing neofetch from theofficialgman fork (newer than the package included in bionic)..."
  cd /tmp
  rm -rf neofetch
  sudo apt install pciutils mesa-utils -y
  git clone --branch merged-branch https://github.com/theofficialgman/neofetch.git
  cd neofetch && sudo make install || error "Make install failed"
  cd ~
  rm -rf /tmp/neofetch
elif [[ $output == "no" ]]; then
  echo "Going to the next option"
fi

clear -x
