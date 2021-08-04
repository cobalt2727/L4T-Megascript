#!/bin/bash

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d%03d\n", $1,$2,$3,$4,$5); }'; }

function install {
    echo "Retropie install script started!"
    echo
    echo "Downloading the files and installing needed dependencies..."
    sleep 3

    #download git
    apt install git dialog unzip xmlstarlet lsb-release crudini -y
    apt install joycond -y

    cd "/home/$SUDO_USER"
    sudo -u "$SUDO_USER" git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git

    #auto install retropie with most important emulators (which don't take up much space)
    cd RetroPie-Setup
    #pull latest version if already cloned
    sudo -u "$SUDO_USER" git pull --depth=1
    # unfortunatly I can't use this this not all main packages work ... ./retropie_packages.sh setup basic_install
    # manually install all of the required and good stuff

    sh -c "cat > /etc/sudoers.d/retropie_sudo << _EOF_
"$SUDO_USER" ALL = NOPASSWD: "/home/$SUDO_USER/RetroPie-Setup/retropie_setup.sh"
"$SUDO_USER" ALL = NOPASSWD: "/home/$SUDO_USER/RetroPie-Setup/retropie_packages.sh"
_EOF_"

    ./retropie_packages.sh retroarch
    ./retropie_packages.sh emulationstation-dev
    ./retropie_packages.sh retropiemenu
    ./retropie_packages.sh runcommand
    #./retropie_packages.sh ports-enable configure
    ./retropie_packages.sh mupen64plus
    ./retropie_packages.sh lr-duckstation
    ./retropie_packages.sh lzdoom
    # ./retropie_packages.sh scraper
    # ./retropie_packages.sh skyscraper
    # ./retropie_packages.sh usbromservice
	if [[ $jetson_model != "tegra-x1" ]]; then
        # only build from source on non-tegra-x1 systems
        ./retropie_packages.sh lr-atari800
        ./retropie_packages.sh lr-beetle-ngp
        ./retropie_packages.sh lr-beetle-pce-fast
        ./retropie_packages.sh lr-beetle-supergrafx
        ./retropie_packages.sh lr-bsnes
        ./retropie_packages.sh lr-caprice32
        ./retropie_packages.sh lr-desmume
        ./retropie_packages.sh lr-fbneo
        ./retropie_packages.sh lr-fceumm
        ./retropie_packages.sh lr-fuse
        ./retropie_packages.sh lr-flycast
        ./retropie_packages.sh lr-gambatte
        ./retropie_packages.sh lr-genesis-plus-gx
        ./retropie_packages.sh lr-gpsp
        ./retropie_packages.sh lr-handy
        ./retropie_packages.sh lr-mame
        ./retropie_packages.sh lr-mame2003
        ./retropie_packages.sh lr-mame2010
        ./retropie_packages.sh lr-mame2016
        ./retropie_packages.sh lr-mesen
        ./retropie_packages.sh lr-mgba
        ./retropie_packages.sh lr-mupen64plus-next
        ./retropie_packages.sh lr-nestopia
        ./retropie_packages.sh lr-parallel-n64
        ./retropie_packages.sh lr-pcsx-rearmed
        ./retropie_packages.sh lr-ppsspp
        ./retropie_packages.sh lr-prosystem
        ./retropie_packages.sh lr-quicknes
        ./retropie_packages.sh lr-smsplus-gx
        ./retropie_packages.sh lr-snes9x
        ./retropie_packages.sh lr-snes9x2005
        ./retropie_packages.sh lr-snes9x2010
        ./retropie_packages.sh lr-stella2014
        ./retropie_packages.sh lr-tgbdual
        ./retropie_packages.sh lr-vba-next
        ./retropie_packages.sh lr-vecx
        ./retropie_packages.sh lr-yabause	
	fi
}

function update_scripts {
    cd "/home/$SUDO_USER/RetroPie-Setup"
    sudo -u "$SUDO_USER" git pull --depth=1
    crudini --set '/opt/retropie/configs/all/runcommand.cfg' '' governor ' ""'
    echo "Finding all games installed and adding them to the Ports menu"
    sudo -u "$SUDO_USER" mkdir "/home/$SUDO_USER/.emulationstation/scripts"
    sudo -u "$SUDO_USER" mkdir "/home/$SUDO_USER/.emulationstation/scripts/quit"
    rm -rf "/home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh"
    sudo -u "$SUDO_USER" wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/add_games.sh" -O "/home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh"
    chmod 755 "/home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh"

    echo "Addding the Python .desktop image finder script"
    sudo -u "$SUDO_USER" wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/get-icon-path.py" -O "/home/$SUDO_USER/RetroPie/roms/ports/get-icon-path.py"
    chmod 755 "/home/$SUDO_USER/RetroPie/roms/ports/get-icon-path.py"

    echo "Running the auto game detection script"
    sudo -u "$SUDO_USER" "/home/$SUDO_USER/.emulationstation/scripts/quit/add_games.sh"

    if command -v dolphin-emu-nogui &> /dev/null; then
        echo "Adding dolphin standalone to retropie"
        sudo -u "$SUDO_USER" mkdir /opt/retropie/configs/gc
        sudo -u "$SUDO_USER" mkdir /opt/retropie/configs/wii
        sudo -u "$SUDO_USER" mkdir "/home/$SUDO_USER/RetroPie/roms/gc"
        sudo -u "$SUDO_USER" mkdir "/home/$SUDO_USER/RetroPie/roms/wii"
        LINE='dolphin-standalone = "dolphin-emu-nogui -e %ROM%"'
        FILE='/opt/retropie/configs/gc/emulators.cfg'
        FILE2='/opt/retropie/configs/wii/emulators.cfg'
        sudo -u "$SUDO_USER" grep -qFs -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
        sudo -u "$SUDO_USER" grep -qFs -- "$LINE" "$FILE2" || echo "$LINE" >> "$FILE2"
    fi

    sudo -E -u "$SUDO_USER" bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
}

function update_cores {
    cd "/home/$SUDO_USER/RetroPie-Setup"
    sudo -u "$SUDO_USER" git pull --depth=1
    ./retropie_packages.sh setup update_packages

    update_scripts
}

function install_binaries {
	if [[ $jetson_model == "tegra-x1" ]]; then
		mkdir -p /opt/retropie/libretrocores
		rm -rf "/tmp/Retropie-Binaries"
		sudo -u "$SUDO_USER" mkdir -p "/tmp/Retropie-Binaries"
		cd "/tmp/Retropie-Binaries"
		echo "Downloading Precompiled Binaries from the Megascript"
		echo "This could take a few seconds depending on the speed of your internet connection"
		sudo -E -u "$SUDO_USER" svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/RetroPie/Binaries/$jetson_model
		echo "Download Done"
		cd $jetson_model
		cd libretrocores
		cat ./*.tar.gz | tar zxvf - -i
		rm -rf ./*.tar.gz
		rm -rf ./*.pkg
		cp -R ./* /opt/retropie/libretrocores
		install_options=($(echo *))
		for install_selected in "${install_options[@]}"; do
			cd /home/$SUDO_USER/RetroPie-Setup
			/home/$SUDO_USER/RetroPie-Setup/retropie_packages.sh $install_selected depends
			/home/$SUDO_USER/RetroPie-Setup/retropie_packages.sh $install_selected configure
		done
		rm -rf "/tmp/Retropie-Binaries"
	else
		echo "We don't host binaries for your platform, sorry!"
	fi
}

if [ -z "$SUDO_USER" ]; then
    echo "RetroPie install failed, please run script as sudo"
else    
    clear -x
    echo "Your username is"
    echo "$SUDO_USER"
    if [[ $1 == "update_scripts" ]]; then
        update_scripts
    elif [[ $1 == "update_cores" ]]; then
        update_cores
    elif [[ $1 == "install_binaries" ]]; then
        install_binaries
    else
        install
        install_binaries
        update_scripts
    fi
fi
