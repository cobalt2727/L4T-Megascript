#!/bin/bash

echo "Metaforce script started!"

#removing previous LLVM 13 installs
case "$__os_codename" in
bionic)
  if package_installed "llvm-13"; then
    sudo apt remove llvm-13 -y
  fi
  if package_installed "clang-13"; then
    sudo apt remove clang-13 -y
  fi
  if package_installed "clang++-13"; then
    sudo apt remove clang++-13 -y
  fi
  if package_installed "libclang13-dev"; then
    sudo apt remove libclang13-dev -y
  fi
  if package_installed "libmlir-13-dev"; then
    sudo apt remove libmlir-13-dev -y
  fi
  ;;
esac

echo "Installing dependencies..."
case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
  case "$__os_codename" in
  bionic)
    echo "18.04 detected - let's get you a newer version of Clang/LLVM/QT..."
    curl https://apt.llvm.org/llvm.sh | sudo bash -s "14" || error "apt.llvm.org installer failed!"
    ppa_name="deadsnakes/ppa" && ppa_installer
    if ! [[ "$dpkg_architecture" =~ ^("arm64"|"armhf")$ ]]; then
      ppa_name="beineri/opt-qt-5.15.2-bionic"
    else
      ppa_name="theofficialgman/opt-qt-5.15.2-bionic-arm"
    fi
    ppa_installer

    sudo apt install -y build-essential curl git ninja-build clang lld-14 zlib1g-dev libcurl4-openssl-dev \
      libglu1-mesa-dev libdbus-1-dev libxi-dev libxrandr-dev libasound2-dev libpulse-dev \
      libudev-dev libpng-dev libncurses5-dev cmake libx11-xcb-dev python3.8 libpython3.8-dev python3.8-dev \
      qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libclang-dev qt5-default qt515base \
      clang-14 clang++-14 libclang-14-dev libmlir-14-dev libstdc++-11-dev libvulkan1 libvulkan-dev libjack-jackd2-dev libxinerama-dev libxcursor-dev || error "Failed to install dependencies!" #libfmt-dev
    ;;
  *)
    case "$__os_codename" in
    bionic)
      ppa_name="ubuntu-toolchain-r/test" && ppa_installer
      ;;
    jammy)
      sudo apt install -y gcc-12 g++-12 || error "Failed to install dependencies!"
      ;;
    *)
      sudo apt install -y clang clang-tools clang-tidy clangd || error "Failed to install dependencies!"
      # move more clang-specific deps out of the below apt install chunk and into the above line
      # is mlir clang-specific?
      ;;
    esac

    sudo apt install -y build-essential curl git ninja-build lld zlib1g-dev libcurl4-openssl-dev \
      libglu1-mesa-dev libdbus-1-dev libxi-dev libxrandr-dev libasound2-dev libpulse-dev libudev-dev \
      libpng-dev libncurses5-dev cmake libx11-xcb-dev python3 python-is-python3 qtbase5-dev qtchooser qt5-qmake \
      qtbase5-dev-tools libclang-dev libjack-jackd2-dev libxinerama-dev libxcursor-dev || error "Failed to install dependencies!" #libfmt-dev
    LLVM_VERSION=$(echo $(dpkg -s llvm | grep -i version) | sed 's/.*\://' | awk -F\. '{print $1}')
    package_available mlir-$LLVM_VERSION-tools
    if [[ $? == "0" ]]; then
      sudo apt install -y mlir-$LLVM_VERSION-tools || error "Failed to install dependencies" # needed for 22.10+
    fi
    package_available libmlir-$LLVM_VERSION-dev
    if [[ $? == "0" ]]; then
      sudo apt install -y libmlir-$LLVM_VERSION-dev || error "Failed to install dependencies" # needed for 22.10+
    fi

    sudo apt install -y --no-install-recommends libvulkan1 libvulkan-dev || error "Failed to install dependencies!"

    package_available libstdc++-12-dev
    if [[ $? == "0" ]]; then
      sudo apt install -y libstdc++-12-dev || error "Failed to install dependencies"
    else
      sudo apt install -y libstdc++-11-dev || error "Failed to install dependencies"
    fi
    ;;
  esac
  sudo apt install udev libudev1 libudev-dev -y
  ;;
Fedora)
  # this is so much nicer.
  sudo dnf install -y systemd-devel cmake vulkan-headers ninja-build clang-devel llvm-devel libpng-devel || error "Failed to install dependencies"
  sudo dnf groupinstall "Development Tools" "Development Libraries" -y || error "Failed to install dependencies"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.dolphin-emu.org/index.php?title=Building_Dolphin_on_Linux if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo touch /etc/udev/rules.d/51-gcadapter.rules
echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules >/dev/null
sudo udevadm control --reload-rules
sudo systemctl restart udev.service

#package_available qt6-tools-dev
#if [[ $? == "0" ]]; then # this 22.04+ dep is really only needed for the submodule https://github.com/AxioDL/amuse/ - it can be safely ignored (until we get errors about it)
#   sudo apt install -y qt6-tools-dev libqt6svg6-dev libqt6core5compat6-dev qt6-tools-dev-tools qt6-declarative-dev qt6-l10n-tools || error "Failed to install QT6 development libraries!"
#fi

cd ~
git clone --recursive https://github.com/AxioDL/metaforce.git -j$(nproc)
cd metaforce
git pull -j$(nproc)
git submodule update --recursive --init
cd ..
mkdir metaforce-build
cd metaforce-build

#cmake
case "$__os_codename" in
bionic)
  if package_installed "llvm-7"; then
    sudo apt remove llvm-7 clang-7 -y
  fi
  if package_installed "llvm-13"; then
    sudo apt remove llvm-13 clang-13 clang++-13 lld-13 -y
  fi
  CC=clang-14 CXX=clang++-14 cmake -DCMAKE_BUILD_TYPE=Release -DMETAFORCE_VECTOR_ISA=native -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE -G Ninja ../metaforce || error "Cmake failed!"
  CC=clang-14 CXX=clang++-14 ninja || error "Build failed!"
  ;;
jammy)
  CC=gcc-12 CXX=g++-12 cmake -DCMAKE_BUILD_TYPE=Release -DMETAFORCE_VECTOR_ISA=native -G Ninja ../metaforce || error "Cmake failed!"
  CC=gcc-12 CXX=g++-12 ninja || error "Build failed!"
  ;;
*)
  CC=clang CXX=clang++ cmake -DCMAKE_BUILD_TYPE=Release -DMETAFORCE_VECTOR_ISA=native -G Ninja ../metaforce || error "Cmake failed!"
  CC=clang CXX=clang++ ninja || error "Build failed!"
  ;;
esac

cd ~

#install metaforce and all associated programs
sudo cp metaforce-build/Binaries/* /usr/local/bin/
#install icon for .desktop file
sudo cp -r metaforce/Runtime/platforms/freedesktop/*/ /usr/local/share/icons/hicolor/
#install .desktop file itself
sudo cp metaforce/Runtime/platforms/freedesktop/metaforce.desktop /usr/local/share/applications/metaforce.desktop

#remove legacy files from older builds
#sudo rm /usr/local/bin/hecl /usr/local/bin/metaforce-gui /usr/local/bin/mkqticon /usr/local/bin/mkwmicon /usr/local/bin/visigen || true

#maybe prompt user to delete build folder(s) considering how big they are?
