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
cd ..
sudo cp -r duckstation/build/bin/ /usr/local/
cd /'

#install icons for .desktop files
cd /usr/local/share/icons/hicolor/scalable/apps
sudo wget -O duckstation-qt.svg https://upload.wikimedia.org/wikipedia/commons/a/a2/Logo_Duckstation.svg
cd /usr/local/share/icons/hicolor/128x128/apps
sudo wget -O duckstation-qt.png https://dl.flathub.org/repo/appstream/x86_64/icons/128x128/org.duckstation.DuckStation.png
cd /usr/local/share/icons/hicolor/16x16/apps
sudo wget -O duckstation-qt.png https://cdn2.steamgriddb.com/file/sgdb-cdn/icon/e1f581b9f9af4ca9be996aa40da6759e/32/16x16.png
cd /usr/local/share/icons/hicolor/24x24/apps
sudo wget -O duckstation-qt.png https://cdn2.steamgriddb.com/file/sgdb-cdn/icon/e1f581b9f9af4ca9be996aa40da6759e/32/24x24.png
cd /usr/local/share/icons/hicolor/256x256/apps
sudo wget -O duckstation-qt.png https://static-s.aa-cdn.net/img/gp/20600014002217/0lQAIz9NFGArLCmXVfyLXwJlBuUPPMKg_rTdcrvtlTM17LLSuujzYfBy7Q9qUi7tiQ?v=1
cd /usr/local/share/icons/hicolor/32x32/apps
sudo wget -O duckstation-qt.png https://cdn2.steamgriddb.com/file/sgdb-cdn/icon/e1f581b9f9af4ca9be996aa40da6759e/32/32x32.png
cd /usr/local/share/icons/hicolor/48x48/apps
sudo wget -O duckstation-qt.png https://cdn2.steamgriddb.com/file/sgdb-cdn/icon/e1f581b9f9af4ca9be996aa40da6759e/32/48x48.png
cd /usr/local/share/icons/hicolor/512x512/apps
sudo wget -O duckstation-qt.png https://play-lh.googleusercontent.com/0lQAIz9NFGArLCmXVfyLXwJlBuUPPMKg_rTdcrvtlTM17LLSuujzYfBy7Q9qUi7tiQ 
cd /usr/local/share/icons/hicolor/64x64/apps
sudo wget -O duckstation-qt.png ttps://cdn2.steamgriddb.com/file/sgdb-cdn/icon/e1f581b9f9af4ca9be996aa40da6759e/32/64x64.png
cd /usr/local/share/icons/hicolor/8x8/apps
sudo wget -O duckstation-qt.png https://cdn-images.imagevenue.com/71/c7/71/ME16HPQS_o.png

#install .desktop file itself
cd /usr/local/share/applications
sudo bash -c 'cat <<EOF > Duckstation.desktop
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=duckstation-qt
Name=DuckStation
Comment=Fast PlayStation 1 emulator
Icon=duckstation-qt
Categories=Game;Emulator;
EOF'
echo "Done!"
