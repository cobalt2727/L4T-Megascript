cd ~

get_system

case "$__os_codename" in
impish | focal | bionic)
  ppa_name="okirby/qt6-backports" && ppa_installer
  echo "Installing dependencies..."
  ;;
*)
  echo "Installing dependencies..."
  ;;
esac


sudo apt install -y cmake libsdl2-dev libxrandr-dev pkg-config qt6-base-dev qt6-base-private-dev qt6-base-dev-tools qt6-tools-dev libevdev-dev git libcurl4-gnutls-dev libgbm-dev libdrm-dev ninja-build || error "Could not install dependencies"

git clone https://github.com/stenzek/duckstation
cd duckstation
git pull || error "Could Not Pull Latest Source Code"
mkdir build
cd build
rm CMakeCache.txt
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -GNinja .. || error "Cmake failed"
# cmake -DCMAKE_BUILD_TYPE=Release ..
# ninja || error "Compilation failed"
# make -j$(nproc)
cmake --build build-release --parallel || error "Compilation failed"

echo "Done!"
echo "this script doesn't install Duckstation properly yet, please run it from ~/duckstation/build/bin/duckstation-qt"
