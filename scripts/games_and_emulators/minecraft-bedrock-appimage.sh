#!/bin/bash

clear -x

echo "Minecraft Bedrock script started!"
echo "Installing dependencies..."
sleep 1

cd ~
sudo apt install curl zenity kmod -y || error "Could not install dependencies"
rm -rf minecraft-bedrock
mkdir minecraft-bedrock
cd minecraft-bedrock
case "$dpkg_architecture" in
"arm64")
  type="arm64"
  type2="arm64"
  ;;
"armhf")
  type="armhf"
  type2="armhf"
  ;;
"i386")
  type="x86"
  type2="i386"
  ;;
"amd64")
  type="x86_64"
  type2="amd64"
  ;;
*)
  echo "Error: your userspace architecture ($dpkg_architecture) is not supporeted by Minecraft Bedrock Launcher and will fail to run"
  echo ""
  echo "Exiting the script"
  sleep 3
  exit 2
  ;;
esac

case "$__os_codename" in
bionic)
  ppa_name="deadsnakes/ppa" && ppa_installer
  sudo apt install -y python3.8
  yes | python3.6 -m pip uninstall lastversion
  python3.8 -m pip install --upgrade --force-reinstall pip filelock lastversion || error "Couldn't install dependencies"
  ;;
*)
  python3 -m pip install --upgrade pip lastversion || error "Couldn't install dependencies"
  ;;
esac

#the -v after arch detection fixes x86 devices locating both x86 and x86_64
lastversion --assets --filter $type-v download https://github.com/minecraft-linux/appimage-builder || error "Couldn't download AppImage!"
mv *.AppImage MC.AppImage
chmod +x *.AppImage
curl https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | grep "browser_download_url.*bionic_$type2" | cut -d : -f 2,3 | tr -d \" | wget -i -
sudo dpkg -i *bionic_*.deb
hash -r
ail-cli integrate MC.AppImage || error "Couldn't integrate AppImage"
cd ~
rm -rf minecraft-bedrock

echo "Install Dependencies..."
cd ~

#NOTE:  a long time ago we used to use ZorinOS PPAs and Debian repos to get newer version of libraries needed to make the launcher work on 18.04.
#       this was a bad idea, and we've since gotten things working without external software sources. so the below section wipes out those if they're found on an 18.04 setup
case "$__os_codename" in
bionic)
  if $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libc6) lt 2.28); then
    echo "Continuing the install"
  else
    echo "Force Downgrading libc and related packages"
    echo "You may need to recompile other programs such as Dolphin and BOX64 if you see this message"
    sudo rm -rf /etc/apt/sources.list.d/zorinos-ubuntu-stable-bionic.list*
    sudo rm -rf /etc/apt/preferences.d/zorinos*
    sudo rm -rf /etc/apt/sources.list.d/debian-stable.list*
    sudo rm -rf /etc/apt/preferences.d/freetype*

    sudo apt update
    sudo apt install libc-bin=2.27* libc-dev-bin=2.27* libc6=2.27* libc6-dbg=2.27* libc6-dev=2.27* libfreetype6=2.8* libfreetype6-dev=2.8* locales=2.27* -y --allow-downgrades || error "Could not install dependencies"
  fi
  ;;
esac

echo "Please Reboot before launching!"
sleep 5
echo "Going back to the menu..."
sleep 2
