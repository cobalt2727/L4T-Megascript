#!/bin/bash

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d%03d\n", $1,$2,$3,$4,$5); }'; }

if [ -z "$SUDO_USER" ]; then
  echo "RetroPie install failed, please run script as sudo"
else
  clear -x
  echo "Your username is"
  echo $SUDO_USER
  
  echo "Retropie script started!"
  echo
  echo "Downloading the files and installing needed dependencies..."
  sleep 3

  #download git
  apt install git dialog unzip xmlstarlet lsb-release crudini -y
  apt install joycond -y

  cd /home/$SUDO_USER
  sudo -u "$SUDO_USER" git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git

  #auto install retropie with most important emulators (which don't take up much space)
  cd RetroPie-Setup
  #pull latest version if already cloned
  sudo -u "$SUDO_USER" git pull --depth=1
  # unfortunatly I can't use this this not all main packages work ... ./retropie_packages.sh setup basic_install
  # manually install all of the required and good stuff

  sh -c "cat > /etc/sudoers.d/retropie_sudo << _EOF_
$SUDO_USER ALL = NOPASSWD: /home/$SUDO_USER/RetroPie-Setup/retropie_setup.sh
$SUDO_USER ALL = NOPASSWD: /home/$SUDO_USER/RetroPie-Setup/retropie_packages.sh
_EOF_"

  ./retropie_packages.sh retroarch
  ./retropie_packages.sh emulationstation-dev
  ./retropie_packages.sh retropiemenu
  ./retropie_packages.sh runcommand
  #./retropie_packages.sh ports-enable configure
  ./retropie_packages.sh mupen64plus
  ./retropie_packages.sh lr-mupen64plus-next
  ./retropie_packages.sh lr-atari800
  ./retropie_packages.sh lr-beetle-ngp
  ./retropie_packages.sh lr-beetle-pce-fast
  ./retropie_packages.sh lr-beetle-supergrafx
  # ./retropie_packages.sh lr-beetle-saturn
  ./retropie_packages.sh lr-bsnes
  ./retropie_packages.sh lr-desmume
  # ./retropie_packages.sh lr-desmume2015
  ./retropie_packages.sh lr-fbneo
  ./retropie_packages.sh lr-fceumm
  ./retropie_packages.sh lr-flycast
  ./retropie_packages.sh lr-gambatte
  ./retropie_packages.sh lr-genesis-plus-gx
  ./retropie_packages.sh lr-handy
  #./retropie_packages.sh lr-mame
  # ./retropie_packages.sh lr-mame2003
  # ./retropie_packages.sh lr-mame2010
  # ./retropie_packages.sh lr-mame2016
  # ./retropie_packages.sh lr-mesen
  ./retropie_packages.sh lr-mgba
  ./retropie_packages.sh lr-nestopia
  ./retropie_packages.sh lr-pcsx-rearmed
  ./retropie_packages.sh lr-ppsspp
  ./retropie_packages.sh lr-prosystem
  ./retropie_packages.sh lr-quicknes
  ./retropie_packages.sh lr-smsplus-gx
  ./retropie_packages.sh lr-stella2014
  ./retropie_packages.sh lr-vba-next
  ./retropie_packages.sh lr-vecx
  ./retropie_packages.sh lr-tgbdual
  ./retropie_packages.sh lr-snes9x
  # ./retropie_packages.sh lr-yabasanshiro
  ./retropie_packages.sh lr-yabause
  ./retropie_packages.sh lzdoom
  # ./retropie_packages.sh scraper
  # ./retropie_packages.sh skyscraper
  # ./retropie_packages.sh usbromservice

  crudini --set '/opt/retropie/configs/all/runcommand.cfg' '' governor ' ""'
  echo "Finding all games installed and adding them to the Ports menu"
  sudo -u "$SUDO_USER" mkdir /home/$SUDO_USER/.emulationstation/scripts
  sudo -u "$SUDO_USER" mkdir /home/$SUDO_USER/.emulationstation/scripts/quit
  rm -rf /home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh
  sudo -u "$SUDO_USER" wget https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/add_games.sh /home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh

  chmod 755 /home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh
  sudo -u "$SUDO_USER" /home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh

  echo "Addding the Python .desktop image finder script"
  sudo -u "$SUDO_USER" wget https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/get-icon-path.py /home/$SUDO_USER/RetroPie/roms/ports/get-icon-path.py

  chmod 755 /home/$SUDO_USER/RetroPie/roms/ports/get-icon-path.py

  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
fi
