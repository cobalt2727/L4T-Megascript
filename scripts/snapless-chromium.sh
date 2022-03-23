#!/bin/bash

if grep -q bionic /etc/os-release; then error_user "You shouldn't be running this on Ubuntu Bionic, skipping installation"; fi

sudo su -c "echo 'Package: *' > /etc/apt/preferences.d/chromium"
sudo su -c "echo 'Pin: release o=LP-PPA-saiarcot895-chromium-beta' >> /etc/apt/preferences.d/chromium"
sudo su -c "echo 'Pin-Priority: 700' >> /etc/apt/preferences.d/chromium"

if test -f /usr/local/bin/snap; then
  sudo snap remove chromium
fi

ppa_name="saiarcot895/chromium-beta" && ppa_installer

sudo apt install --reinstall chromium-browser -y
sudo apt --fix-broken install -y

# browser crashes without --no-sanbox on newer ubuntu on jetson
# add a customization file with necessary flags
echo 'CHROMIUM_FLAGS="--no-sandbox --use-vulkan --enable-features=Vulkan"' | sudo tee /etc/chromium-browser/customizations/l4t-customizations
