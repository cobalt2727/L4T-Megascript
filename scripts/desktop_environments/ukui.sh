#!/bin/bash

clear -x
echo "You are about to install the UKUI desktop environment."
echo "Under most cases this shouldn't break anything and install alongside of your existing desktop, but just to be sure..."
echo "Are you sure you want to continue?"

##prompt yes/no
sudo apt install ukui-desktop-environment -y

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
