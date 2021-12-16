sudo su -c "echo 'Package: *' > /etc/apt/preferences.d/chromium"
sudo su -c "echo 'Pin: release o=LP-PPA-saiarcot895-chromium-beta' >> /etc/apt/preferences.d/chromium"
sudo su -c "echo 'Pin-Priority: 700' >> /etc/apt/preferences.d/chromium"

if test -f /usr/local/bin/snap; then
  sudo snap remove chromium
fi

ppa_name="saiarcot895/chromium-beta" && ppa_installer

sudo apt install chromium-browser -y
sudo apt --fix-broken install -y

# browser crashes without --no-sanbox on newer ubuntu on jetson
# remove all occurances of no-sanbox (to prevent double replacement)
sudo sed -i 's/Exec=chromium-browser --no-sandbox/Exec=chromium-browser/g' /usr/share/applications/chromium-browser.desktop
# add no-sandbox
sudo sed -i 's/Exec=chromium-browser/Exec=chromium-browser --no-sandbox/g' /usr/share/applications/chromium-browser.desktop
