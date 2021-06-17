#!/bin/bash
# all credits go out to https://github.com/jetsonhacks/installLXDE and the blogpost along with it
# there are custom changes in this script

clear
echo "Installing the LXDE desktop environment."
sudo apt update
sudo apt install lxde compton libappindicator3-1 -y


# This tells LXDE to use the Compton compositor
sudo dd of=/etc/xdg/autostart/lxde-compton.desktop << EOF
[Desktop Entry]
Type=Application
Name=Compton (X Compositor)
GenericName=X compositor
Comment=A X compositor
TryExec=compton
Exec=compton --backend glx -b
OnlyShowIn=LXDE
EOF

dd of=~/.config/autostart/auto-rotate.desktop  << EOF
[Desktop Entry]
Type=Application
Name=Auto-Rotate
GenericName=rotation script
Exec=/usr/local/bin/auto-rotate
OnlyShowIn=LXDE
EOF

# overwrite dock-hotplug until new one gets released

echo | sudo tee /usr/bin/dock-hotplug <<'EOF'
#!/bin/bash

background_stuff() {
	export DISPLAY=
	export DP_SETTINGS=

	# Read custom WIDTHxHEIGHT from dock-hotplug.conf
	if [ -e "/etc/dock-hotplug.conf" ]; then
		export DP_SETTINGS=$(cat /etc/dock-hotplug.conf)
	fi
	if [[ -n $DP_SETTINGS ]]; then
		export DP_SETTINGS="--primary --mode "$DP_SETTINGS" --panning "$DP_SETTINGS"+0+0 --pos 0x0"
	else
		export DP_SETTINGS="--primary --auto"
	fi

	while [ "$DISPLAY" = "" ]
	do
		cd /tmp/.X11-unix && for x in X*;
		do
			if [ ! -e "$x" ]; then continue; fi
			export DISPLAY=":${x#X}"

			if [ "$DISPLAY" = "" ]; then sleep 1; continue; fi

			USER_NAME=$(who | awk -v vt="$DISPLAY" '$0 ~ vt {print $1}')
			USER_ID=$(id -u "$USER_NAME")
			PULSE_SERVER="unix:/run/user/"$USER_ID"/pulse/native"

			# from https://wiki.archlinux.org/index.php/Acpid#Laptop_Monitor_Power_Off
			export XAUTHORITY=$(ps -C Xorg -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p')

			if [[ "$1" -eq 1 ]]
			then
				xrandr --output DP-0 $DP_SETTINGS --output DSI-0 --off
				xinput disable 6 #disable touch screen
				sudo -u "$USER_NAME" xrandr --output DP-0 $DP_SETTINGS --output DSI-0 --off
				sudo -u "$USER_NAME" xinput disable 6 #disable touch screen
				sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 1 off
				sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 0 output:hdmi-stereo
			else
				xrandr --output DSI-0 --mode "720x1280" --primary --rotate left --panning 1280x720+0+0 --pos 0x0 --dpi 237
				xinput enable 6 #enable touch screen
				xinput set-prop touchscreen "Coordinate Transformation Matrix" 0, -1, 1, 1, 0, 0, 0, 0, 1
				sudo -u "$USER_NAME" xrandr --output DSI-0 --mode "720x1280" --primary --rotate left --panning 1280x720+0+0 --pos 0x0 --dpi 237
				sudo -u "$USER_NAME" xinput enable 6 #enable touch screen
				sudo -u "$USER_NAME" xinput set-prop touchscreen "Coordinate Transformation Matrix" 0, -1, 1, 1, 0, 0, 0, 0, 1
				sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 1 HiFi
				sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 0 off
			fi
			sleep 1
		done
	done

	# Execute custom dock-hotplug.sh
	if [ -e "/etc/dock-hotplug.sh" ]; then
		/bin/bash /etc/dock-hotplug.sh $1
	fi

	if [[ "$1" -eq 0 ]]; then
		gsettings set com.ubuntu.user-interface scale-factor "{'': 8, 'DSI-0': 10, 'DP-0': 8}"
	fi

	if grep -q 1 "/var/lib/nvpmodel/auto_profiles"; then 
		if [[ "$1" -eq 1 ]]; then
			nvpmodel -m 0
			nvpmodel -d Console
		else
			nvpmodel -m 1
			nvpmodel -d Handheld
		fi
	fi
}

i=1
DP_ENABLED=1
LOOPS=2
if [[ "$1" -eq 1 ]]; then LOOPS=5; fi

while [ "$i" -le "$LOOPS" ]; do
	if grep -q 1 "/sys/class/switch/dp/state"; then DP_ENABLED=1; else DP_ENABLED=0; fi
	if [[ "$LOOPS" -eq 5 ]]; then
		background_stuff $DP_ENABLED
	else
		background_stuff $DP_ENABLED & disown
	fi
	i=$(($i + 1))
done
EOF

# Also, put a LXTerminal shortcut on the desktop
cp lxterminal.desktop ~/Desktop/lxterminal.desktop

echo "Going back to the main menu..."
