sudo su -c "echo 'Package: *' > /etc/apt/preferences.d/chromium"
sudo su -c "echo 'Pin: release o=LP-PPA-saiarcot895-chromium-beta' >> /etc/apt/preferences.d/chromium"
sudo su -c "echo 'Pin-Priority: 700' >> /etc/apt/preferences.d/chromium"

if test -f /usr/local/bin/snap; then
  sudo snap remove firefox
fi

ppa_name="mozillateam/firefox-next" && ppa_installer

sudo apt install firefox -y
