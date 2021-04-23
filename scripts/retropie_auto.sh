#!/bin/bash

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d%03d\n", $1,$2,$3,$4,$5); }'; }

if [ -z "$SUDO_USER" ]; then
  echo "RetroPie install failed, please run script as sudo"
else
  clear
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
  rm -rf RetroPie-Setup
  sudo -u "$SUDO_USER" git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git

  #auto install retropie with most important emulators (which don't take up much space)
  cd RetroPie-Setup
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
  sudo -u "$SUDO_USER" cat >> /home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh <<'EOF'
param=("/usr/share/applications/" "$HOME/.local/share/applications/" "$HOME/.local/share/flatpack/exports/share/applications/" "/usr/local/share/applications/")
mkdir ~/RetroPie/roms/ports
cd ~/RetroPie/roms/ports
rm -rf list.txt
for (( j=0; j< "${#param[@]}"; j++));
do
	FILES=("${param[j]}"*.desktop)
	for (( i=0; i< "${#FILES[@]}"; i++));
	do
		if grep -i -P -e "^[Cc]ategories[=].*[Gg]ame.*" "${FILES[i]}"
		then
			if grep -i -P -e "^[Nn]o[Dd]isplay[=].*[Tt]rue.*" "${FILES[i]}"
			then
				echo ""
			else
				filename=$(echo ${FILES[i]} | grep -o ".*.desktop" | rev | cut -f 1 -d / | rev)
				filename=$(echo $filename | grep -oP '.*?(?=\.desktop)' | sed -e 's/ /_/g')
				echo 'nohup $(gtk-launch ' '"'"$line"'")' > $filename".sh"
				chmod +x $filename".sh"
				echo "$filename" >>list.txt
				path_var='./'"$filename"".sh"
				name_var=$(crudini --get "${FILES[i]}" "Desktop Entry" "name")
				if cat $HOME/.emulationstation/gamelists/ports/gamelist.xml | grep "$name_var"
				then
					echo ""
				else
					comment_var=$(crudini --get "${FILES[i]}" "Desktop Entry" "comment")
					image_var=$(crudini --get "${FILES[i]}" "Desktop Entry" "icon")
					if echo "$image_var" | grep '/';
					then
						echo "no python"
					else
						echo "python needed"
						image_var=$(./get-icon-path.py $image_var | tail -2)
					fi
					CONTENT="\t<game>\n\t<path>$path_var</path>\n\t\t<name>$name_var</name>\n\t\t<desc>$comment_var</desc>\n\t\t<image>$image_var</image>\n\t</game>"
					C=$(echo $CONTENT | sed 's/\//\\\//g')
					sed -i "/<\/gameList>/ s/.*/${C}\n&/" $HOME/.emulationstation/gamelists/ports/gamelist.xml
				fi
			fi
		fi
	done
done

rm -rf retropie.sh
EOF

  chmod 755 /home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh
  sudo -u "$SUDO_USER" /home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh

  echo "Addding the Python .desktop image finder script"

sudo -u "$SUDO_USER" cat >> /home/$SUDO_USER/RetroPie/roms/ports/get-icon-path.py <<'EOF'
#!/usr/bin/env python3
 
# ==========================================================================================
# This script is for looking up an icon file path based on the icon name from a *.desktop file.
# Parts of it are based on snippets provided by Stefano Palazzo and kiri on askubuntu.com
#   https://askubuntu.com/questions/52430/how-can-i-find-the-location-of-an-icon-of-a-launcher-in-use
# ==========================================================================================
# The original version(s) simply prompted the user for the icon name.
# However, I have modified this version in the following ways:
#   1. Added ability to pass specific size as arg (e.g. --size=22 or --size=48, etc)
#   2. Added ability to pass icon names as arg (any other arg besides --size)
#       Note: if --size is used with multiple icon names, then it is assummed
#             that all of the icons in the search will be for the same size
#   3. Like kiri's version, I removed the hard-coded size of 48x48 and default to all sizes
#   4. Unlike kiri's version, you can optionally still search for a specific size (using #1)
#   5. Performance improvements from kiri's version (he was checking every even number from
#       0 to 500 -- so 250 iterations. I base mine off the values that actually existing under
#       /etc/share/icons/hicolor - of which there were 17. So his is more flexible but
#       mine should be quicker and more forgiving in terms of HDD wear and tear)
# ==========================================================================================
 
import gi
import sys
import array as arr 
 
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
 
def resolveIconPath( iconName, iconSize = -1 ):
    "This takes a freedesktop.org icon name and prints the GTK 3.0 resolved file location."
 
    iconTheme = Gtk.IconTheme.get_default()
    
    # if looking up a specific size
    if iconSize >= 16:
        msgTemplate = "iconname: \"" + iconName + "\" (size: " + str(iconSize) + "): "
        
        iconFile = iconTheme.lookup_icon(iconName, iconSize, 0)
        if iconFile:
            print(msgTemplate + iconFile.get_filename() + "\n")
        else:
            print("W:" + msgTemplate + " No matching path(s) found.\n")
    else:
        # otherwise, look up *all* sizes that can be found
        sep="===================================================================="
        msgTemplate = sep + "\niconname: \"" + iconName + "\":\n" + sep
        
        foundIconsList = list()
        for resolution in [16, 20, 22, 24, 28, 32, 36, 48, 64, 72, 96, 128, 192, 256, 480, 512, 1024]:
            iconFile = iconTheme.lookup_icon(iconName, resolution, 0)
            if iconFile:
                filePath=str(iconFile.get_filename())
                if not (filePath in foundIconsList):
                    foundIconsList.append(iconFile.get_filename())
 
        if foundIconsList:
            print(msgTemplate + "\n"+ "\n".join(foundIconsList)+ "\n")
        else:
            print("W: iconname: \"" + iconName + "\":  No matching path(s) found.\n")
        return
 
 
# get the total number of args passed (excluding first arg which is the script name)
argumentsLen = len(sys.argv) - 1
 
# define a list for storing all passed icon names
iconNamesList = []
 
# loop through passed args, if we have any and handle appropriately
showHelp=False
size=-1
if argumentsLen > 0:
    for i in range(1, len(sys.argv)):
        arg=str(sys.argv[i])
        #print(i, "arg: " + arg)
        if arg.startswith('--size=') or arg.startswith('-s=') or arg.startswith('-S='):
            tmpSize=(arg.split("=",2))[1]
            if len(tmpSize) > 0 and tmpSize.isnumeric():
                size=int(tmpSize)
            else:
                print("Invalid size '" + tmpSize + "'; Expected --size=xx where xx is a positive integer.")
        elif arg == '--help' or arg == '-h':
            print(str(sys.argv[0]) + " [OPTIONS] [ICON_NAME]\n")
            print("Takes a freedesktop.org/GNOME icon name, as commonly appears in a *.desktop file,")
            print("and performs a lookup to determine matching filesystem path(s). By default, this")
            print("path resolution is determined for all available icon sizes. However, a specific")
            print("size can be used by providing one of the options below.\n")
            print("OPTIONS:")
            print("  -s=n, --size=n   Restricts path resolution to icons matching a specific size.")
            print("                   The value n must be a positive integer correspending to icon size.")
            print("                   When using this option with multiple passed icon names, the size")
            print("                   restrictions are applied to *all* of the resolved icons. Querying")
            print("                   different sizes for different icons is only possible via the use of")
            print("                   multiple calls or by parsing the default output.\n")
            print("  -h, --help       Display this help page and exit.\n")
            exit()
        else:
            iconNamesList.append(arg)
 
# if no icon names were passed on command line, then prompt user
if len(iconNamesList) == 0:
    iconNamesList.append(input("Icon name (case sensitive): "))
 
#print("size: " + str(size))
#print("iconNamesList: ")
if len(iconNamesList) > 0:
    for iconName in iconNamesList:
        if size < 16:
            # find all sizes (on my system, 16x16 was the smallest size icons under hicolor)
            resolveIconPath(iconName)
        else:
            # use custom size
            resolveIconPath(iconName, size)
EOF

  chmod 755 /home/$SUDO_USER/RetroPie/roms/ports/get-icon-path.py

  sdlv=$(dpkg -s libsdl2-dev | sed -n 's/Version: //p')
  sdlv=${sdlv/+/.}
  if [ $(version $sdlv) -ge $(version "2.0.10.5") ]; then
    echo ""
    echo "Already Installed Newest SDL2 Version"
    sleep 3
  else
    ./retropie_packages.sh sdl2
    echo ""
    echo "Successfully Installed Newest SDL2 Version"
    sleep 3
  fi
fi
