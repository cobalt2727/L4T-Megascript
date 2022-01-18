#!/bin/bash

# pre-accept mscorefonts EULA
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

# download apt package
cd /tmp
rm -f wps-office_11.1.0.10702_arm64.deb
wget https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/10702/wps-office_11.1.0.10702_arm64.deb || error "Failed to download wps office suite"

# install wps office apt package
sudo apt install ./wps-office_11.1.0.10702_arm64.deb -y || error "Failed to install wps office suite"
status "Successfully install WPS Office Suite"
