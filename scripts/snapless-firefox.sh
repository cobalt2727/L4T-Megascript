#!/bin/bash

case "$__os_codename" in
bionic | focal)
  error_user "This script is irrelevant on 20.04 and below - skipping installation..."
  ;;
*)
  if [ $__formal_distro_name == Pop\!_OS ] | [ $__formal_distro_name == "Linux Mint" ]; then
    status_green "$__formal_distro_name already has Firefox available as a .deb - there is nothing for this script to do..."
    sleep 5
  else
    sudo su -c "echo 'Package: *' > /etc/apt/preferences.d/firefox"
    sudo su -c "echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/firefox"
    sudo su -c "echo 'Pin-Priority: 700' >> /etc/apt/preferences.d/firefox"

    if command -v snap; then
      sudo snap remove firefox
    fi

    ppa_name="mozillateam/ppa" && ppa_installer

    sudo apt install firefox -y
    sudo apt --fix-broken install -y
  fi
  ;;
esac
