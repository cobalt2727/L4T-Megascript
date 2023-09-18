#!/bin/bash

clear -x

echo "Minecraft Bedrock script started!"
echo "CREDITS: https://github.com/minecraft-linux/pkg"
sleep 1

cd ~

case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
  #the rewrite to use the repo cut off a few rare edge cases such as:
  # 32-bit architectures
  # Debian versions lower than 10
  # 18.04 users on a non-arm64 architecture
  #the monstrosity below this line catches these edge cases, all of which are still officially supported by the AppImage releases
  # if [[ [[ [ "$__os_id" == "Debian" ] || if [ "$__os_id" == "Raspbian" ] ]] && [[ "$__os_release" < 11 ]] ]] || if [[ [ "$__os_id" == "Ubuntu" ] && [[ ${"__os_release"%.*} < 18 ]] ]] || if [[ [ "$__os_codename" == "bionic" ] && [ "$dpkg_architecture" != "arm64" ] ]]|| if [[ [ "$dpkg_architecture" != "armhf" ] || if [ "$dpkg_architecture" == "i386" ] ]]; then
  #   echo "Error: Your OS $__os_id $__os_release is not supported by this script. You'll have to download AppImageLauncher and the AppImage for the game and run it yourself."
  #   echo "The script will open up the download page for you in about 20 seconds."
  #   echo "Your architecture is $architecture. Good luck."
  #   echo ""
  #   echo "Exiting the script"
  #   sleep 3

  #   notify-send "Remember, you're looking for the $architecture download."
  #   # xdg-open https://github.com/TheAssassin/AppImageLauncher/releases/latest
  #   # xdg-open https://github.com/minecraft-linux/appimage-builder/releases/latest
  #   # exit 2
  # fi

  curl -sS https://minecraft-linux.github.io/pkg/deb/pubkey.gpg | sudo tee -a /etc/apt/trusted.gpg.d/minecraft-linux-pkg.asc

  echo "deb [arch=$(dpkg --print-architecture)] https://minecraft-linux.github.io/pkg/deb $__os_codename main" | sudo tee /etc/apt/sources.list.d/minecraft-linux-pkg.list

  ###########the QT6 launcher is currently commented out - it currently just coredumps when trying to log in on 22.04
  # package_available mcpelauncher-ui-manifest-qt6
  # if [[ $? == "0" ]]; then
  #   sudo apt install -y mcpelauncher-manifest-qt6 mcpelauncher-ui-manifest-qt6 || error "Failed to install dependencies"
  #   #just for good measure
  #   sudo apt remove -y mcpelauncher-manifest mcpelauncher-ui-manifest
  # else
  sudo apt install -y mcpelauncher-manifest mcpelauncher-ui-manifest || error "Failed to install dependencies"
  # fi

  ;;

Fedora)
  echo -e "[minecraft-linux-pkg]\nname=minecraft-linux-pkg\nbaseurl=https://minecraft-linux.github.io/pkg/fedora-$__os_release\nenabled=1\ncountme=1\nrepo_gpgcheck=0\ntype=rpm\ngpgcheck=1\nskip_if_unavailable=False\ngpgkey=https://minecraft-linux.github.io/pkg/deb/pubkey.gpg" | sudo tee /etc/yum.repos.d/minecraft-linux-pkg.repo
  ;;
*)
  lsb_release
  echo "Error: Your OS is not supported by this script. You'll have to download AppImageLauncher and the AppImage for the game and run it yourself."
  echo "The script will open up the download page for you in about 20 seconds."
  echo "Your architecture is $architecture. Good luck."
  echo ""
  echo "Exiting the script"
  sleep 3

  notify-send "Remember, you're looking for the $architecture download."
  xdg-open https://github.com/TheAssassin/AppImageLauncher/latest
  xdg-open https://github.com/minecraft-linux/appimage-builder/releases
  error "Error: Are you on a supported OS?"
  ;;
esac

sleep 5
echo "Going back to the menu..."
sleep 2
