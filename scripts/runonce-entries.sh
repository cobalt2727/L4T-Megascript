#!/bin/bash

#This script contains various dirty fixes and initial setup commands to keep L4T Ubuntu running smoothly as it matures.
#It repairs mistakes that some apps have made, as well as fixing other system issues.

#This script is executed by the core_refactor2.sh script.

#This script uses the 'runonce' function - it avoids running any of these fixes more than once.
#If a runonce entry is modified, then it will be run once more.

#Set DIRECTORY variable if necessary
if [ -z "$DIRECTORY" ];then
  export DIRECTORY="$HOME/L4T-Megascript"
fi

function error_fatal {
  echo -e "\\e[91m$1\\e[39m"
  sleep 10
  exit 1
}


#Get functions if necessary
if ! command -v runonce >/dev/null ;then
  unset functions_downloaded
  source <(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/functions.sh)
  [[ ! -z ${functions_downloaded+z} ]] && status "Functions Loaded" || error_fatal "Oh no! Something happened to your internet! Exiting the Megascript, please fix your internet and try again!"
fi

#remove snap store
runonce <<"EOF"
minimumver="20.04"

if printf '%s\n' "$minimumver" "$__os_release" | sort -CV; then
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
    case "$__os_codename" in
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
EOF

#remove gnome software snap plugin
runonce <<"EOF"
if package_installed "gnome-software-plugin-snap"; then
  description="Do you want to remove the snap pluin from the gnome software store? If unsure, think of it as\
\nbloatware from Canonical\
\nIt's controversial for a few reasons:\
\n - the store is closed source, which is a bit weird for a Linux company...\
\n - programs installed from them are in containers,\
\n   which means they won't run as well\
\n - the biggest issue is that on Tegra hardware, there is no GPU hardware acceleration from snaps.\
\nIt's recommended by us to switch from snaps to apt, flatpak, and\
\nbuilding from source whenever possible.\
\nSo as you can probably tell, we're extremely biased against\
\nit and would recommend removing it. But the choice is yours:\
\n \n Do you want to remove the gnome software store snap plugin?"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  if [[ $output == "yes" ]]; then
    sudo apt remove gnome-software-plugin-snap -y
  fi
fi
EOF

# check for bad machine-id from 3.0.0 L4T Ubuntu image and fix if necessary
# also generate if user has somehow deleted their machine-id as well
runonce <<"EOF"
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
EOF

# fix ppa for out of date repos
runonce <<"EOF"
case "$__os_codename" in
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
xenial)
  ppa_name="alexlarsson/flatpak" && ppa_installer
  ;;
focal)
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
EOF

# add more helpful PPAs
runonce <<"EOF"
case "$__os_codename" in
bionic|focal|jammy)
  ppa_name="theofficialgman/gpu-tools" && ppa_installer
  ;;
esac
EOF

# upgrade the install once
runonce <<"EOF"
status "Running APT updates..."
sudo apt-get dist-upgrade -y || error "Temporarily turning on error reporting for apt upgrades to aid in bugfixing with Switchroot's 5.0 update! Please do not send in this report unless you are running a Nintendo Switch, and you've seen this message MULTIPLE TIMES."
EOF

# install SDL2
runonce <<"EOF"
status "Installing SDL2..."
bash -c "$(curl https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
EOF

#install some recommended dependencies
runonce <<"EOF"
sudo apt install apt-utils subversion wget flatpak qt5-style-plugins gnutls-bin cmake-data libjsoncpp1 libuv1 cmake git mesa-utils -y
hash -r
EOF

#flatpak fixup
runonce <<"EOF"
if [ -f /etc/switchroot_version.conf ]; then
  swr_ver=$(cat /etc/switchroot_version.conf)
  if [[ $swr_ver == 3.*.* ]]; then
    # fix up an issue with running flatpaks by enabling non-privileged user namespaces
    # no clue why it doesn't work but works on L4T 5.0.0
    sudo chmod u+s /usr/libexec/flatpak-bwrap
  else
    # reinstall flatpak package incase we messed with the permissions previously
    sudo apt install --reinstall flatpak -y
  fi
fi

#fix error at https://forum.xfce.org/viewtopic.php?id=12752
sudo chown $USER:$USER $HOME/.local/share/flatpak

#kinda hard to install flatpaks without flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
EOF

runonce <<"EOF"
BSP_version="$(glxinfo -B | grep -E "NVIDIA [0-9]+.[0-9]+.[0-9]+$" | head -n1 | awk '{print $(NF)}')"
case "$jetson_chip_model" in
"t186"|"t194"|"t210"|"t234")
  case "$BSP_version" in
  "32.3.1"|"32.7.3"|"35.1.0"|"35.2.1")
    # installing tegra Flatpak BSP and workarounds
    sudo flatpak override --device=all
    sudo flatpak override --share=network
    sudo flatpak override --filesystem=/sys
    echo "export FLATPAK_GL_DRIVERS=nvidia-tegra-${BSP_version//./-}" | sudo tee /etc/profile.d/flatpak_tegra.sh
    sudo sh -c "cat > /etc/sudoers.d/flatpak_tegra << _EOF_
Defaults      env_keep += FLATPAK_GL_DRIVERS
_EOF_"

    cd /tmp || error "Could not move to /tmp directory. Is your install corrupted?"
    rm -f org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}.flatpak
    wget --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/Flatpak/$jetson_chip_model/org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}.flatpak || error "Failed to download $jetson_chip_model org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" || "Download failed"
    sync

    #Only try to remove flatpak app if it's installed.
    if flatpak list | grep -qF "org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" ;then
      sudo flatpak uninstall "org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" -y -vv
    fi

    sudo flatpak install --system ./org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}.flatpak -y -vv || error "Failed to install org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}"

    # install the gnome software center flatpak plugin
    sudo apt install -y gnome-software-plugin-flatpak --no-install-recommends
    ;;
  *)
    warning "You are not running L4T 32.3.1, 32.7.3, 35.1.0, or 35.2.1. Flatpak GPU hardware acceleration is not available." ;;
  esac
  ;;
esac

hash -r
EOF

true
