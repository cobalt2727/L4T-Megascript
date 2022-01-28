#!/bin/bash

#####################################################################################

#functions used by megascript scripts

#####################################################################################
unset functions_downloaded

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
  
  # adapted/inspired from retropie setup script system.sh https://github.com/RetroPie/RetroPie-Setup/blob/master/scriptmodules/system.sh
  # armbian uses a minimal shell script replacement for lsb_release with basic
  # parameter parsing that requires the arguments split rather than using -sidrc
  mapfile -t os < <(lsb_release -s -i -d -r -c)
  __os_id="${os[0]}"
  __os_desc="${os[1]}"
  __os_release="${os[2]}"
  __os_codename="${os[3]}"

}
export -f get_system

# run get_system function for the refactor to use
get_system

function userinput_func {
  unset uniq_selection
  height=$(($(echo "$description" | grep -o '\\n' | wc -l) + 8))
  height_gui=$(echo $(( height * 15 + ${#@} * 20 + 100 )))
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
        yad --center --fixed --height=$height_gui\
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
          "${uniq_selection[@]}"
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

function error_user {
  echo -e "\\e[91m$1\\e[39m"
  sleep 3
  exit 2
}
export -f error_user

format_logfile() { #remove ANSI escape sequences from a given file, and add OS information to beginning of file
  [ -z "$1" ] && error "format_logfile: no filename given!"
  [ ! -f "$1" ] && error "format_logfile: given filename ($1) does not exist or is not a file!"
  
  echo -e "$model\n\nBEGINNING OF LOG FILE:\n-----------------------\n\n$(cat "$1" | tr '\r' '\n' | sed 's/\x1b\[[0-9;]*m//g' | sed 's/\x1b\[[0-9;]*//g' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | grep -vF '.......... .......... .......... .......... ..........')" > "$1"
  
}
export -f format_logfile

send_error() {
  curl -F "file=@\"$1\";filename=\"$(basename $1 | sed 's/\.log.*/.txt/g')\"" "https://discord.com/api/webhooks/935036770477801502/ANjo3haSSrCDwHg-BrMHmZgNLaMzxLLs6ZRUf74sa6OYU5VLqLxdy27JA7N7EBGG7IQc"
}
export -f send_error

add_english() {  # add en_US locale for more accurate error 
  if [ "$(cat /usr/share/i18n/SUPPORTED | grep -o 'en_US.UTF-8' )" == "en_US.UTF-8" ]; then 
    locale=$(locale -a | grep -oF 'en_US.utf8')
    if [ "$locale" != 'en_US.utf8' ]; then
      status "Adding en_US locale for better logging... "
      sudo sed -i '/en_US.UTF-8/s/^#[ ]//g' /etc/locale.gen
      sudo locale-gen
    fi
  else
      warning "en_US locale is not available on your system. This may cause bad logging experience."
  fi
  export LANG="en_US.UTF-8"
  export LANGUAGE="en_US.UTF-8"
  export LC_ALL="en_US.UTF-8"
}
export -f add_english

### pi-apps functions

#package functions
package_info() { #list everything dpkg knows about the $1 package
  local package="$1"
  [ -z "$package" ] && error "package_info(): no package specified!"
  #list lines in /var/lib/dpkg/status between the package name and the next empty line
  sed -n -e '/^Package: '"$package"'$/,/^$/p' /var/lib/dpkg/status
  true #this may exit with code 141 if the pipe was closed early (to be expected with grep -v)
}
export -f package_info

package_installed() { #exit 0 if $1 package is installed, otherwise exit 1
  local package="$1"
  [ -z "$package" ] && error "package_installed(): no package specified!"
  #find the package listed in /var/lib/dpkg/status
  #package_info "$package" | grep -q '^Status: install ok installed$'
  
  #directly search /var/lib/dpkg/status
  grep '^Status: install ok installed$\|^Package:' /var/lib/dpkg/status | grep "$package" --after 1 | grep -q 'Status: install ok installed'
}
export -f package_installed

package_available() { #determine if the specified package-name exists in a repository
  local package="$1"
  [ -z "$package" ] && error "package_available(): no package name specified!"
  #using grep to do this is nearly instantaneous, rather than apt-cache which takes several seconds
  grep -rq "^Package: $package"'$' /var/lib/apt/lists/ 2>/dev/null
}
export -f package_available

package_dependencies() { #outputs the list of dependencies for the $1 package
  local package="$1"
  [ -z "$package" ] && error "package_dependencies(): no package specified!"
  
  #find the package listed in /var/lib/dpkg/status
  package_info "$package" | grep '^Depends: ' | sed 's/^Depends: //g'
}
export -f package_dependencies

anything_installed_from_repo() { #Given an apt repository URL, determine if any packages from it are currently installed
  [ -z "$1" ] && error "anything_installed_from_repo: A repository URL must be specified."
  
  #user input repo-url. Remove 'https://', and translate '/' to '_' to conform to apt file-naming standard
  local url="$(echo "$1" | sed 's+.*://++g' | sed 's+/+_+g')"
  
  #find all package-lists pertaining to the url
  local repofiles="$(ls /var/lib/apt/lists/*_Packages | grep "$url")"
  
  #for every repo-file, chack if any of them have an installed file
  local found=0
  local IFS=$'\n'
  local repofile
  for repofile in $repofiles ;do
    #search the repo-file for installed packages
    grep '^Package' "$repofile" | awk '{print $2}' | while read -r package ;do
      if package_installed "$package" ;then
        echo "Package installed: $package"
        exit 1
      fi
    done #if exit code is 1, search was successful. If exit code is 0, no packages from the repo were installed.
    
    found=$?
    
    if [ $found == 1 ];then
      break
    fi
  done
  
  #return an exit code
  if [ $found == 1 ];then
    return 0
  else
    return 1
  fi
}
export -f anything_installed_from_repo

remove_repofile_if_unused() { #Given a sources.list.d file, delete it if nothing from that repository is currently installed. Deletion skipped if $2 is 'test'
  local file="$1"
  local testmode="$2"
  [ -z "$file" ] && error "remove_repo_if_unused: no sources.list.d file specified!"
  #exit now if the list file does not exist
  [ -f "$file" ] || exit 0
  
  #determine what repo-urls are in the file
  local urls="$(cat "$file" | grep -v '^#' | tr ' ' '\n' | grep '://')"
  
  #there could be multiple urls in one file. Check each url and set the in_use variuable to 1 if any packages are found
  local IFS=$'\n'
  local in_use=0
  local url
  for url in $urls ;do
    if anything_installed_from_repo "$url" >/dev/null;then
      in_use=1
      break
    fi
  done
  
  if [ "$in_use" == 0 ] && [ "$testmode" == test ];then
    echo "The given repository is not in use and can be deleted:"$'\n'"$file" 1>&2
  elif [ "$in_use" == 0 ];then
    status "Removing the $(basename "$file" | sed 's/.list$//g') repo as it is not being used"
    sudo rm -f "$file"
  fi
  
}
export -f remove_repofile_if_unused


#####################################################################################
# don't remove this line
# it is used to verify that the entire functions file was sourced
export functions_downloaded="success"
#####################################################################################

#end of functions used by megascript scripts

#####################################################################################
