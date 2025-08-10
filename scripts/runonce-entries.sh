#!/bin/bash

#This script contains various dirty fixes and initial setup commands to keep L4T Ubuntu running smoothly as it matures.
#It repairs mistakes that some apps have made, as well as fixing other system issues.

#This script is executed by the core_refactor2.sh script.

#This script uses the 'runonce' function - it avoids running any of these fixes more than once.
#If a runonce entry is modified, then it will be run once more.

#Set DIRECTORY variable if necessary
if [ -z "$DIRECTORY" ]; then
  export DIRECTORY="$HOME/L4T-Megascript"
fi

function error_fatal {
  echo -e "\\e[91m$1\\e[39m"
  sleep 10
  exit 1
}

#Get functions if necessary
if ! command -v runonce >/dev/null; then
  unset functions_downloaded
  source <(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/functions.sh)
  [[ ! -z ${functions_downloaded+z} ]] && status "Functions Loaded" || error_fatal "Oh no! Something happened to your internet! Exiting the Megascript, please fix your internet and try again!"
fi

case "$__os_id" in
[Ff]edora)
############## fedora runonce entries start here ##############
# upgrade the install once
runonce <<"EOF"
status "Running DNF updates..."
sudo dnf --refresh --best --allowerasing -y upgrade || error "Temporarily turning on error reporting for dnf upgrades to aid in bugfixing with L4S Fedora! Please do not send in this report unless you are running a Nintendo Switch, and you've seen this message MULTIPLE TIMES."
EOF
############## fedora runonce entries end here ##############
;;
*)
############## non-fedora runonce entries start here ##############
#correct switchroot apt key if necessary
runonce <<"EOF"
if grep -q debian /etc/os-release; then
  export LANG="C.UTF-8"
  export LANGUAGE="C.UTF-8"
  export LC_ALL="C.UTF-8"
  apt-key list 2>/dev/null | grep -q 'expired] Switchroot Apt Repo Automated Signing Key'
  if [ $? == 0 ]; then
    if [[ $gui == "gui" ]]; then
      echo -e "\e[96mThe Switchroot Apt Repo Signing Key has expired. Please provide your password in the popup to update it.\e[0m"
      pkexec sh -c "apt-key del 92813F6A23DB6DFC && wget -O - https://newrepo.switchroot.org/pubkey | apt-key add -"
    else
      echo -e "\e[96mThe Switchroot Apt Repo Signing Key has expired. Please provide your password if requested to update it.\e[0m"
      sudo apt-key del 92813F6A23DB6DFC
      wget -O - https://newrepo.switchroot.org/pubkey | sudo apt-key add -
    fi
  fi
fi
EOF

#remove snap store
runonce <<"EOF"
if command -v snap; then
  minimumver="20.04"

  if printf '%s\n' "$minimumver" "$__os_release" | sort -CV; then
    # 20.04 and up has snaps, run the scripts
    description="Do you want to remove all snaps and the snap store? If unsure, think of the snap store as\
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
  \n \n Do you want to remove the Snap Store?\
  \nThis script will also install the official Firefox PPA\
  \ninstead of the Snap version on 22.04 and newer."
    table=("yes" "no")
    userinput_func "$description" "${table[@]}"
    if [[ $output == "yes" ]]; then
      echo -e "\e[32mRemoving the Snap store...\e[0m"
      case "$__os_codename" in
      bionic | focal | jammy | noble)
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
    fi
  fi
fi
EOF

#remove gnome software snap plugin
runonce <<"EOF"
if package_installed "gnome-software-plugin-snap"; then
  description="Do you want to remove the snap plugin from the gnome software store? If unsure, think of it as\
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

#fix conflicting box86/box64 .list and .sources file
runonce <<"EOF"
if [ -f /etc/apt/sources.list.d/box64.list ] && [ -f /etc/apt/sources.list.d/box64.sources ]; then
  sudo rm -f /etc/apt/sources.list.d/box64.list
fi
if [ -f /etc/apt/sources.list.d/box86.list ] && [ -f /etc/apt/sources.list.d/box86.sources ]; then
  sudo rm -f /etc/apt/sources.list.d/box86.list
fi
EOF

# fix ppa for out of date repos
runonce <<"EOF"
if ! package_is_new_enough flatpak 1.14.4 ;then
  case "$__os_codename" in
  bionic|focal|jammy)
    sudo rm -f /etc/apt/sources.list.d/alexlarsson-ubuntu-flatpak-$__os_codename.list
    ubuntu_ppa_installer "theofficialgman/flatpak-no-bwrap" || error "PPA failed to install"
    ;;
  esac
fi
true
EOF

runonce <<"EOF"
case "$__os_codename" in
bionic)
  #bionic cmake is very old, use theofficialgman ppa for cmake
  ubuntu_ppa_installer "theofficialgman/cmake-bionic" || error "PPA failed to install"
  if [[ -f "/usr/bin/cmake" ]]; then
    #remove manually installed cmake versions (as instructed by theofficialgman) only if apt cmake is found
    sudo rm -rf '/usr/local/bin/cmake' '/usr/local/bin/cpack' '/usr/local/bin/ctest'
  fi
  hash -r
  ;;
xenial)
  ubuntu_ppa_installer "alexlarsson/flatpak" || error "PPA failed to install"
  ;;
focal)
  # use kitware apt repo for 20.04 as it has x86/x64_64 and armhf/arm64 support (armhf/arm64 not available from this repo for bionic which is why its not used there)
  sudo apt install gpg wget
  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
  echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
  sudo apt-get update
  sudo rm -f /usr/share/keyrings/kitware-archive-keyring.gpg
  sudo apt-get install kitware-archive-keyring -y --reinstall
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

# add ppas for debian
runonce <<"EOF"
case "$__os_codename" in
buster|bullseye)
  debian_ppa_installer "theofficialgman/cmake-bionic" "bionic" "0ACACB5D1E74E484" || exit 1
  ;;
esac
case "$__os_codename" in
buster)
  debian_ppa_installer "theofficialgman/flatpak-no-bwrap" "bionic" "0ACACB5D1E74E484" || exit 1
  ;;
bullseye)
  debian_ppa_installer "theofficialgman/flatpak-no-bwrap" "focal" "0ACACB5D1E74E484" || exit 1
  ;;
esac
EOF

# add more helpful PPAs
runonce <<"EOF"
case "$__os_codename" in
bionic|focal|jammy)
  ubuntu_ppa_installer "theofficialgman/gpu-tools" || error "PPA failed to install"
  ;;
esac
EOF

# add git ppa
runonce <<"EOF"
case "$__os_codename" in
xenial|bionic|focal|jammy|noble)
  ubuntu_ppa_installer "git-core/ppa" || error "PPA failed to install"
  ;;
esac
EOF

# downgrade glibc to 2.27 on bionic if hack is present from years ago
runonce <<"EOF"
case "$__os_codename" in
bionic)
  if $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libc6) lt 2.28); then
    status_green "GLIBC Version is good. Continuing..."
  else
    status "Force downgrading libc and related packages"
    status "libc 2.28 was previously required for the minecraft bedrock install"
    status "this is no longer the case so the hack is removed"
    warning "You may need to recompile other programs such as Dolphin if you see this message"
    sudo rm -rf /etc/apt/sources.list.d/zorinos-ubuntu-stable-bionic.list*
    sudo rm -rf /etc/apt/preferences.d/zorinos*
    sudo rm -rf /etc/apt/sources.list.d/debian-stable.list*
    sudo rm -rf /etc/apt/preferences.d/freetype*

    sudo apt update
    sudo apt install libc-bin=2.27* libc-dev-bin=2.27* libc6=2.27* libc6-dbg=2.27* libc6-dev=2.27* libfreetype6=2.8* libfreetype6-dev=2.8* locales=2.27* -y --allow-downgrades
  fi
  ;;
esac
EOF

# correct python issues
runonce <<"EOF"
package_available python-minimal
if [[ $? == "0" ]]; then #the python-minimal package only exists on Ubuntu 18.04/Debian 10 and below, so it's a good identifier
  if [ -f /etc/alternatives/python ]; then
    status "Fixing possibly broken Python setup..."
    sudo rm /etc/alternatives/python && sudo apt install --reinstall python-minimal -y
  else
    status_green "No issues detected with Python, skipping fix for that..."
  fi
else
  if [ -f /etc/alternatives/python ]; then
    status "Fixing possibly broken Python setup..."
    sudo rm /etc/alternatives/python && sudo apt install --reinstall python3-minimal python-is-python3 -y
  else
    status_green "No issues detected with Python, skipping fix for that..."
  fi
fi
EOF

#correct home ownership of gnupg repo
runonce <<"EOF"
  if [ -d ~/.gnupg ] && stat -c "%U %G" ~/.gnupg/* | grep -q "root"; then
    sudo chown -R $USER:$USER ~/.gnupg
  fi
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
sudo apt install apt-utils subversion wget flatpak qt5-style-plugins gnutls-bin cmake-data libuv1 cmake git mesa-utils -y
hash -r
EOF

#flatpak fixup
runonce <<"EOF"
! package_installed flatpak && sudo apt install flatpak -y
BSP_version="$(strings /usr/lib/xorg/modules/extensions/libglxserver_nvidia.so | grep -E "nvidia id: NVIDIA GLX Module  [0-9]+.[0-9]+.[0-9]+.*$" | awk '{print $6}')"
[ -z "$BSP_version" ] && BSP_version="$(glxinfo -B | grep -E "NVIDIA [0-9]+.[0-9]+.[0-9]+$" | head -n1 | awk '{print $(NF)}')"
if [ -f /etc/switchroot_version.conf ]; then
  swr_ver=$(cat /etc/switchroot_version.conf)
  if [[ $swr_ver == 3.*.* ]]; then
    # fix up an issue with running flatpaks by enabling non-privileged user namespaces
    # SWR does not have CONFIG_NAMESPACES and CONFIG_USER_NS enabled in the kernel on 3.X.X
    sudo chmod u+s /usr/libexec/flatpak-bwrap
  else
    # reinstall flatpak package incase we messed with the permissions previously
    sudo apt install --reinstall flatpak -y
  fi
elif [[ "$BSP_version" == 32.*.* ]]; then
  # fix up an issue with running flatpaks by enabling non-privileged user namespaces
  # L4T R32 does not have CONFIG_NAMESPACES and CONFIG_USER_NS enabled in the kernel
  sudo chmod u+s /usr/libexec/flatpak-bwrap
fi

#fix error at https://forum.xfce.org/viewtopic.php?id=12752
sudo chown $USER:$USER $HOME/.local/share/flatpak

#kinda hard to install flatpaks without flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
EOF

# newer Nvidia Jetpack that have the /sys/module/nvidia module no longer need any overrides
if [ -f /sys/module/nvidia/version ] && [ -f /etc/profile.d/flatpak_tegra.sh ] ; then
sudo flatpak override --reset
flatpak override --reset
sudo rm -f /etc/profile.d/flatpak_tegra.sh
sudo rm -f /etc/sudoers.d/flatpak_tegra
fi

runonce <<"EOF"
if ! package_installed switch-flatpak ; then
[ -f /sys/module/nvidia/version ] && BSP_version="$(cat /sys/module/nvidia/version)"
[ -z "$BSP_version" ] && BSP_version="$(strings /usr/lib/xorg/modules/extensions/libglxserver_nvidia.so | grep -E "nvidia id: NVIDIA GLX Module  [0-9]+.[0-9]+.[0-9]+.*$" | awk '{print $6}')"
[ -z "$BSP_version" ] && BSP_version="$(glxinfo -B | grep -E "NVIDIA [0-9]+.[0-9]+.[0-9]+$" | head -n1 | awk '{print $(NF)}')"
case "$jetson_chip_model" in
"t186"|"t194"|"t210"|"t234")
  case "$BSP_version" in
  "32.3.1"|"32.7.3"|"32.7.4"|"32.7.6"|"35.1.0"|"35.2.1"|"35.3.1")
    # installing tegra Flatpak BSP and workarounds
    sudo flatpak override --device=all
    sudo flatpak override --share=network
    sudo flatpak override --filesystem=/sys
    flatpak override --user --device=all
    flatpak override --user --share=network
    flatpak override --user --filesystem=/sys
    
    echo "export FLATPAK_GL_DRIVERS=nvidia-tegra-${BSP_version//./-}" | sudo tee /etc/profile.d/flatpak_tegra.sh
    sudo tee -a /etc/profile.d/flatpak_tegra.sh << '_EOF_'
if command -v flatpak > /dev/null && [ -n "$DESKTOP_SESSION" ]; then
    if [ ! -f ~/.local/share/flatpak/overrides/global ]; then
  	    flatpak override --user --device=all --share=network --filesystem=/sys
    elif ! (grep -q "shared=network;" ~/.local/share/flatpak/overrides/global && grep -q "devices=all;" ~/.local/share/flatpak/overrides/global && grep -q "filesystems=/sys;" ~/.local/share/flatpak/overrides/global) ; then
        flatpak override --user --device=all --share=network --filesystem=/sys
    fi
fi
_EOF_

    sudo sh -c "cat > /etc/sudoers.d/flatpak_tegra << _EOF_
Defaults      env_keep += FLATPAK_GL_DRIVERS
_EOF_"

    cd /tmp || error "Could not move to /tmp directory. Is your install corrupted?"
    rm -f org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}.flatpak
    wget --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/Flatpak/$jetson_chip_model/org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}.flatpak || error "Failed to download $jetson_chip_model org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}"
    sync

    #Only try to remove flatpak app if it's installed.
    if flatpak list | grep -qF "org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" ;then
      sudo flatpak uninstall "org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" -y -vv
    fi

    sudo flatpak install --system ./org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}.flatpak -y -vv || error "Failed to install org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}"
    sudo flatpak pin --system runtime/org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}/aarch64/1.4

    # install the gnome software center flatpak plugin
    sudo apt install -y gnome-software-plugin-flatpak --no-install-recommends
    ;;
  "35.4.1")
    if [ ! -f /sys/module/nvidia/version ]; then
      echo "export FLATPAK_GL_DRIVERS=nvidia-${BSP_version//./-}" | sudo tee /etc/profile.d/flatpak_tegra.sh
      sudo sh -c "cat > /etc/sudoers.d/flatpak_tegra << _EOF_
Defaults      env_keep += FLATPAK_GL_DRIVERS
_EOF_"
    fi
    # installing tegra Flatpak BSP
    cd /tmp || error "Could not move to /tmp directory. Is your install corrupted?"
    rm -f org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}.flatpak
    wget --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/Flatpak/$jetson_chip_model/org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}.flatpak || error "Failed to download $jetson_chip_model org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}"
    sync

    #Only try to remove flatpak app if it's installed.
    if flatpak list | grep -qF "org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" ;then
      sudo flatpak uninstall "org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" -y -vv
      sudo flatpak pin --remove runtime/org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}/aarch64/1.4 || true
    elif flatpak list | grep -qF "org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}" ;then
      sudo flatpak uninstall "org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}" -y -vv
    fi

    sudo flatpak install --system ./org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}.flatpak -y -vv || error "Failed to install org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}"
    sudo flatpak pin --system runtime/org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}/aarch64/1.4

    # install the gnome software center flatpak plugin
    sudo apt install -y gnome-software-plugin-flatpak --no-install-recommends
    ;;
  "540.2.0"|"540.3.0"|"540.4.0")
    # installing tegra Flatpak BSP and workarounds
    sudo flatpak override --device=all
    flatpak override --user --device=all
    
    echo "export FLATPAK_GL_DRIVERS=nvidia-${BSP_version//./-}" | sudo tee /etc/profile.d/flatpak_tegra.sh
    sudo tee -a /etc/profile.d/flatpak_tegra.sh << '_EOF_'
if command -v flatpak > /dev/null && [ -n "$DESKTOP_SESSION" ]; then
    if [ ! -f ~/.local/share/flatpak/overrides/global ]; then
  	    flatpak override --user --device=all
    elif ! grep -q "devices=all;" ~/.local/share/flatpak/overrides/global ; then
        flatpak override --user --device=all
    fi
fi
_EOF_

    sudo sh -c "cat > /etc/sudoers.d/flatpak_tegra << _EOF_
Defaults      env_keep += FLATPAK_GL_DRIVERS
_EOF_"
    cd /tmp || error "Could not move to /tmp directory. Is your install corrupted?"
    rm -f org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}.flatpak
    wget --progress=bar:force:noscroll https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/Flatpak/$jetson_chip_model/org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}.flatpak || error "Failed to download $jetson_chip_model org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}"
    sync

    #Only try to remove flatpak app if it's installed.
    if flatpak list | grep -qF "org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" ;then
      sudo flatpak uninstall "org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}" -y -vv
      sudo flatpak pin --remove runtime/org.freedesktop.Platform.GL.nvidia-tegra-${BSP_version//./-}/aarch64/1.4 || true
    elif flatpak list | grep -qF "org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}" ;then
      sudo flatpak uninstall "org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}" -y -vv
    fi

    sudo flatpak install --system ./org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}.flatpak -y -vv || error "Failed to install org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}"
    sudo flatpak pin --system runtime/org.freedesktop.Platform.GL.nvidia-${BSP_version//./-}/aarch64/1.4

    # install the gnome software center flatpak plugin
    sudo apt install -y gnome-software-plugin-flatpak --no-install-recommends
    ;;
  *)
    warning "Your version of L4T ($BSP_version) is not currently supported. Flatpak GPU hardware acceleration is not available."
    warning 'The current supported jetson chip models are t186/t194/t210/t234 on L4T 32.3.1/32.7.3/32.7.4/32.7.6/35.1.0/35.2.1/35.3.1/35.4.1/36.2.0/36.3.0/36.4.0'
    echo "$jetson_chip_model - $model - $__os_desc - $BSP_version Unsupported BSP version detected for Flatpak hardware acceleration." >/tmp/output.txt
    send_error "/tmp/output.txt"
    ;;
  esac
  ;;
esac


hash -r
fi
EOF
;;
esac
############## non-fedora runonce entries end here ##############
true
