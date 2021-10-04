#!/bin/bash

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

source <(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/functions.sh)
type get_system &>/dev/null && echo "Functions Loaded" || error_fatal "Oh no! Something happened to your internet! Exiting the Megascript, pleast fix your internet and try again!"


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
