cd ~

case "$__os_codename" in
impish | focal | bionic)
  ubuntu_ppa_installer "okirby/qt6-backports" || error "PPA failed to install"
  echo "Installing dependencies..."
  case "$__os_codename" in
  focal | bionic)
    ubuntu_ppa_installer "ubuntu-toolchain-r/test" || error "PPA failed to install"
    sudo apt install gcc-11 g++-11 -y || error "Could not install dependencies"
    ;;
  *) ;;
  esac
  ;;
*)
  echo "Installing dependencies..."
  ;;
esac

sudo apt install -y gcc g++ cmake libsdl2-dev libxrandr-dev pkg-config qt6-base-dev qt6-base-private-dev qt6-base-dev-tools qt6-tools-dev libevdev-dev git libcurl4-gnutls-dev libgbm-dev libdrm-dev ninja-build qt6-l10n-tools qt6-tools-dev-tools || error "Could not install dependencies"

git clone https://github.com/stenzek/duckstation
cd duckstation
git pull || error "Could Not Pull Latest Source Code"
mkdir build
cd build
rm CMakeCache.txt
case "$__os_codename" in
focal | bionic)
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -GNinja -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11 .. || error "Cmake failed"
  ;;
*)
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -GNinja .. || error "Cmake failed"
  ;;
esac
# cmake -DCMAKE_BUILD_TYPE=Release ..
# ninja || error "Compilation failed"
# make -j$(nproc)
cmake --build . --parallel || error "Compilation failed"

echo "Done!"
echo "this script doesn't install Duckstation properly yet, please run it from ~/duckstation/build/bin/duckstation-qt"
