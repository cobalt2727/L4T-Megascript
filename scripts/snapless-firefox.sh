#!/bin/bash

if ! grep -q jammy /etc/os-release; then error_user "You shouldn't be running this unless you are on Ubuntu Jammy, skipping installation"; fi

sudo su -c "echo 'Package: *' > /etc/apt/preferences.d/firefox"
sudo su -c "echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/firefox"
sudo su -c "echo 'Pin-Priority: 700' >> /etc/apt/preferences.d/firefox"

if test -f /usr/local/bin/snap; then
  sudo snap remove firefox
fi

ppa_name="mozillateam/ppa" && ppa_installer

sudo apt install firefox -y
sudo apt --fix-broken install -y
