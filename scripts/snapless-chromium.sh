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
# add new .desktop file to Desktop folder which apps list will use over /usr/share/applications/chromium-browser.desktop
if [ ! -d "/home/${USER}/Desktop" ]; then
	mkdir -p "/home/${USER}/Desktop"
fi

if [ ! -f "/home/${USER}/Desktop/chromium-browser.desktop" ] &&	[ -f "/usr/share/applications/chromium-browser.desktop" ]; then
	HEAD="#!/usr/bin/env xdg-open"
	echo "${HEAD}" > "/home/${USER}/Desktop/chromium-browser.desktop"
	cat "/usr/share/applications/chromium-browser.desktop" >> "/home/${USER}/Desktop/chromium-browser.desktop"
	chmod 755 "/home/${USER}/Desktop/chromium-browser.desktop"
	gio set "/home/${USER}/Desktop/chromium-browser.desktop" "metadata::trusted" yes
fi

sed -z -E -i 's/Exec=chromium-browser --no-sandbox %U\n/Exec=chromium-browser --no-sandbox --use-vulkan --enable-features=Vulkan %U\n/g' /home/${USER}/Desktop/chromium-browser.desktop
sed -z -E -i 's/Exec=chromium-browser --no-sandbox\n/Exec=chromium-browser --no-sandbox --use-vulkan --enable-features=Vulkan\n/g' /home/${USER}/Desktop/chromium-browser.desktop
sed -z -E -i 's/Exec=chromium-browser --no-sandbox --incognito\n/Exec=chromium-browser --no-sandbox --use-vulkan --enable-features=Vulkan --incognito\n/g' /home/${USER}/Desktop/chromium-browser.desktop
sed -z -E -i 's/Exec=chromium-browser --no-sandbox --temp-profile\n/Exec=chromium-browser --no-sandbox --use-vulkan --enable-features=Vulkan --temp-profile\n/g' /home/${USER}/Desktop/chromium-browser.desktop
sed -z -E -i 's/Exec=chromium-browser %U\n/Exec=chromium-browser --no-sandbox --use-vulkan --enable-features=Vulkan %U\n/g' /home/${USER}/Desktop/chromium-browser.desktop
sed -z -E -i 's/Exec=chromium-browser\n/Exec=chromium-browser --no-sandbox --use-vulkan --enable-features=Vulkan\n/g' /home/${USER}/Desktop/chromium-browser.desktop
sed -z -E -i 's/Exec=chromium-browser --incognito\n/Exec=chromium-browser --no-sandbox --use-vulkan --enable-features=Vulkan --incognito\n/g' /home/${USER}/Desktop/chromium-browser.desktop
sed -z -E -i 's/Exec=chromium-browser --temp-profile\n/Exec=chromium-browser --no-sandbox --use-vulkan --enable-features=Vulkan --temp-profile\n/g' /home/${USER}/Desktop/chromium-browser.desktop