#!/bin/bash


# obtain the cpu info
get_system
# get the $DISTRIB_RELEASE and $DISTRIB_CODENAME by calling lsb_release
# check if upstream-release is available
if [ -f /etc/upstream-release/lsb-release ]; then
  echo "This is a Ubuntu Derivative, checking the upstream-release version info"
  DISTRIB_CODENAME=$(lsb_release -s -u -c)
  DISTRIB_RELEASE=$(lsb_release -s -u -r)
else
  DISTRIB_CODENAME=$(lsb_release -s -c)
  DISTRIB_RELEASE=$(lsb_release -s -r)
fi
case "$dpkg_architecture" in
  "arm64")
    case "$DISTRIB_CODENAME" in
      bionic) ppa_name="theofficialgman/cmake-bionic" && ppa_installer ;;
    esac
    ;;
  "amd64")
    echo "Installing Dependencies";;
  *)
    error_user "Error: your cpu architecture ($dpkg_architecture) is not supporeted by box64 and will fail to compile";;
esac

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

cd
# gcc 7 produces errors when compiling on arm/arm64 on both box86 and box64
# there is no available gcc-11 armhf cross compiler so the gcc-8 armhf cross compiler is used and it works fine
sudo apt install -y cmake git build-essential gcc-8-arm-linux-gnueabihf libsdl2-mixer-2.0-0:armhf libc6:armhf libx11-6:armhf libgdk-pixbuf2.0-0:armhf libgtk2.0-0:armhf libstdc++6:armhf libpng16-16:armhf libcal3d12v5:armhf libopenal1:armhf libcurl4:armhf osspd:armhf libjpeg62:armhf libudev1:armhf || error "Could install box86 dependencies"

git clone https://github.com/ptitSeb/box86.git
cd box86
git pull
if [[ $? -ne 0 ]]; then
  cd ~
  rm -rf box86
  git clone https://github.com/ptitSeb/box86.git || error "Could Not Pull Latest Source Code"
  cd box86
fi
mkdir build
cd build
cmake .. -DCMAKE_ASM_FLAGS="-marm -pipe -march=armv8-a+crc -mcpu=cortex-a57 -mfpu=neon-fp-armv8 -mfloat-abi=hard" -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc-8 -DARM_DYNAREC=ON
make -j$(nproc) || error "Compilation failed"
sudo make install || error "Make install failed"
sudo systemctl restart systemd-binfmt
