#!/bin/bash

#####################################################################################

#functions used by megascript scripts

#####################################################################################

function get_system {
  # architecture is the native cpu architecture (aarch64, armv7l, armv6l, x86_64, i386, etc)
  architecture="$(uname -m)"
  # dpkg_architecture is the default userspace cpu architecture (arm64, amd64, armhf, i386, etc)
  dpkg_architecture="$(dpkg --print-architecture)"
  # jetson codename is the name reported in the DTS filename
  jetson_codename=""
  # jetson model is the friendly name that we assign
  jetson_model=""
  # get model name
  # https://github.com/dylanaraps/neofetch/blob/77f2afc37239d9494ce0f5d0f71f690f8b4d34e3/neofetch#L1232
  if [[ -d /system/app/ && -d /system/priv-app ]]; then
      model="$(getprop ro.product.brand) $(getprop ro.product.model)"

  elif [[ -f /sys/devices/virtual/dmi/id/product_name ||
          -f /sys/devices/virtual/dmi/id/product_version ]]; then
      model="$(tr -d '\0' < /sys/devices/virtual/dmi/id/product_name)"
      model+=" $(tr -d '\0' < /sys/devices/virtual/dmi/id/product_version)"

  elif [[ -f /sys/firmware/devicetree/base/model ]]; then
      model="$(tr -d '\0' < /sys/firmware/devicetree/base/model)"

  elif [[ -f /tmp/sysinfo/model ]]; then
      model="$(tr -d '\0' < /tmp/sysinfo/model)"
  fi
  # Remove dummy OEM info.
  model=${model//To be filled by O.E.M.}
  model=${model//To Be Filled*}
  model=${model//OEM*}
  model=${model//Not Applicable}
  model=${model//System Product Name}
  model=${model//System Version}
  model=${model//Undefined}
  model=${model//Default string}
  model=${model//Not Specified}
  model=${model//Type1ProductConfigId}
  model=${model//INVALID}
  model=${model//All Series}
  model=${model//�}
  local __platform=""
  if [[ -e "/proc/device-tree/compatible" ]]; then
      CHIP="$(tr -d '\0' < /proc/device-tree/compatible)"
      if [[ ${CHIP} =~ "tegra186" ]]; then
          __platform="tegra-x2"
      elif [[ ${CHIP} =~ "tegra210" ]]; then
          __platform="tegra-x1"
      elif [[ ${CHIP} =~ "tegra194" ]]; then
          __platform="xavier"
      fi
      jetson_model="$__platform"
  elif [[ -e "/sys/devices/soc0/family" ]]; then
      CHIP="$(tr -d '\0' < /sys/devices/soc0/family)"
      if [[ ${CHIP} =~ "tegra20" ]]; then
          __platform="tegra-2"
      elif [[ ${CHIP} =~ "tegra30" ]]; then
          __platform="tegra-3"
      elif [[ ${CHIP} =~ "tegra114" ]]; then
          __platform="tegra-4"
      elif [[ ${CHIP} =~ "tegra124" ]]; then
          __platform="tegra-k1-32"
      elif [[ ${CHIP} =~ "tegra132" ]]; then
          __platform="tegra-k1-64"
      elif [[ ${CHIP} =~ "tegra210" ]]; then
          __platform="tegra-x1"
      fi
      jetson_model="$__platform"
  fi
  unset __platform
}
export -f get_system

# run get_system function for the refactor to use
get_system

function userinput_func {
  unset uniq_selection
  height=$(($(echo "$description" | grep -o '\\n' | wc -l) + 8))
  if [[ $gui == "gui" ]]; then
    if [[ "${#@}" == "2" ]];then
      echo -e "$1" |  yad --show-uri --center --image "dialog-information" --borders="20" --title "User Info Prompt" \
      --text-info --fontname="@font@ 11" --wrap --width=800 --height=500 \
      --show-uri  --window-icon=/usr/share/icons/L4T-Megascript.png \
      --button="$2":0
      output="$2"
    elif [[ "${#@}" == "3" ]];then
      yad --image "dialog-question" \
      --borders="20" --height="200" --center --fixed\
      --window-icon=/usr/share/icons/L4T-Megascript.png \
      --text="$1" \
      --button="$2":0 \
      --button="$3":1
      if [[ $? -ne 0 ]]; then
        output="$3"
      else
        output="$2"
      fi
    else
      for string in "${@:2}"; do
        uniq_selection+=(FALSE "$string")
      done
      uniq_selection[0]=TRUE
      output=$(
        yad --center \
          --borders="20" \
          --window-icon=/usr/share/icons/L4T-Megascript.png \
          --text "$1" \
          --list \
          --radiolist \
          --column "" \
          --column "Selection" \
          --print-column=2 \
          --separator='' \
          --button="Ok":0 \
          "${uniq_selection[@]}"
      )
    fi
  else
    if [[ "${#@}" == "3" ]];then
      dialog  --stdout --clear --yes-label "$2" --no-label "$3" --yesno "$1" "$height" "120"
      if [[ $? -ne 0 ]]; then
        output="$3"
      else
        output="$2"
      fi
    else
      for string in "${@:2}"; do
        uniq_selection+=("$string" "")
      done
      output=$(
        dialog --stdout --clear \
          --backtitle "CLI Chooser Helper" \
          --title "Choices" \
          --menu "$1" \
          "$height" "120" "$($# - 1)" \
          "${uniq_selection[@]}" \
          2>&1 >/dev/tty
      )
    fi
  fi
  status=$?
  if [[ $status = "1" ]]; then
    clear -x
    echo "Canceling Install, Back to the Megascript"
    exit 1
  fi
  clear -x
}
export -f userinput_func

function ppa_installer {
  local ppa_grep="$ppa_name"
  [[ "${ppa_name}" != */ ]] && local ppa_grep="${ppa_name}/"
  local ppa_added=$(grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep -v '#' | grep "$ppa_grep" | wc -l)
  if [[ $ppa_added -eq "1" ]]; then
    echo "Skipping $ppa_name PPA, already added"
  else
    echo "Adding $ppa_name PPA"
    sudo apt install software-properties-common -y || error "Failed to install ppa_installer dependencies"
    hash -r
    sudo add-apt-repository "ppa:$ppa_name" -y
    sudo apt update
  fi
  unset ppa_name
}
export -f ppa_installer

function ppa_purger {
  local ppa_grep="$ppa_name"
  [[ "${ppa_name}" != */ ]] && local ppa_grep="${ppa_name}/"
  local ppa_added=$(grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep -v '#' | grep "$ppa_grep" | wc -l)
  echo "$ppa_url"
  if [[ $ppa_added -eq "1" ]]; then
    echo "Removing $ppa_name PPA"
    sudo apt-get install ppa-purge -y
    sudo ppa-purge "ppa:$ppa_name" -y
    sudo apt update
  else
    echo "$ppa_name PPA does not exist, skipping removal"
  fi
  unset ppa_name
}
export -f ppa_purger

function online_check {
    while : ; do
    clear -x
    date
    echo "Checking internet connectivity..."
    #silently check connection to github AND githubusercontent, we had an edge case where a guy was getting githubusercontent blocked by his ISP
    wget -q --spider https://github.com && wget -q --spider https://raw.githubusercontent.com/

    #read whether or not it was successful
    #the $? reads the exit code of the previous command, 0 meaning everything works
    if [ $? == 0 ]
    then
	echo -e "\e[32mInternet OK\e[0m"
        break
    fi
    #tell people to fix their internet
    echo "You're offline and/or can't reach GitHub."
    echo "We can't run the script without this..."
    echo "You'll need to connect to WiFi or allow GitHub in your firewall."
    echo "(you can close this window at any time.)"
    echo "Retrying the connection in..."
    ########## bootleg progress bar time ##########
    echo -e "\e[31m5\e[0m"
    printf '\a'
    sleep 1
    echo -e "\e[33m4\e[0m"
    printf '\a'
    sleep 1
    echo -e "\e[32m3\e[0m"
    printf '\a'
    sleep 1
    echo -e "\e[34m2\e[0m"
    printf '\a'
    sleep 1
    echo -e "\e[35m1\e[0m"
    printf '\a'
    echo "Trying again..."
    sleep 1
    #and now we let it loop
    done
}
export -f online_check

function runCmd() {
    local ret
    "$@"
    ret=$?
    if [[ "$ret" -ne 0 ]]; then
        echo "${scripts[$word]} reported an error running '$*' - returned $ret" >> /tmp/megascript_errors.txt
    fi
    return $ret
}
export -f runCmd

warning() { #yellow text
  echo -e "\e[93m\e[5m 🔺\e[25m WARNING: $1\e[0m"
}
export -f warning

status() { #cyan text to indicate what is happening
  echo -e "\e[96m$1\e[0m"
}
export -f status

status_green() { #announce the success of a major action
  echo -e "\e[92m$1\e[0m"
}
export -f status_green

function error {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 1
}
export -f error

format_logfile() { #remove ANSI escape sequences from a given file, and add OS information to beginning of file
  [ -z "$1" ] && error "format_logfile: no filename given!"
  [ ! -f "$1" ] && error "format_logfile: given filename ($1) does not exist or is not a file!"
  
  echo -e "$model\n\nBEGINNING OF LOG FILE:\n-----------------------\n\n$(cat "$1" | tr '\r' '\n' | sed 's/\x1b\[[0-9;]*m//g' | sed 's/\x1b\[[0-9;]*//g' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | grep -vF '.......... .......... .......... .......... ..........')" > "$1"
  
}
export -f format_logfile

send_error() {
  curl -F "file=@\"$1\";filename=\"$(basename $1 | sed 's/\.log.*/.txt/g')\"" "https://discord.com/api/webhooks/905317525246586910/TPrRX5oFWE5PqhbYPrXA0g9BFwFgTcizvRuWbLBVGBhBcH10mL26ZDbMXcBW3C-xhEWg"
}
export -f send_error

# https://github.com/Botspot/pi-apps/blob/a53271dd59a1946cc1eac0acdcefc3405f672f39/api#L111
package_available() { #determine if the specified package-name exists in a repository
  local package="$1"
  [ -z "$package" ] && error "package_available(): no package name specified!"
  #using grep to do this is nearly instantaneous, rather than apt-cache which takes several seconds
  grep -rq "^Package: $package"'$' /var/lib/apt/lists/ 2>/dev/null
}
export -f package_available
#####################################################################################

#end of functions used by megascript scripts

#####################################################################################
