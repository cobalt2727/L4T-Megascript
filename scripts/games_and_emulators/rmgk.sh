#!/bin/bash

clear -x

echo "RMG-K script successfully started!"
echo "Credits: https://github.com/Jay-Day/RMG-K"
sleep 3

function error {
  echo -e "\e[91m$1\e[39m"
  exit 1
}

case "$__os_id" in
Raspbian|Debian|Ubuntu)
  sudo apt update -y
  sudo apt install -y git build-essential cmake ninja-build pkg-config \
    libasound2-dev libpulse-dev libdbus-1-dev libudev-dev \
    libgl1-mesa-dev libglu1-mesa-dev libfreetype6-dev libpng-dev libusb-1.0-0-dev \
    libhidapi-dev libsamplerate0-dev libspeex-dev libspeexdsp-dev libminizip-dev \
    qt6-base-dev qt6-websockets-dev qt6-svg-dev libvulkan-dev nasm zlib1g-dev \
    \
    libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxinerama-dev \
    libxkbcommon-dev libxkbcommon-x11-dev \
    \
    || error "Could not install dependencies"
  ;;
*)
  echo -e "\e[91mUnsupported distro detected. This installer currently supports Debian/Ubuntu based systems only.\e[39m"
  exit 1
  ;;
esac

sleep 1

echo "Cloning or updating SDL3 source..."
cd ~ || error "Could not enter home directory"
if [ -d "$HOME/SDL" ]; then
  cd "$HOME/SDL"
  git pull || error "Could not pull latest SDL3 source. Verify your ~/SDL directory hasn't been modified."
else
  git clone --depth=1 https://github.com/libsdl-org/SDL.git "$HOME/SDL" || error "SDL3 clone failed"
  cd "$HOME/SDL"
fi

mkdir -p build
cd build
rm -rf CMakeCache.txt

cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DSDL_UNIX_CONSOLE_BUILD=OFF \
  -DSDL_X11=ON \
  -DSDL_WAYLAND=OFF \
  -G Ninja \
  || error "SDL3 configure failed"

echo "Building SDL3..."
cmake --build . --parallel "$(nproc)" || error "SDL3 build failed"

echo "Installing SDL3..."
sudo cmake --install . || error "SDL3 install failed"

sleep 1

echo "Cloning or updating RMG-K source..."
cd ~ || error "Could not enter home directory"
if [ -d "$HOME/RMG-K" ]; then
  cd "$HOME/RMG-K"
  git pull || error "Could Not Pull Latest RMG-K Source Code, verify your ~/RMG-K directory hasn't been modified."
else
  git clone --depth=1 https://github.com/Jay-Day/RMG-K.git "$HOME/RMG-K" || error "RMG-K clone failed"
  cd "$HOME/RMG-K"
fi

mkdir -p Build/Release
rm -rf ./Build/Release/CMakeCache.txt

echo "Building RMG-K..."
./Source/Script/Build.sh Release "$(nproc)" --no-bundle-dependencies --no-angrylion || error "RMG-K build failed"

if [ -x "$HOME/RMG-K/Bin/Release/RMG-K" ]; then
  echo "Installing RMG-K runtime..."
  sudo rm -rf /usr/local/share/rmgk
  sudo mkdir -p /usr/local/share/rmgk
  sudo cp -r "$HOME/RMG-K/Bin/Release"/* /usr/local/share/rmgk/ || error "Failed to copy RMG-K runtime files"
  sudo install -Dm755 /usr/local/share/rmgk/RMG-K /usr/local/bin/rmgk || error "Failed to install launcher"
  echo "RMG-K installed to /usr/local/share/rmgk and /usr/local/bin/rmgk"
  echo "Run with: rmgk"
else
  error "RMG-K binary not found after build. Build may have failed or output location changed."
fi

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
