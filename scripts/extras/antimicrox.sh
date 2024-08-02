#!/bin/bash

if command -v apt >/dev/null; then

  case "$__os_codename" in
  bionic)
    if ! [[ "$dpkg_architecture" =~ ^("arm64"|"armhf")$ ]]; then
      ubuntu_ppa_installer "beineri/opt-qt-5.15.2-bionic"
    else
      ubuntu_ppa_installer "theofficialgman/opt-qt-5.15.2-bionic-arm"
    fi

    sudo apt install -y git build-essential cmake extra-cmake-modules \
      qt515base libsdl2-dev libxi-dev libxtst-dev \
      libx11-dev itstool gettext python3-libxml2 || error "Could not install dependencies"
    ;;
  *)
    sudo apt install -y git build-essential cmake extra-cmake-modules \
      qttools5-dev qttools5-dev-tools libsdl2-dev \
      libxi-dev libxtst-dev libx11-dev itstool gettext python3-libxml2 || error "Could not install dependencies"
    ;;
  esac

  hash -r

  # Cloning
  cd /tmp || error "No /tmp directory"
  rm -rf antimicrox
  git clone https://github.com/AntiMicroX/antimicrox.git --depth=1
  cd antimicrox
  mkdir build && cd build

  # Building
  case "$__os_codename" in
  bionic)
    cmake .. -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE || error "Cmake failed"
    ;;
  *)
    cmake .. || error "Cmake failed"
    ;;
  esac

  make -j$(nproc) || error "Compilation failed"

  # Installing
  sudo make install || error "Make install failed"

  # Removing source
  cd ~
  rm -rf /tmp/antimicrox

elif command -v dnf >/dev/null; then
  sudo dnf install antimicrox -y || error "Failed to install AntiMicroX!"
else
  error "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

echo "Done!"
sleep 1
