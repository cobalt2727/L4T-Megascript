#!/bin/bash

###UNTESTED, WILL ALMOST CERTAINLY BREAK - PLEASE REPORT ERRORS TO THE DISCORD

echo "Installing dependencies..."
sudo apt install -y cmake build-essential git libkf5config-dev libkf5coreaddons-dev libkf5i18n-dev libkf5kio-dev libkf5notifications-dev libkf5service-dev libqt5svg5-dev libqt5waylandcompositor5-dev qtbase5-dev qtdeclarative5-dev qtquickcontrols2-5-dev cmake-extra-modules libkf5i18n-dev libkf5solid-dev libkf5syntaxhighlighting-dev libqt5x11extras5-dev libxcb-icccm4-dev libxcb-shape0-dev qml-module-qtgraphicaleffects qml-module-qtquick-controls2 qml-module-qtquick-shapes qtbase5-dev qtdeclarative5-dev libicu*  || error "Could not install dependencies"
if grep -q bionic /etc/os-release; then
  ppa_name="theofficialgman/opt-qt-5.15.2-bionic-arm" && ppa_installer
  sudo apt install -y qt515base #|| error "Could not install dependencies"
###commented out because this doesn't exist yet
# elif grep -q focal /etc/os-release
#   ppa_name="theofficialgman/opt-qt-5.15.2-focal-arm" && ppa_installer
#   sudo apt install -y qt515base #|| error "Could not install dependencies"
else
  sudo apt install -y qtbase5-dev #|| error "Could not install dependencies"
fi

cd ~
echo "Building mauikit..."

git clone --depth 1 --branch v2.1 https://invent.kde.org/maui/mauikit.git

mkdir -p mauikit/build && cd mauikit/build

#the below line hardcodes aarch64 because I was too lazy to make it architecture-agnostic. this should be fixed before we submit it to the app list
cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_BSYMBOLICFUNCTIONS=OFF -DQUICK_COMPILER=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON -DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON -DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_LIBDIR=lib/aarch64-linux-gnu -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE ..

make -j$(nproc)
sudo make install || error "submitting log for failed mauikit build..."


cd ~
echo "Building maui-shell..."

git clone --depth 1 --branch master https://github.com/Nitrux/maui-shell.git

mkdir -p maui-shell/build && cd maui-shell/build
#the below line hardcodes aarch64 because I was too lazy to make it architecture-agnostic. this should be fixed before we submit it to the app list
cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_BSYMBOLICFUNCTIONS=OFF -DQUICK_COMPILER=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON -DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON -DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_LIBDIR=lib/aarch64-linux-gnu -DCMAKE_PREFIX_PATH=/opt/qt515 -DCMAKE_BUILD_WITH_INSTALL_RPATH=FALSE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE ..

make -j$(nproc)
sudo make install || error "submitting log for failed maui-shell build..."
