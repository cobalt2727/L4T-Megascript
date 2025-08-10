#!/bin/bash

sudo chown runner:docker /home/runner
# print user info
echo $USER $USERNAME $(id) $(whoami)
sudo bash -c 'echo $USER $USERNAME $(id) $(whoami)'
echo "GITHUB_JOB: $GITHUB_JOB"

# set DIRECTORY variable
DIRECTORY="$(pwd)"

# print date
date

# set debian frontend as non-interactive in CI
export DEBIAN_FRONTEND=noninteractive

#necessary functions
error() { #red text and exit 1
  echo -e "\e[91m$1\e[0m" 1>&2
  exit 1
}

warning() { #yellow text
  echo -e "\e[93m\e[5m◢◣\e[25m WARNING: $1\e[0m" 1>&2
}

status() { #cyan text to indicate what is happening
  
  #detect if a flag was passed, and if so, pass it on to the echo command
  if [[ "$1" == '-'* ]] && [ ! -z "$2" ];then
    echo -e $1 "\e[96m$2\e[0m" 1>&2
  else
    echo -e "\e[96m$1\e[0m" 1>&2
  fi
}

status_green() { #announce the success of a major action
  echo -e "\e[92m$1\e[0m" 1>&2
}


if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]]; then
  # fix nvidia jank
  # update sources list for t210
  sudo sed -i "s/<SOC>/t210/" /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
fi

if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]] || [[ "$GITHUB_JOB" == "l4t-jammy-64bit" ]] || [[ "$GITHUB_JOB" == "l4t-noble-64bit" ]]; then
  # add ld conf files (normally handled by service on first launch)
  echo "/usr/lib/aarch64-linux-gnu/tegra-egl" | sudo tee /etc/ld.so.conf.d/aarch64-linux-gnu_EGL.conf
  echo "/usr/lib/aarch64-linux-gnu/tegra" | sudo tee /etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf
  # note that we are in a chroot to skip bootfile configuration
  sudo mkdir -p /opt/switchroot
  sudo touch /opt/switchroot/image_prep
fi

if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]] || [[ "$GITHUB_JOB" == "l4t-jammy-64bit" ]]; then
  # skip joycond postinst
  # fixed in newer releases
  sudo rm /var/lib/dpkg/info/joycond.postinst -f
  sudo dpkg --configure joycond
fi

if [[ "$GITHUB_JOB" == "l4t-focal-64bit" ]]; then
  # fix nvidia jank
  # update sources list for t194
  sudo sed -i "s/<SOC>/t194/" /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
fi

if [[ "$GITHUB_JOB" == "jammy-64bit" ]] || [[ "$GITHUB_JOB" == "lunar-64bit" ]]; then
  # remove packages that won't work in the chroot
  sudo apt remove -y linux-image-*-raspi linux-modules-*-raspi linux-image-raspi linux-raspi linux-headers-raspi
fi

if [[ "$GITHUB_JOB" == "noble-64bit" ]]; then
  # workaround upstream bug in default image https://bugs.launchpad.net/ubuntu-cdimage/+bug/2065213
  sudo wget -O /etc/apt/sources.list.d/ubuntu.sources https://raw.githubusercontent.com/theofficialgman/l4t-image-buildscripts/master/files/overwrite-files/noble/gnome/ubuntu.sources
fi

if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]]; then
  # update certificate chain
  sudo apt update
  sudo apt install -y ca-certificates
fi

if [[ "$GITHUB_JOB" == "l4t-bionic-64bit" ]]; then
  # update binutils so that scripts with native flags don't fail, similar to what we had to do with our Oracle VMs way back in 2022
  # https://discord.com/channels/719014537277210704/880675368875466792/1024753718102589513
  # not every program will break without this, but some do
  # case in point, see https://github.com/cobalt2727/L4T-Megascript/actions/runs/16857476242/job/47752811240
  sudo apt install -y build-essential bison texinfo wget
  cd /tmp
  rm binutils*.tar.gz
  # targeting 2.42 to match Ubuntu 24.04
  wget https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz -O binutils-modern.tar.gz
  # https://news.ycombinator.com/item?id=29334724
  tar -xzvf binutils-modern.tar.gz
  cd binutils*
  make distclean || true
  ./configure && make -j$(nproc) && sudo make install && cd /tmp && rm -rf binutils*
fi

if grep -q debian /etc/os-release; then
  sudo apt update
  sudo apt-get dist-upgrade -y -o Dpkg::Options::="--force-confnew"
  sudo apt-get install bash dialog gnutls-bin curl yad zenity lsb-release software-properties-common -y
  hash -r
  sudo apt update
  sudo apt dist-upgrade -y -o Dpkg::Options::="--force-confnew"
  hash -r
elif grep -q fedora /etc/os-release || grep -q nobara /etc/os-release; then
  sudo dnf --refresh --best --allowerasing -y upgrade
  sudo dnf install bash dialog gnutls curl yad zenity lsb_release libxkbcommon-devel -y
  hash -r
fi

#determine what type of input we received
if [ -z "$name" ]; then
  error "No Helper Script name format passed to script. Exiting now."
fi

status "Testing: $name"

# create standard directories
mkdir -p  $HOME/.local/share/applications $HOME/.local/bin
sudo mkdir -p /usr/local/bin /usr/local/share/applications

#load functions from github source
unset functions_downloaded
source <(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/functions.sh)
[[ ! -z ${functions_downloaded+z} ]] && status "Functions Loaded" || error "Oh no! Something happened to your internet connection! Exiting the Megascript - please fix your internet and try again!"

# print release info to terminal
status "__os_id: $__os_id"
status "__os_desc: $__os_desc"
status "__os_release: $__os_release"
status "__os_codename: $__os_codename"

# run runonce entries
# this replaces the need for an initial setup script
status "Runing Initial Setup Runonce entries"
if [ -v $repository_username ] || [ $repository_username == cobalt2727 ]; then
  export repository_username=cobalt2727
else
  echo "Developer Mode Enabled! Repository = $repository_username"
fi
if [ -v $repository_branch ] || [ $repository_branch == master ]; then
  export repository_branch=master
else
  echo "Developer Mode Enabled! Branch = $repository_branch"
fi
bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/runonce-entries.sh)"

bash <( curl https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/helper.sh ) "$name"
