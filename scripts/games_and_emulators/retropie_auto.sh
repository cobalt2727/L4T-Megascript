#!/bin/bash

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d%03d\n", $1,$2,$3,$4,$5); }'; }

function install {
    echo "Retropie install script started!"
    echo
    echo "Downloading the files and installing needed dependencies..."
    sleep 3
    # get system info
    get_system
    #download git
    sudo apt install git dialog unzip xmlstarlet lsb-release crudini -y
    sudo apt install joycond -y

    cd ~
    git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git

    #auto install retropie with most important emulators (which don't take up much space)
    cd RetroPie-Setup
    #pull latest version if already cloned
    git pull --depth=1
    # unfortunatly I can't use this this not all main packages work ... sudo ./retropie_packages.sh setup basic_install
    # manually install all of the required and good stuff

    sudo sh -c "cat > /etc/sudoers.d/retropie_sudo << _EOF_
"$USER" ALL = NOPASSWD: "/home/$USER/RetroPie-Setup/retropie_setup.sh"
"$USER" ALL = NOPASSWD: "/home/$USER/RetroPie-Setup/retropie_packages.sh"
_EOF_"

    sudo ./retropie_packages.sh retroarch
    sudo ./retropie_packages.sh emulationstation-dev
    sudo ./retropie_packages.sh retropiemenu
    sudo ./retropie_packages.sh runcommand
    #sudo ./retropie_packages.sh ports-enable configure
    sudo ./retropie_packages.sh mupen64plus
    sudo ./retropie_packages.sh lr-duckstation
    sudo ./retropie_packages.sh lzdoom
    # sudo ./retropie_packages.sh scraper
    # sudo ./retropie_packages.sh skyscraper
    # sudo ./retropie_packages.sh usbromservice
    if [[ $jetson_model != "tegra-x1" ]]; then
        # only build from source on non-tegra-x1 systems
        sudo ./retropie_packages.sh lr-atari800
        sudo ./retropie_packages.sh lr-beetle-ngp
        sudo ./retropie_packages.sh lr-beetle-pce-fast
        sudo ./retropie_packages.sh lr-beetle-supergrafx
        sudo ./retropie_packages.sh lr-bsnes
        sudo ./retropie_packages.sh lr-caprice32
        sudo ./retropie_packages.sh lr-desmume
        sudo ./retropie_packages.sh lr-fbneo
        sudo ./retropie_packages.sh lr-fceumm
        sudo ./retropie_packages.sh lr-fuse
        sudo ./retropie_packages.sh lr-flycast
        sudo ./retropie_packages.sh lr-gambatte
        sudo ./retropie_packages.sh lr-genesis-plus-gx
        sudo ./retropie_packages.sh lr-gpsp
        sudo ./retropie_packages.sh lr-handy
        sudo ./retropie_packages.sh lr-mame
        sudo ./retropie_packages.sh lr-mame2003
        sudo ./retropie_packages.sh lr-mame2010
        sudo ./retropie_packages.sh lr-mame2016
        sudo ./retropie_packages.sh lr-mesen
        sudo ./retropie_packages.sh lr-mgba
        sudo ./retropie_packages.sh lr-mupen64plus-next
        sudo ./retropie_packages.sh lr-nestopia
        sudo ./retropie_packages.sh lr-parallel-n64
        sudo ./retropie_packages.sh lr-pcsx-rearmed
        sudo ./retropie_packages.sh lr-ppsspp
        sudo ./retropie_packages.sh lr-prosystem
        sudo ./retropie_packages.sh lr-quicknes
        sudo ./retropie_packages.sh lr-smsplus-gx
        sudo ./retropie_packages.sh lr-snes9x
        sudo ./retropie_packages.sh lr-snes9x2005
        sudo ./retropie_packages.sh lr-snes9x2010
        sudo ./retropie_packages.sh lr-stella2014
        sudo ./retropie_packages.sh lr-tgbdual
        sudo ./retropie_packages.sh lr-vba-next
        sudo ./retropie_packages.sh lr-vecx
        sudo ./retropie_packages.sh lr-yabause	
    fi
}

function update_scripts {
    cd "/home/$USER/RetroPie-Setup"
    git pull --depth=1
    sudo crudini --set '/opt/retropie/configs/all/runcommand.cfg' '' governor ' ""'
    echo "Finding all games installed and adding them to the Ports menu"
    mkdir "/home/$USER/.emulationstation/scripts"
    mkdir "/home/$USER/.emulationstation/scripts/quit"
    sudo rm -rf "/home/$USER/.emulationstation/scripts/quit/add_games.sh"
    wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/add_games.sh" -O "/home/$USER/.emulationstation/scripts/quit/add_games.sh"
    sudo chmod 755 "/home/$USER/.emulationstation/scripts/quit/add_games.sh"

    echo "Addding the Python .desktop image finder script"
    wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/get-icon-path.py" -O "/home/$USER/RetroPie/roms/ports/get-icon-path.py"
    sudo chmod 755 "/home/$USER/RetroPie/roms/ports/get-icon-path.py"

    echo "Running the auto game detection script"
    "/home/$USER/.emulationstation/scripts/quit/add_games.sh"

    if command -v dolphin-emu-nogui &> /dev/null; then
        echo "Adding dolphin standalone to retropie"
        mkdir /opt/retropie/configs/gc
        mkdir /opt/retropie/configs/wii
        mkdir "/home/$USER/RetroPie/roms/gc"
        mkdir "/home/$USER/RetroPie/roms/wii"
        LINE='dolphin-standalone = "dolphin-emu-nogui -e %ROM%"'
        FILE='/opt/retropie/configs/gc/emulators.cfg'
        FILE2='/opt/retropie/configs/wii/emulators.cfg'
        grep -qFs -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
        grep -qFs -- "$LINE" "$FILE2" || echo "$LINE" >> "$FILE2"
    fi

    bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
}

function update_cores {
    cd "/home/$USER/RetroPie-Setup"
    git pull --depth=1
    sudo ./retropie_packages.sh setup update_packages

    update_scripts
}

function install_binaries {
    # get system info
    get_system
	if [[ $jetson_model == "tegra-x1" ]]; then
		sudo mkdir -p /opt/retropie/libretrocores
		sudo rm -rf "/tmp/Retropie-Binaries"
		mkdir -p "/tmp/Retropie-Binaries"
		cd "/tmp/Retropie-Binaries"
		echo "Downloading Precompiled Binaries from the Megascript"
		echo "This could take a few seconds depending on the speed of your internet connection"
		svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/RetroPie/Binaries/$jetson_model
		echo "Download Done"
		cd $jetson_model
		cd libretrocores
		cat ./*.tar.gz | tar zxvf - -i
		rm -rf ./*.tar.gz
		rm -rf ./*.pkg
		sudo cp -R ./* /opt/retropie/libretrocores
		install_options=($(echo *))
		for install_selected in "${install_options[@]}"; do
			cd /home/$USER/RetroPie-Setup
			sudo /home/$USER/RetroPie-Setup/retropie_packages.sh $install_selected depends
			sudo /home/$USER/RetroPie-Setup/retropie_packages.sh $install_selected configure
		done
		sudo rm -rf "/tmp/Retropie-Binaries"
	else
		echo "We don't host binaries for your platform, sorry!"
	fi
}

if [ -z "$SUDO_USER" ]; then
    clear -x
    echo "Your username is"
    echo "$USER"
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
else    
    echo "RetroPie install failed, please run script as non-sudo"    
fi
