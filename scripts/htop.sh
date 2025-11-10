#!/bin/bash

if command -v apt >/dev/null; then

  #remove htop package first
  if package_installed htop; then
    echo "Removing htop package first..."
    sudo apt purge -y --autoremove htop
  fi

  sudo apt install build-essential libncursesw*-dev dh-autoreconf -y || error "Could not install packages"
  cd /tmp || error "Could not move to /tmp folder"
  rm -rf ./htop
  git clone https://github.com/htop-dev/htop.git
  cd htop
  git fetch --tags
  latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
  git checkout $latestTag
  ./autogen.sh && ./configure && make -j$(nproc)
  sudo make install || error "Make install failed"
  rm -rf /tmp/htop

elif command -v dnf >/dev/null; then
  sudo dnf install -y --refresh htop || error "Failed to install htop!"
else
  error "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

echo "Done!"
sleep 1
