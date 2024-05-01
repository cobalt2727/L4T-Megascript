#!/bin/bash

if [ $(id -u) != 0 ]; then
  clear -x
  echo "Your username is"
  echo "$USER"
else
  echo "The L4T-Megascript helper has exited without running. Please run as non-sudo"
  exit 1
fi

repository_username=$3
repository_branch=$4

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

function error_fatal {
  echo -e "\\e[91m$1\\e[39m"
  sleep 10
  exit 1
}

if grep -q debian /etc/os-release; then
  dependencies=("bash" "dialog" "gnutls-bin" "curl" "yad" "zenity" "lsb-release" "software-properties-common")
  ## Install dependencies if necessary
  dpkg -s "${dependencies[@]}" >/dev/null 2>&1 || if [[ $gui == "gui" ]]; then
    pkexec sh -c "apt update; apt-get dist-upgrade -y; apt-get install $(echo "${dependencies[@]}") -y; hash -r; repository_branch=$repository_branch; repository_username=$repository_username; apt update; apt dist-upgrade -y; hash -r"
  else
    sudo sh -c "apt update; apt-get dist-upgrade -y; apt-get install $(echo "${dependencies[@]}") -y; hash -r; repository_branch=$repository_branch; repository_username=$repository_username; apt update; apt dist-upgrade -y; hash -r"
  fi
elif grep -q fedora /etc/os-release || grep -q nobara /etc/os-release; then
  dependencies=("bash" "dialog" "gnutls" "curl" "yad" "zenity" "lsb_release")
  if [[ $gui == "gui" ]]; then
    pkexec sh -c "dnf upgrade -y; dnf install $(echo "${dependencies[@]}") -y; hash -r; repository_branch=$repository_branch; repository_username=$repository_username; dnf upgrade -y; hash -r"
  else
    sudo sh -c "dnf upgrade -y; dnf install $(echo "${dependencies[@]}") -y; hash -r; repository_branch=$repository_branch; repository_username=$repository_username; dnf upgrade -y; hash -r"
  fi
fi

unset functions_downloaded
source <(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/functions.sh)
[[ ! -z ${functions_downloaded+z} ]] && status "Functions Loaded" || error_fatal "Oh no! Something happened to your internet! Exiting the Megascript, please fix your internet and try again!"

add_english

mkdir -p "$HOME/L4T-Megascript/logs"
logfile="$HOME/L4T-Megascript/logs/install-incomplete-${1////-}.log"
if [ -f "$logfile" ] || [ -f "$(echo "$logfile" | sed 's+-incomplete-+-success-+g')" ] || [ -f "$(echo "$logfile" | sed 's+-incomplete-+-fail-+g')" ]; then
  #append a number to logfile's file-extension if the original filename already exists
  i=1
  while true; do
    #if variable $i is 2, then example newlogfile value: /path/to/install-Discord.log2
    newlogfile="$logfile$i"
    if [ ! -f "$newlogfile" ] && [ ! -f "$(echo "$newlogfile" | sed 's+/-incomplete-+-success-+g')" ] && [ ! -f "$(echo "$newlogfile" | sed 's+-incomplete-+-fail-+g')" ]; then
      logfile="${newlogfile}"
      break
    fi
    i=$((i + 1))
  done
  unset i
fi

case "$__os_id" in
Fedora) 
  sudo dnf --refresh check-update
  if [[ $? == 1 ]]; then
    # dnf check-update failed with an error
    yad --class L4T-Megascript --name "L4T Megascript" --center --image "dialog-warning" --width="500" --height="250" --title "ERROR" --text "Your DNF repos can not be updated and dnf has exited with an error! \
    \n\n\Verify that you are connected to the internet. \
    \n\nCheck the above terminal logs for any BROKEN dnf repos that you may have added.\nContinuing with the Megascript WILL produce ERRORs so this will exit now.\nFix your stuff." --window-icon=/usr/share/icons/L4T-Megascript.png \
      --button="Exit the L4T-Megascript":0
    exit
  fi
  ;;
*)
  #An apt repository's Packages file can be corrupted so that an apt update will silently fail. See: https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1809174
  #This line will fix the problem by removing any zero-size Packages files.
  removal_list="$(find /var/lib/apt/lists -type f -name '*Packages' -size 0 2>/dev/null)"
  if [ ! -z "$removal_list" ]; then
    echo "$removal_list" | xargs sudo rm -f
  fi
  grep -q '/dev/null | true;' /etc/apt/apt.conf.d/50appstream && sudo sed -i 's%/dev/null | true;%/dev/null || true;%g' /etc/apt/apt.conf.d/50appstream
  grep -q '/dev/null || true;' /etc/apt/apt.conf.d/50appstream
  if [[ $? == 1 ]]; then
    # fix for error (for some reason was never pulled into bionic...)
    # http://launchpadlibrarian.net/384348932/appstream_0.12.2-1_0.12.2-2.diff.gz patch is seen at the bottom here
    # E: Problem executing scripts APT::Update::Post-Invoke-Success 'if /usr/bin/test -w /var/cache/app-info -a -e /usr/bin/appstreamcli; then appstreamcli refresh > /dev/null; fi'
    # https://askubuntu.com/questions/942895/e-problem-executing-scripts-aptupdatepost-invoke-success
    sudo sed -i 's%/dev/null;%/dev/null || true;%g' /etc/apt/apt.conf.d/50appstream
  fi     
  update_output=$(sudo apt update 2>&1 | tee /dev/tty)
  echo "$update_output" | grep -qe '^Err:' -qe '^E:'
  if [[ $? == 0 ]]; then
    # apt update failed with an error
    yad --class L4T-Megascript --name "L4T Megascript" --center --image "dialog-warning" --width="500" --height="250" --title "ERROR" --text "Your APT repos can not be updated and apt has exited with an error! \
    \n\n\Verify that you are connected to the internet. \
    \n\nCheck the above terminal logs for any BROKEN apt repos that you may have added.\nContinuing with the Megascript WILL produce ERRORs so this will exit now.\nFix your stuff." --window-icon=/usr/share/icons/L4T-Megascript.png \
      --button="Exit the L4T-Megascript":0
    exit 1
  fi   
  ;;
esac
$2 bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/$1)" &> >(tee -a "$logfile")

if [ "$?" != 0 ]; then
  echo -e "\n\e[91mFailed to install $1!\e[39m
\e[40m\e[93m\e[5m🔺\e[25m\e[39m\e[49m\e[93mNeed help? Copy the \e[1mENTIRE\e[0m\e[49m\e[93m terminal output or take a screenshot.
Please ask on Github: \e[94m\e[4mhttps://github.com/cobalt2727/L4T-Megascript/issues\e[24m\e[93m
Or on Discord: \e[94m\e[4mhttps://discord.gg/abgW2AG87Z\e[0m" | tee -a "$logfile"
  # format_logfile "$logfile" #remove escape sequences from logfile
  mv "$logfile" "$(echo "$logfile" | sed 's+-incomplete-+-fail-+g')"
  echo "logfile name is $(echo "$logfile" | sed 's+-incomplete-+-fail-+g')"
  description="OH NO! The $1 script exited with an error code!\
\nPlease view the log in terminal to find the cause of the error\
\nIf you need help, copy the log and create a github issue or ask for help on our Discord!"
  table=("Exit")
  userinput_func "$description" "${table[@]}"
else
  status_green "\nInstalled $1 successfully." | tee -a "$logfile"
  # format_logfile "$logfile" #remove escape sequences from logfile
  mv "$logfile" "$(echo "$logfile" | sed 's+-incomplete-+-success-+g')"
fi

##DOCUMENTATION
##  This file is here to help people easily run just one component of the megascript in
##  their own setups (or even other projects! Just make sure to credit us somewhere).
##  To run, let's say, the joycon-mouse file from this repository, which is in the 'scripts' folder, you
##  would run the following line (without the hashtags or empty space in front):
##        bash <( curl https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/helper.sh ) "scripts/joycon-mouse.sh"

##  Since barrier.sh is in another subfolder, to run that, you'd do something like:
##        bash <( curl https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/helper.sh ) "scripts/extras/barrier.sh"

##  And obviously you need both bash and curl installed for these to work - the scripts should in most cases install everything else themselves.
