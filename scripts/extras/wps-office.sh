#!/bin/bash

# pre-accept mscorefonts EULA
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

# download apt package
cd /tmp
rm -f wps-office_*.deb
wget https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/10976/wps-office_11.1.0.10976_arm64.deb --progress=bar:force:noscroll || error "Failed to download wps office suite"

# install wps office apt package
sudo apt install ./wps-office_*.deb -y || error "Failed to install wps office suite"
status "Successfully install WPS Office Suite"
