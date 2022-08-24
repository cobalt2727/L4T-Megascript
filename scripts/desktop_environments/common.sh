#!/bin/bash

#common scripts used by all DEs without autorotation

# disable autologin
replace() {
  file=$1
  var=$2
  new_value=$3
  awk -v var="$var" -v new_val="$new_value" 'BEGIN{FS=OFS="="}match($1, "^\\s*" var "\\s*") {$2="" new_val}1' "$file"
}
if [[ -f "/etc/gdm3/custom.conf" ]]; then
  replace /etc/gdm3/custom.conf AutomaticLoginEnable False | sudo tee /etc/gdm3/custom.conf
fi

# get system info
get_system

# only run on nintendo switch systems (previously named icosa or icosa_emmc but now named Nintendo Switch (20XX))
if echo "$model" | grep -q [Ss]witch || echo "$model" | grep -q [Ii]cosa; then
  echo "Adding autorotation script"

  sudo apt install iio-sensor-proxy libxrandr2 libglib2.0-dev -y
  cd /usr/local/bin
  sudo rm -rf auto-rotate
  sudo wget -O auto-rotate https://github.com/theofficialgman/yoga-900-auto-rotate/blob/master/auto-rotate?raw=true
  sudo chmod +x auto-rotate
  cd ~

  sudo dd of=/etc/xdg/autostart/auto-rotate.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Auto-Rotate
GenericName=rotation script
Exec=bash -c "pkill auto-rotate; /usr/local/bin/auto-rotate"
OnlyShowIn=X-Cinnamon;MATE;LXDE;openbox;XFCE
EOF

  # add custom dock-hotplug
  sudo rm -rf /etc/dock-hotplug.sh
  sudo tee /etc/dock-hotplug.sh <<'EOF'
#!/bin/bash

# Thanks CTC for the convenient and workable user grab

# User name is important for rotation and must always be filled in. Users with pulse are preferred.
# Try logged-in user.
DH_USER_NAME=$(who | awk -v vt="$DISPLAY" '$0 ~ vt {print $1}')
# Try gdm greeter.
if [ "$DH_USER_NAME" == "" ]; then export DH_USER_NAME=gdm; fi
# Nothing was found. Use root to at least let sudo user xrandr commands to succeed.
if [ "$DH_USER_NAME" == "" ]; then export DH_USER_NAME=root; fi


if [[ "$1" -eq 1 ]]
then
	echo ""
else
	xinput set-prop touchscreen "Coordinate Transformation Matrix" 0, -1, 1, 1, 0, 0, 0, 0, 1
	sudo -u "$DH_USER_NAME" xinput set-prop touchscreen "Coordinate Transformation Matrix" 0, -1, 1, 1, 0, 0, 0, 0, 1
fi
EOF
  sudo chmod +x /etc/dock-hotplug.sh

  # start onboard with more DEs list
  sudo dd of=/etc/xdg/autostart/onboard-autostart.desktop <<EOF
[Desktop Entry]
Name=Onboard
GenericName=Onboard onscreen keyboard
Comment=Flexible onscreen keyboard
Exec=onboard --not-show-in=GNOME,GNOME-Classic:GNOME --startup-delay=3.0
Icon=onboard
Type=Application
NoDisplay=true
X-Ubuntu-Gettext-Domain=onboard
AutostartCondition=GSettings org.gnome.desktop.a11y.applications screen-keyboard-enabled
X-GNOME-AutoRestart=true
OnlyShowIn=Unity;MATE;Budgie;LXDE;openbox;UKUI;XFCE
EOF
fi

# only run on nvidia jetsons
if [[ $jetson_model ]]; then
  # add the nvidia power profile indicator to startup for megascript DEs
  sudo dd of=/etc/xdg/autostart/nvpmodel.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Nvpmodel Indicator
GenericName=Indicator Nvidia
Exec=/usr/share/nvpmodel_indicator/nvpmodel_indicator.py
OnlyShowIn=LXDE;MATE;UKUI;XFCE
EOF
fi
