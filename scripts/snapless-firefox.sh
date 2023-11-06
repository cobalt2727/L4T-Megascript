#!/bin/bash

case "$__os_id" in
Ubuntu)
  if [ $__formal_distro_name == Pop\!_OS ] || [ $__formal_distro_name == "Linux Mint" ]; then
    status_green "$__formal_distro_name already has Firefox available as a .deb. Skipping PPA addition."
    sudo apt install firefox -y || exit 1
    exit 0
  fi
  # starting on 22.04 the apt package for firefox is a snap so we need to add the ppa
  # 18.04 firefox is no longer being updated so we also want to use the ppa on it
  if printf '%s\n' "22.04" "$__os_release" | sort -CV || [[ "$__os_release" == "18.04" ]]; then
    ubuntu_ppa_installer "mozillateam/ppa"
    # also disable firefox snap apt package from Ubuntu
    echo 'Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1000

Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1' | sudo tee /etc/apt/preferences.d/firefox >/dev/null
  
  # allow unattented upgrades to upgrade from this ppa if unattented upgrades is enabled
  echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox >/dev/null
  fi
  # a standard apt install will not switch an already installed 1:1snap* package to a XXX firefox package since this would constitute a downgrade
  # the pin priorities added above will prevent Ubuntu repository firefox packages from even showing or installing in the future but we still need to do the initial downgrade from 1:1snap* to the ppa version of firefox
  sudo apt --allow-downgrades install firefox -y || exit 1
  ;;
*)
  # Add repository source to apt sources.list
  debian_ppa_installer "mozillateam/ppa" "bionic" "0AB215679C571D1C8325275B9BDB3D89CE49EC21" || exit 1
  # allow unattented upgrades to upgrade from this ppa if unattented upgrades is enabled
  echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:bionic";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox >/dev/null
  sudo apt install firefox -y || exit 1
  ;;
esac

if command -v snap; then
  sudo snap remove firefox
fi
true
