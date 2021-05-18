#!/bin/bash

repository_username=$3
repository_branch=$4

#functions used by megascript scripts
function userinput_func {
  unset uniq_selection
  if [[ $gui == "gui" ]]; then
     for string in "${@:2}"; do
      uniq_selection+=(FALSE "$string")
     done
     uniq_selection[0]=TRUE
     output=$(
          zenity \
          --width="1000" \
          --height="500" \
          --text "$1" \
          --list \
          --radiolist \
          --column "" \
          --column "Selection" \
          --ok-label="OK" \
          "${uniq_selection[@]}" \
          --cancel-label "Cancel Choice"
        )
  else
    for string in "${@:2}"; do
      uniq_selection+=("$string" "")
    done
    output=$(dialog --clear \
                --backtitle "CLI Chooser Helper" \
                --title "Choices" \
                --menu "$1" \
                "15" "120" "$($# - 1)" \
                "${uniq_selection[@]}" \
                2>&1 >/dev/tty)
  fi
  status=$?
  if [[ $status = "1" ]]; then
    clear
    echo "Canceling Install, Back to the Megascript"
    exit 1
  fi
  clear
}
export -f userinput_func

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
