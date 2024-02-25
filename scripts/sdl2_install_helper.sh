#!/bin/bash

#make sure this is updated
#note that this is an apt package in the Switchroot repository
package_available joycond && sudo apt install joycond -y

if [[ "$dpkg_architecture" == "arm64" ]]; then
  if apt-cache policy libsdl2-dev:arm64 | grep -q 'Installed: (none)' || $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libsdl2-dev) lt 2.26.1+dfsg-1); then
    # libsdl2-dev:arm64 not currently installed or libsdl2-dev:arm64 installed and less than required version
    if $(dpkg --compare-versions $(package_latest_version libsdl2-dev:arm64) ge 2.26.1+dfsg-1); then
      # candidate version is greater than or equal to 2.26.1+dfsg-1 so install directly from apt
      if [[ $(dpkg --print-foreign-architectures) == *"armhf"* ]]; then
        if $(dpkg --compare-versions $(package_latest_version libsdl2-2.0-0:armhf) ge 2.26.1+dfsg-1); then
          # candidate version is greater than or equal to 2.26.1+dfsg-1 so install directly from apt
          sudo apt install libsdl2-2.0-0:arm64 libsdl2-dev:arm64 libsdl2-2.0-0:armhf -y || error "SDL2 ARM64 and ARMhf Packages Failed to install"
        else
          mkdir -p /tmp/sdl2
          cd /tmp/sdl2 || error "Could not change directory"
          rm -rf /tmp/sdl2/*
          wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.26.1%2Bdfsg-1_armhf.deb --progress=bar:force:noscroll || error "Could not download files, make sure your internet is working"
          sudo apt install ./*.deb libsdl2-2.0-0:arm64 libsdl2-dev:arm64 -y -f --allow-change-held-packages || error "SDL2 ARM64 and ARMhf Packages Failed to install"
          rm -rf /tmp/sdl2/*
        fi
      else
        sudo apt install libsdl2-2.0-0:arm64 libsdl2-dev:arm64 -y || error "SDL2 ARM64 Package Failed to install"
      fi
    else
      mkdir -p /tmp/sdl2
      cd /tmp/sdl2 || error "Could not change directory"
      rm -rf /tmp/sdl2/*
      wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.26.1%2Bdfsg-1_arm64.deb --progress=bar:force:noscroll && wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-dev_2.26.1%2Bdfsg-1_arm64.deb --progress=bar:force:noscroll || error "Could not download files, make sure your internet is working"
      if [[ $(dpkg --print-foreign-architectures) == *"armhf"* ]]; then
        wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.26.1%2Bdfsg-1_armhf.deb --progress=bar:force:noscroll || error "Could not download files, make sure your internet is working"
        sudo apt install ./*.deb -y -f --allow-change-held-packages || error "SDL2 ARM64 and ARMhf Packages Failed to install"
      else
        sudo apt install ./*.deb -y -f --allow-change-held-packages || error "SDL2 ARM64 Package Failed to install"
      fi
      rm -rf /tmp/sdl2/*
    fi
  else
    echo "Already Installed Newest SDL2 ARM64 Version"
  fi
fi

if [[ "$dpkg_architecture" == "arm64" ]] && [[ $(dpkg --print-foreign-architectures) == *"armhf"* ]]; then
  if apt-cache policy libsdl2-2.0-0:armhf | grep -q 'Installed: (none)' || $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libsdl2-2.0-0:armhf) lt 2.26.1+dfsg-1); then
    # libsdl2-2.0-0:armhf not currently installed or libsdl2-2.0-0:armhf installed and less than required version
    if $(dpkg --compare-versions $(package_latest_version libsdl2-2.0-0:armhf) ge 2.26.1+dfsg-1); then
      # candidate version is greater than or equal to 2.26.1+dfsg-1 so install directly from apt
      sudo apt install libsdl2-2.0-0:armhf -y || error "SDL2 ARMhf Package Failed to install"
    else
      mkdir -p /tmp/sdl2
      cd /tmp/sdl2 || error "Could not change directory"
      rm -rf /tmp/sdl2/*
      wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.26.1%2Bdfsg-1_armhf.deb --progress=bar:force:noscroll || error "Could not download files, make sure your internet is working"
      sudo apt install ./*.deb -y -f --allow-change-held-packages || error "SDL2 ARMhf Package Failed to install"
      rm -rf /tmp/sdl2/*
    fi
  else
    echo "Already Installed Newest SDL2 ARMhf Version"
  fi
fi

if [[ "$dpkg_architecture" == "armhf" ]]; then
  if apt-cache policy libsdl2-dev:armhf | grep -q 'Installed: (none)' || $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libsdl2-dev:armhf) lt 2.26.1+dfsg-1); then
    # libsdl2-dev:armhf not currently installed or libsdl2-dev:armhf installed and less than required version
    if $(dpkg --compare-versions $(package_latest_version libsdl2-2.0-0:armhf) ge 2.26.1+dfsg-1); then
      # candidate version is greater than or equal to 2.26.1+dfsg-1 so install directly from apt
      sudo apt install libsdl2-2.0-0:armhf libsdl2-dev:armhf -y || error "SDL2 ARMhf Package Failed to install"
    else
      mkdir -p /tmp/sdl2
      cd /tmp/sdl2 || error "Could not change directory"
      rm -rf /tmp/sdl2/*
      wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-2.0-0_2.26.1%2Bdfsg-1_armhf.deb --progress=bar:force:noscroll && wget https://github.com/$repository_username/L4T-Megascript/raw/$repository_branch/assets/SDL2/libsdl2-dev_2.26.1%2Bdfsg-1_armhf.deb --progress=bar:force:noscroll || error "Could not download files, make sure your internet is working"
      sudo apt install ./*.deb -y -f --allow-change-held-packages || error "SDL2 ARMhf Package Failed to install"
      rm -rf /tmp/sdl2/*
    fi
  else
    echo "Already Installed Newest SDL2 ARMhf Version"
  fi
fi
