#!/bin/bash

repository_username=$3
repository_branch=$4

#####################################################################################

#functions used by megascript scripts

#####################################################################################

function get_system {
  # architecture is the native cpu architecture (aarch64, x86_64, etc)
  architecture="$(uname -m)"
  # jetson codename is the name reported in the DTS filename
  jetson_codename=""
  # jetson model is the friendly name that we assign
  jetson_model=""
  local __platform=""
  if [ -f /proc/device-tree/nvidia,dtsfilename ]; then
      jetson_codename=$(tr -d '\0' < /proc/device-tree/nvidia,dtsfilename)
      jetson_codename=$(echo ${jetson_codename#*"/hardware/nvidia/platform/"} | tr '/' '\n' | head -2 | tail -1 )
      case "$jetson_codename" in
          icosa*) __platform="nintendo-switch" ;;
          *2180*) __platform="tx1" ;;
          P3310*|P3489-0080*|P3489*) __platform="tx2" ;;
          P2888-0006*|P2888-0001*|P2888-0004*|P2888*|P3668-0001*|P3668*) __platform="xavier" ;;
          P3448-0002*|P3448*) __platform="nano" ;;
      esac
      jetson_model="$__platform"
  fi
  unset __platform
}
export -f get_system

function userinput_func {
  unset uniq_selection
  height=$(($(echo "$description" | grep -o '\\n' | wc -l) + 8))
  if [[ $gui == "gui" ]]; then
    if [[ "${#@}" == "3" ]];then
      zenity --width 300 --question \
      --text="$1" \
      --ok-label "$2" \
      --cancel-label "$3"
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
        zenity \
          --text "$1" \
          --list \
          --radiolist \
          --column "" \
          --column "Selection" \
          --ok-label="OK" \
          "${uniq_selection[@]}" \
          --cancel-label "Cancel Choice"
      )
    fi
  else
    if [[ "${#@}" == "3" ]];then
      dialog --clear --yes-label "$2" --no-label "$3" --yesno "$1" "$height" "120"
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
        dialog --clear \
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

#####################################################################################

#end of functions used by megascript scripts

#####################################################################################

if [ -v $repository_username ] || [ $repository_username == cobalt2727 ]; then
  export repository_username=cobalt2727
else
  echo "Developer Mode Enabled! Repository = $repository_username"
fi
if [ -v $repository_branch ] || [ $repository_branch == master ]; then
  export repository_branch=master
else
  echo "Developer Mode Enabled! Branch = $repository_branch"
fi
sudo apt update
$2 bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/$1)"


##DOCUMENTATION
##  This file is here to help people easily run just one component of the megascript in
##  their own setups (or even other projects! Just make sure to credit us somewhere).
##  To run, let's say, the joycon-mouse file from this repository, which is in the 'scripts' folder, you
##  would run the following line (without the hashtags or empty space in front):
##        bash <( curl https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/helper.sh ) "scripts/joycon-mouse.sh"

##  Since barrier.sh is in another subfolder, to run that, you'd do something like:
##        bash <( curl https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/helper.sh ) "scripts/extras/barrier.sh"

##  And obviously you need both bash and curl installed for these to work - the scripts should in most cases install everything else themselves.
