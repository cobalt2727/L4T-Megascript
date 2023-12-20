#!/bin/bash

case "$__os_codename" in
bionic)
  error_user "This script is irrelevant on 18.04 - skipping installation..."
  ;;
*)
  if [ $__formal_distro_name == Pop\!_OS ] || [ $__formal_distro_name == "Linux Mint" ]; then
    status_green "$__formal_distro_name already has Chromium available as a .deb - there is nothing for this script to do..."
    sleep 5
  else
    sudo su -c "echo 'Package: *' > /etc/apt/preferences.d/chromium"
    sudo su -c "echo 'Pin: release o=LP-PPA-saiarcot895-chromium-beta' >> /etc/apt/preferences.d/chromium"
    sudo su -c "echo 'Pin-Priority: 700' >> /etc/apt/preferences.d/chromium"

    if command -v snap; then
      sudo snap remove chromium
    fi

    ubuntu_ppa_installer "saiarcot895/chromium-beta" || error "PPA failed to install"

    sudo apt install --reinstall chromium-browser -y
    sudo apt --fix-broken install -y

    if [[ $jetson_model ]]; then
      # browser crashes without --no-sandbox on newer ubuntu on jetson
      # add a customization file with necessary flags
      echo 'CHROMIUM_FLAGS="--no-sandbox --use-vulkan --enable-features=Vulkan"' | sudo tee /etc/chromium-browser/customizations/l4t-customizations
    fi
  fi
  ;;
esac
