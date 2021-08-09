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
    git clone https://github.com/RetroPie/RetroPie-Setup.git

    cd RetroPie-Setup
    # pull latest version if already cloned
    git pull
    if [[ $? -ne 0 ]]; then
        cd ~
        rm -rf RetroPie-Setup
        git clone https://github.com/RetroPie/RetroPie-Setup.git
        cd ~/RetroPie-Setup
    fi
    # unfortunatly I can't use this this not all main packages work ... sudo ./retropie_packages.sh setup basic_install
    # manually install all of the required and good stuff

    sudo sh -c "cat > /etc/sudoers.d/retropie_sudo << _EOF_
"$USER" ALL = NOPASSWD: "/home/$USER/RetroPie-Setup/retropie_setup.sh"
"$USER" ALL = NOPASSWD: "/home/$USER/RetroPie-Setup/retropie_packages.sh"
_EOF_"

    #auto install retropie with most important emulators (which don't take up much space)
    sudo ./retropie_packages.sh retroarch
    sudo ./retropie_packages.sh emulationstation-dev
    sudo ./retropie_packages.sh retropiemenu
    sudo ./retropie_packages.sh runcommand
    sudo ./retropie_packages.sh joy2key
    #sudo ./retropie_packages.sh ports-enable configure
    sudo ./retropie_packages.sh mupen64plus
    sudo ./retropie_packages.sh lr-duckstation
    sudo ./retropie_packages.sh lzdoom
    # sudo ./retropie_packages.sh scraper
    # sudo ./retropie_packages.sh skyscraper
    # sudo ./retropie_packages.sh usbromservice
    if [[ $jetson_model != "tegra-x1" ]]; then
        # only build from source on non-tegra-x1 systems
        # if executed on the PI, this shoud still install binaries for those systems
        package_list=( lr-atari800 lr-beetle-ngp lr-beetle-supergrafx lr-bsnes \
lr-caprice32 lr-desmume lr-fbneo lr-fceumm lr-flycast lr-fuse \
lr-gambatte lr-genesis-plus-gx lr-gpsp lr-handy lr-mame lr-mame2003 \
lr-mame2010 lr-mame2016 lr-mesen lr-mgba lr-mupen64plus-next lr-nestopia \
lr-pcsx-rearmed lr-ppsspp lr-prosystem lr-quicknes lr-smsplus-gx \
lr-stella2014 lr-snes9x lr-snes9x2005 lr-snes9x2010 lr-vba-next lr-vecx \
lr-tgbdual lr-yabause )
        for package in ${package_list[@]}; do
            sudo ./retropie_packages.sh $package
        done
    fi
}

function update_scripts {
    cd "/home/$USER/RetroPie-Setup"
    git pull
    if [[ $? -ne 0 ]]; then
        cd ~
        rm -rf RetroPie-Setup
        git clone https://github.com/RetroPie/RetroPie-Setup.git
        cd ~/RetroPie-Setup
    fi
    sudo crudini --set '/opt/retropie/configs/all/runcommand.cfg' '' governor ' ""'
    echo "Finding all games installed and adding them to the Ports menu"
    mkdir -p "/home/$USER/.emulationstation/scripts/quit"
    rm -rf /tmp/add_games.sh
    wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/add_games.sh" -O /tmp/add_games.sh && sudo rm -rf  "/home/$USER/.emulationstation/scripts/quit/add_games.sh" && mv  /tmp/add_games.sh "/home/$USER/.emulationstation/scripts/quit/add_games.sh"
    sudo chmod 755 "/home/$USER/.emulationstation/scripts/quit/add_games.sh"

    echo "Addding the Python .desktop image finder script"
    rm -rf /tmp/get-icon-path.py
    mkdir -p "/home/$USER/RetroPie/roms/ports"
    wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/get-icon-path.py" -O /tmp/get-icon-path.py && sudo rm -rf "/home/$USER/RetroPie/roms/ports/get-icon-path.py" && mv /tmp/get-icon-path.py "/home/$USER/RetroPie/roms/ports/get-icon-path.py"
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
    git pull
    if [[ $? -ne 0 ]]; then
        cd ~
        rm -rf RetroPie-Setup
        git clone https://github.com/RetroPie/RetroPie-Setup.git
        cd ~/RetroPie-Setup
    fi
    sudo ./retropie_packages.sh setup update_packages
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
        update_scripts
    elif [[ $1 == "install_binaries" ]]; then
        install_binaries
        update_scripts
    else
        install
        install_binaries
        update_scripts
    fi
else    
    echo "RetroPie install failed, please run script as non-sudo"    
fi
