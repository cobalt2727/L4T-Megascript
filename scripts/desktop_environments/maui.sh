#!/bin/bash

###UNTESTED, WILL ALMOST CERTAINLY BREAK - PLEASE REPORT ERRORS TO THE DISCORD


sudo apt install cmake build-essential git libkf5config-dev libkf5coreaddons-dev libkf5i18n-dev libkf5kio-dev libkf5notifications-dev libkf5service-dev libqt5svg5-dev libqt5waylandcompositor5-dev mauikit qtbase5-dev qtdeclarative5-dev qtquickcontrols2-5-dev

git clone --depth 1 --branch master https://github.com/Nitrux/maui-shell.git

mkdir -p maui-shell/build && cd maui-shell/build

cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_BSYMBOLICFUNCTIONS=OFF -DQUICK_COMPILER=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON -DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON -DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_LIBDIR=lib/aarch64-linux-gnu ..

make -j$(nproc)
sudo make install || error "submitting build log..."
