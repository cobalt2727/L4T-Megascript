#!/bin/bash
clear -x
echo "Installing the GNOME desktop environment."

# version function
function version { echo "$@" | awk -F. '{ printf("%d%03d%03d\n", $1,$2,$3); }'; }

sudo apt install gnome-session gnome-tweaks gnome-tweak-tool chrome-gnome-shell gnome-shell wget curl jq unzip sed -y || error "Could not install dependencies"
hash -r
sdlv=$(dpkg -s gnome-shell | sed -n 's/Version: //p')

cd ~
rm -f ./install-gnome-extensions.sh

if [ $(version $sdlv) -ge $(version "3.34.0") ]; then
  echo "Gnome 34 or newer detected"
  wget -N -q "https://raw.githubusercontent.com/cyfrost/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh
else
  echo "Gnome older than 34 detected"
  wget -N -q "https://raw.githubusercontent.com/cyfrost/install-gnome-extensions/7ea5327e36c35e732c6c97887c08fe3596506727/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh
fi

echo "Installing Some Common Extensions"
chmod +x install-gnome-extensions.sh
# use this helpful script to install some desired extensions from command line
# 615 is AppIndicator and KStatusNotifyerItem Support
./install-gnome-extensions.sh --enable 615 -o

#automatically sorts Gnome app layout alphabetically
gsettings reset org.gnome.shell app-picker-layout

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

echo "Going back to the main menu..."
