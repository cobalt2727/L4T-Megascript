cd ~

case "$__os_codename" in
impish | focal | bionic)
  ppa_name="okirby/qt6-backports" && ppa_installer
  echo "Installing dependencies..."
  case "$__os_codename" in
  focal | bionic)
    ppa_name="ubuntu-toolchain-r/test" && ppa_installer
    sudo apt install gcc-11 g++-11 -y || error "Could not install dependencies"
    ;;
  *) ;;
  esac
  ;;
*)
  echo "Installing dependencies..."
  ;;
esac

sudo apt install -y cmake libsdl2-dev libxrandr-dev pkg-config qt6-base-dev qt6-base-private-dev qt6-base-dev-tools qt6-tools-dev libevdev-dev git libcurl4-gnutls-dev libgbm-dev libdrm-dev ninja-build qt6-l10n-tools qt6-tools-dev-tools wget unzip || error "Could not install dependencies"

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

cd ..
#install duckstation itself
sudo cp -r duckstation/build/bin/ /usr/local/

#download icons and desktop file
mkdir duckstationicons
cd duckstationicons
wget https://archive.org/download/icons_202305/icons.zip
unzip icons.zip
cd ..

#install icons for .desktop files
sudo install -m 644 -D duckstationicons/svg.svg /usr/local/share/icons/hicolor/scalable/apps/duckstation-qt.svg

sudo install -m 644 -D duckstationicons/128.svg /usr/local/share/icons/hicolor/128x128/apps/duckstation-qt.png #128
sudo install -m 644 -D duckstationicons/16.png /usr/local/share/icons/hicolor/16x16/apps/duckstation-qt.png    #16
sudo install -m 644 -D duckstationicons/24.png /usr/local/share/icons/hicolor/24x24/apps/duckstation-qt.png    #24
sudo install -m 644 -D duckstationicons/256.png /usr/local/share/icons/hicolor/256x256/apps/duckstation-qt.png #256
sudo install -m 644 -D duckstationicons/32.png /usr/local/share/icons/hicolor/32x32/apps/duckstation-qt.png    #32
sudo install -m 644 -D duckstationicons/48.png /usr/local/share/icons/hicolor/48x48/apps/duckstation-qt.png    #48
sudo install -m 644 -D duckstationicons/512.png /usr/local/share/icons/hicolor/512x512/apps/duckstation-qt.png #512
sudo install -m 644 -D duckstationicons/64.png /usr/local/share/icons/hicolor/64x64/apps/duckstation-qt.png    #64

#install .desktop file itself
sudo install -m 644 -D duckstationicons/DuckStation.desktop /usr/local/share/applications/DuckStation.desktop

#done
echo "Done!"
