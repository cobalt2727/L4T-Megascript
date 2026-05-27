#!/bin/bash

clear -x

echo "RMG-K script successfully started!"
echo "Credits: https://github.com/Jay-Day/RMG-K"
sleep 3

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
  error_user "Unsupported distro detected. This installer currently supports Debian/Ubuntu based systems only."
  ;;
esac

sleep 1

if pkg-config --exists sdl3; then
  echo "SDL3 is already installed system-wide; skipping SDL3 build."
else
  echo "Cloning or updating SDL3 source..."
  cd ~ || error_user "Could not enter home directory"
  if [ -d "$HOME/SDL" ]; then
    cd "$HOME/SDL"
    git pull || error_user "Could not pull latest SDL3 source. Verify your ~/SDL directory hasn't been modified."
  else
    git clone --depth=1 https://github.com/libsdl-org/SDL.git "$HOME/SDL" || error_user "SDL3 clone failed"
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
    || error_user "SDL3 configure failed"

  echo "Building SDL3..."
  cmake --build . --parallel "$(nproc)" || error_user "SDL3 build failed"

  echo "Installing SDL3..."
  sudo cmake --install . || error_user "SDL3 install failed"
fi

sleep 1

echo "Cloning or updating RMG-K source..."
cd ~ || error_user "Could not enter home directory"
if [ -d "$HOME/RMG-K" ]; then
  cd "$HOME/RMG-K"
  git pull || error_user "Could Not Pull Latest RMG-K Source Code, verify your ~/RMG-K directory hasn't been modified."
else
  git clone --depth=1 https://github.com/Jay-Day/RMG-K.git "$HOME/RMG-K" || error_user "RMG-K clone failed"
  cd "$HOME/RMG-K"
fi

mkdir -p "$HOME/RMG-K/build"
rm -rf "$HOME/RMG-K/build/CMakeCache.txt"

echo "Configuring RMG-K..."
cmake -S "$HOME/RMG-K" -B "$HOME/RMG-K/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DPORTABLE_INSTALL=OFF \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_INSTALL_LIBDIR="lib/aarch64-linux-gnu" \
  -G Ninja \
  || error_user "RMG-K configure failed"

echo "Building RMG-K..."
cmake --build "$HOME/RMG-K/build" --parallel "$(nproc)" || error_user "RMG-K build failed"

echo "Installing RMG-K..."
sudo cmake --install "$HOME/RMG-K/build" || error_user "RMG-K install failed"

if command -v rmgk >/dev/null 2>&1 || command -v RMG-K >/dev/null 2>&1; then
  echo "RMG-K installed successfully."
  echo "Run via terminal with [ rmgk ] or [ RMG-K ] or find it in your application menu."
elif [ -d "/usr/lib/aarch64-linux-gnu/RMG" ]; then
  echo "RMG-K installed successfully."
  echo "Run via terminal with [ rmgk ] or [ RMG-K ] or find it in your application menu."
else
  error_user "RMG-K installation succeeded but no executable or library directory was found."
fi

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
