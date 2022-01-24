#I haven't tested this, but it looks pretty unoptimized. Mostly just here for the far future if speed improves

echo "DobieStation script started!"

#no dependencies listed on repo, this is guesswork, guaranteed to be missing things -Cobalt
#all I know is the setup I already had built it correctly
sudo apt install -y git build-essential cmake qt5-qmake gcc g++ || error "Could not install dependencies"

if grep -q bionic /etc/os-release; then
  #honestly, default QT probably works fine, but...
  get_system
  if ! [[ "$dpkg_architecture" =~ ^("arm64"|"armhf")$ ]]; then
    warning "You are not running an ARMhf/ARM64 architecture, your system is not supported and this may not work"
    ppa_name="beineri/opt-qt-5.15.2-bionic"
  else
    ppa_name="theofficialgman/opt-qt-5.15.2-bionic-arm"
  fi
  ppa_installer
  sudo apt install -y qt515base || error "Could not install dependencies" #figure out the rest
else
  sudo apt install -y qtbase5-dev || error "Could not install dependencies"
fi

cd ~
git clone https://github.com/PSI-Rockin/DobieStation
cd DobieStation
git pull
mkdir build
cd build

if grep -q bionic /etc/os-release; then
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
else
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native
fi

### alternative if cmake starts failing on us down the line (not sure how we'd pass compiler flags here, though...)
# cd ~/DobieStation/DobieStation
# QT_SELECT=5 qmake DobieStation.pro

make -j$(nproc)

sudo make install || error "Make install failed"

cd ~

echo "Done!"
