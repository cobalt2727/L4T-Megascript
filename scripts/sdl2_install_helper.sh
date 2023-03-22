#!/bin/bash

#make sure this is updated
#note that this is an apt package in the Switchroot repository
package_available joycond && sudo apt install joycond -y

if ! package_installed "libsdl2-dev" || $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libsdl2-dev) lt 2.26.1); then
  if [[ "$dpkg_architecture" == "arm64" ]]; then
    mkdir -p /tmp/sdl2
    cd /tmp/sdl2 || error "Could not change directory"
    rm -rf ./*
    wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.26.1%2Bdfsg-1_arm64.deb --progress=bar:force:noscroll && wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-dev_2.26.1%2Bdfsg-1_arm64.deb --progress=bar:force:noscroll || error "Could not download files, make sure your internet is working"
    if [[ $(dpkg --print-foreign-architectures) == *"armhf"* ]]; then
      wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.26.1%2Bdfsg-1_armhf.deb --progress=bar:force:noscroll || error "Could not download files, make sure your internet is working"
    fi
    sudo apt install ./*.deb -y -f --allow-change-held-packages || error "SDL2 Packages Failed to install"
    rm -rf ./*
    cd
    echo "Successfully Installed Newest SDL2 Version"
  else
    echo "Sorry we don't host binaries on the megascript for non-arm64 architectures"
    echo "Skipping updated SDL2 install and installing normal sdl2 packages"
    sudo apt install libsdl2-2.0-0 libsdl2-dev -y
  fi
else
  echo "Already Installed Newest SDL2 Version"
fi

if [[ "$dpkg_architecture" == "arm64" ]] && [[ $(dpkg --print-foreign-architectures) == *"armhf"* ]] && (apt-cache policy libsdl2-2.0-0:armhf | grep -q 'Installed: (none)' || $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libsdl2-2.0-0:armhf) lt 2.26.1)); then
  mkdir -p /tmp/sdl2
  cd /tmp/sdl2 || error "Could not change directory"
  rm -rf ./*
  wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.26.1%2Bdfsg-1_armhf.deb --progress=bar:force:noscroll || error "Could not download files, make sure your internet is working"
  sudo apt install ./*.deb -y -f --allow-change-held-packages || error "SDL2 ARMhf Package Failed to install"
  rm -rf ./*
fi
