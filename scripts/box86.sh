#!/bin/bash

#add armhf architecture (multiarch)
if [[ $(dpkg --print-foreign-architectures) == *"armhf"* ]]; then
  echo "armhf arcitecture already added..."
else
  sudo dpkg --add-architecture armhf
  # perform an apt update to check for errors
  # if apt update errors, assume that adding the foreign arch caused it and remove it
  sudo apt update
  if [[ "$?" != 0 ]]; then
    sudo dpkg --remove-architecture armhf
    error "armhf architecture caused apt to error so it has been removed!"
  fi
fi

# allow loading of MESA libraries (still uses ARM64 proprietary nvidia drivers)
sudo sed -i "s/\"library_path\" : .*/\"library_path\" : \"libEGL_mesa.so.0\"/g" "/usr/share/glvnd/egl_vendor.d/50_mesa.json"
sudo sed -i 's:^DISABLE_MESA_EGL="1":DISABLE_MESA_EGL="0":' /etc/systemd/nv.sh

case "$dpkg_architecture" in
"arm64")
  sudo wget https://github.com/Pi-Apps-Coders/box86-debs/raw/master/box86.list -O /etc/apt/sources.list.d/box86.list
  if [ $? != 0 ];then
    sudo rm -f /etc/apt/sources.list.d/box86.list
    error "Failed to add box86.list file!"
  fi

  sudo rm -f /usr/share/keyrings/box86-debs-archive-keyring.gpg /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg
  sudo mkdir -p /etc/apt/trusted.gpg.d
  wget -qO- https://Pi-Apps-Coders.github.io/box86-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg > /dev/null

  if [ $? != 0 ];then
    sudo rm -f /etc/apt/sources.list.d/box86.list
    error "Failed to add KEY.gpg to APT keyring!"
  fi

  sudo apt update

  # remove deprecated package name
  if package_installed box86 ; then
    sudo apt purge -y --allow-change-held-packages box86
  fi

  sudo apt install -y libsdl2-image-2.0-0:armhf libsdl2-net-2.0-0:armhf libsdl2-2.0-0:armhf libc6:armhf libx11-6:armhf libgdk-pixbuf2.0-0:armhf libgtk2.0-0:armhf libstdc++6:armhf libpng16-16:armhf libcal3d12v5:armhf libopenal1:armhf libcurl4:armhf osspd:armhf libjpeg62:armhf libudev1:armhf || error "Could install box86 dependencies"

  if [[ "$SOC_ID" == "tegra-x1" ]] || [[ "$SOC_ID" == "tegra-x2" ]]; then
    sudo apt install -y box86-tegrax1:armhf || exit 1
  elif [[ "$SOC_ID" == "rk3399" ]]; then
    sudo apt install -y box86-rk3399:armhf || exit 1
  elif [[ "$SOC_ID" == "bcm2711" ]]; then
    sudo apt install -y box86-rpi4arm64:armhf || exit 1
  elif [[ "$SOC_ID" == "bcm2837" ]]; then
    sudo apt install -y box86-rpi3arm64:armhf || exit 1
  elif cat /proc/cpuinfo | grep -q aes; then
    warning "There is no box86 pre-build for your device $SOC_ID $model"
    warning "Installing the generic arm box86 build as a fallback (crypto extensions enabled)"
    sudo apt install -y box86-generic-arm:armhf || exit 1
  else
    warning "There is no box86 pre-build for your device $SOC_ID $model"
    warning "Installing the RPI4 tuned box86 build as a fallback (no crypto extensions enabled)"
    sudo apt install -y box86-rpi4arm64:armhf || exit 1
  fi
  ;;
"amd64")
  cd ~
  # gcc 7 produces errors when compiling on arm/arm64 on both box86 and box86
  # there is no available gcc-11 armhf cross compiler so the gcc-8 armhf cross compiler is used and it works fine
  sudo apt install -y cmake git build-essential gcc-8-arm-linux-gnueabihf libsdl2-image-2.0-0:armhf libsdl2-net-2.0-0:armhf libsdl2-2.0-0:armhf libc6:armhf libx11-6:armhf libgdk-pixbuf2.0-0:armhf libgtk2.0-0:armhf libstdc++6:armhf libpng16-16:armhf libcal3d12v5:armhf libopenal1:armhf libcurl4:armhf osspd:armhf libjpeg62:armhf libudev1:armhf || error "Could install box86 dependencies"

  rm -rf box86
  git clone --depth=1 https://github.com/ptitSeb/box86.git
  cd box86
  mkdir build
  cd build
  cmake .. -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc-8 -DARM_DYNAREC=ON
  make -j$(nproc) || error "Compilation failed"
  sudo make install || error "Make install failed"
  sudo systemctl restart systemd-binfmt

  rm -rf rm -rf ~/box86
  ;;
*)
  error_user "Error: your cpu architecture ($dpkg_architecture) is not supported by box86 and will fail to compile"
  ;;
esac
