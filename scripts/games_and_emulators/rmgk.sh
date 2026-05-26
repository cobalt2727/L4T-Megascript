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
    libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxinerama-dev libxtst-dev \
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

if pkg-config --exists sdl3; then
  echo "SDL3 is already installed system-wide; skipping SDL3 build."
else
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
    -DSDL_X11=ON \
    -DSDL_WAYLAND=OFF \
    -G Ninja \
    || error "SDL3 configure failed"

  echo "Building SDL3..."
  cmake --build . --parallel "$(nproc)" || error "SDL3 build failed"

  echo "Installing SDL3..."
  sudo cmake --install . || error "SDL3 install failed"
fi

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

mkdir -p "$HOME/RMG-K/build"
rm -rf "$HOME/RMG-K/build/CMakeCache.txt"

echo "Configuring RMG-K..."
cmake -S "$HOME/RMG-K" -B "$HOME/RMG-K/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DPORTABLE_INSTALL=OFF \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -G Ninja \
  || error "RMG-K configure failed"

echo "Building RMG-K..."
cmake --build "$HOME/RMG-K/build" --parallel "$(nproc)" || error "RMG-K build failed"

echo "Installing RMG-K..."
sudo cmake --install "$HOME/RMG-K/build" --prefix="/usr" || error "RMG-K install failed"

if command -v rmgk >/dev/null 2>&1 || [ -x "/usr/bin/RMG-K" ]; then
  if [ -x "/usr/bin/RMG-K" ] && ! command -v rmgk >/dev/null 2>&1; then
    sudo install -Dm755 "/usr/bin/RMG-K" /usr/local/bin/rmgk || error "Failed to install launcher"
  fi
  echo "RMG-K installed successfully."
  echo "Run with: rmgk"
else
  error "RMG-K installation succeeded but no executable was found in PATH."
fi

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
