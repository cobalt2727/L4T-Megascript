#!/bin/bash

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d%03d\n", $1,$2,$3,$4,$5); }'; }

function install {
    status_green "Retropie install script started!"
    echo
    status "Downloading the files and installing needed dependencies..."
    sleep 3
    # get system info
    get_system
    #download git
    sudo apt install git dialog unzip xmlstarlet lsb-release crudini -y || error "Could not install dependencies"
    sudo apt install joycond -y

    cd ~
    git clone https://github.com/RetroPie/RetroPie-Setup.git

    cd RetroPie-Setup
    # pull latest version if already cloned
    git pull
    if [[ $? -ne 0 ]]; then
        cd ~
        sudo rm -rf RetroPie-Setup
        git clone https://github.com/RetroPie/RetroPie-Setup.git || error "Could Not Pull Latest Source Code"
        cd ~/RetroPie-Setup
    fi
    # unfortunatly I can't use this this not all main packages work ... sudo ./retropie_packages.sh setup basic_install
    # manually install all of the required and good stuff

    sudo sh -c "cat > /etc/sudoers.d/retropie_sudo << _EOF_
"$USER" ALL = NOPASSWD: "/home/$USER/RetroPie-Setup/retropie_setup.sh"
"$USER" ALL = NOPASSWD: "/home/$USER/RetroPie-Setup/retropie_packages.sh"
"$USER" ALL = NOPASSWD: "/sbin/shutdown"
_EOF_"

    #auto install retropie with most important emulators (which don't take up much space)
    sudo ./retropie_packages.sh retroarch
    sudo ./retropie_packages.sh emulationstation
    sudo ./retropie_packages.sh retropiemenu
    sudo ./retropie_packages.sh runcommand
    sudo ./retropie_packages.sh joy2key
    #sudo ./retropie_packages.sh ports-enable configure
    sudo ./retropie_packages.sh mupen64plus
    # sudo ./retropie_packages.sh lr-duckstation
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

    # update sudoers
    sudo sh -c "cat > /etc/sudoers.d/retropie_sudo << _EOF_
"$USER" ALL = NOPASSWD: "/home/$USER/RetroPie-Setup/retropie_setup.sh"
"$USER" ALL = NOPASSWD: "/home/$USER/RetroPie-Setup/retropie_packages.sh"
"$USER" ALL = NOPASSWD: "/sbin/shutdown"
_EOF_"

    # add builtin updater into retropie
    mkdir -p "/home/$USER/RetroPie/retropiemenu"
    wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/L4T-Megascript-RetroPie-Updater.sh" -O /tmp/L4T-Megascript-RetroPie-Updater.sh && sudo rm -rf "/home/$USER/RetroPie/retropiemenu/L4T-Megascript-RetroPie-Updater.sh" && mv /tmp/L4T-Megascript-RetroPie-Updater.sh "/home/$USER/RetroPie/retropiemenu/L4T-Megascript-RetroPie-Updater.sh"
    chmod +x "/home/$USER/RetroPie/retropiemenu/L4T-Megascript-RetroPie-Updater.sh"


    config="$HOME/.emulationstation/gamelists/retropie/gamelist.xml"
    path="./L4T-Megascript-RetroPie-Updater.sh"
    name="L4T-Megascript RetroPie Binaries Updater"
    desc="This script automatically updates the L4T-Megascript supplied RetroPie binaries if necessary. It functions just like updating the binaries through the L4T-Megascript Updater script."
    image="/usr/share/icons/L4T-Megascript.png"
    if [[ ! -f "$config" ]]; then
        echo "<gameList />" >"$config"
    fi

    if [[ $(xmlstarlet sel -t -v "count(/gameList/game[path='$path'])" "$config") -eq 0 ]]; then
        echo "Adding updater info to gamelist"
        xmlstarlet ed -L -s "/gameList" -t elem -n "game" -v "" \
                -s "/gameList/game[last()]" -t elem -n "path" -v "$path" \
                -s "/gameList/game[last()]" -t elem -n "name" -v "$name" \
                -s "/gameList/game[last()]" -t elem -n "desc" -v "$desc" \
                -s "/gameList/game[last()]" -t elem -n "image" -v "$image" \
                "$config"
    else
        echo "Updating updater info in gamelist"
        # remove current occurances of name, desc, and image
        xmlstarlet ed -L -d "/gameList/game[path='$path']/name" -d "/gameList/game[path='$path']/desc" -d "/gameList/game[path='$path']/image" "$config"

        # add name, desc, and image
        xmlstarlet ed -L \
                -s "/gameList/game[path='$path']" -t elem -n "name" -v "$name" \
                -s "/gameList/game[path='$path']" -t elem -n "desc" -v "$desc" \
                -s "/gameList/game[path='$path']" -t elem -n "image" -v "$image" \
                "$config"
    fi

    cd "/home/$USER/RetroPie-Setup"
    git pull
    if [[ $? -ne 0 ]]; then
        cd ~
        rm -rf RetroPie-Setup
        git clone https://github.com/RetroPie/RetroPie-Setup.git || error "Could Not Pull Latest Source Code"
        cd ~/RetroPie-Setup
    fi
    sudo crudini --set '/opt/retropie/configs/all/runcommand.cfg' '' governor ' ""'
    status "Finding all games installed and adding them to the Ports menu"
    mkdir -p "/home/$USER/.emulationstation/scripts/quit"
    rm -rf /tmp/add_games.sh
    wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/add_games.sh" -O /tmp/add_games.sh && sudo rm -rf  "/home/$USER/.emulationstation/scripts/quit/add_games.sh" && mv  /tmp/add_games.sh "/home/$USER/.emulationstation/scripts/quit/add_games.sh"
    sudo chmod 755 "/home/$USER/.emulationstation/scripts/quit/add_games.sh"

    status "Addding the Python .desktop image finder script"
    rm -rf /tmp/get-icon-path.py
    mkdir -p "/home/$USER/RetroPie/roms/ports"
    wget "https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/RetroPie/get-icon-path.py" -O /tmp/get-icon-path.py && sudo rm -rf "/home/$USER/RetroPie/roms/ports/get-icon-path.py" && mv /tmp/get-icon-path.py "/home/$USER/RetroPie/roms/ports/get-icon-path.py"
    sudo chmod 755 "/home/$USER/RetroPie/roms/ports/get-icon-path.py"

    status "Running the auto game detection script"
    "/home/$USER/.emulationstation/scripts/quit/add_games.sh"

    # hotfix for switch/jetsons emulationstation crash and vlc player broken
    get_system
    if [[ $jetson_model ]]; then
        sudo mv /usr/lib/aarch64-linux-gnu/vlc/plugins/codec/libomxil_plugin.so /usr/lib/aarch64-linux-gnu/vlc/plugins/codec/libomxil_plugin.so.old
    fi    

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

        config="/etc/emulationstation/es_systems.cfg"
        if [[ ! -f "$config" ]]; then
            echo "<systemList />" | sudo tee "$config"
        fi
        homedir=~
        if [[ $(xmlstarlet sel -t -v "count(/systemList/system[name='gc'])" "$config") -eq 0 ]]; then
        sudo xmlstarlet ed -L -s "/systemList" -t elem -n "system" -v "" \
                    -s "/systemList/system[last()]" -t elem -n "name" -v "gc" \
                    -s "/systemList/system[last()]" -t elem -n "fullname" -v "Nintendo GameCube" \
                    -s "/systemList/system[last()]" -t elem -n "path" -v "$homedir/RetroPie/roms/gc" \
                    -s "/systemList/system[last()]" -t elem -n "extension" -v ".ciso .gcm .gcz .iso .rv" \
                    -s "/systemList/system[last()]" -t elem -n "command" -v '/opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ gc %ROM%' \
                    -s "/systemList/system[last()]" -t elem -n "platform" -v 'gc' \
                    -s "/systemList/system[last()]" -t elem -n "theme" -v 'gc' \
                    "$config"
        fi
        
        if [[ $(xmlstarlet sel -t -v "count(/systemList/system[name='wii'])" "$config") -eq 0 ]]; then
        sudo xmlstarlet ed -L -s "/systemList" -t elem -n "system" -v "" \
                    -s "/systemList/system[last()]" -t elem -n "name" -v "wii" \
                    -s "/systemList/system[last()]" -t elem -n "fullname" -v "Nintendo Wii" \
                    -s "/systemList/system[last()]" -t elem -n "path" -v "$homedir/RetroPie/roms/wii" \
                    -s "/systemList/system[last()]" -t elem -n "extension" -v ".gcm .iso .wbfs .ciso .gcz" \
                    -s "/systemList/system[last()]" -t elem -n "command" -v '/opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ wii %ROM%' \
                    -s "/systemList/system[last()]" -t elem -n "platform" -v 'wii' \
                    -s "/systemList/system[last()]" -t elem -n "theme" -v 'wii' \
                    "$config"
        fi

    fi

    bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)"
}

function update_cores {
    cd "/home/$USER/RetroPie-Setup"
    git pull
    if [[ $? -ne 0 ]]; then
        cd ~
        sudo rm -rf RetroPie-Setup
        git clone https://github.com/RetroPie/RetroPie-Setup.git || error "Could Not Pull Latest Source Code"
        cd ~/RetroPie-Setup
    fi
    sudo ./retropie_packages.sh setup update_packages
}

function install_binaries {
    # get system info
    get_system
	if [[ $jetson_model == "tegra-x1" ]]; then
		sudo rm -rf "/tmp/Retropie-Binaries"
		mkdir -p "/tmp/Retropie-Binaries"
		cd "/tmp/Retropie-Binaries"
        mkdir $jetson_model
        cd $jetson_model
        repo_folders=($( svn ls https://github.com/theofficialgman/RetroPie-Binaries/trunk/Binaries/$jetson_model/ ))
        for folder in ${repo_folders[@]}; do
            if [[ $folder == */ ]]; then
                folder=${folder::-1}
                status "Downloading Precompiled Binaries version info from Megascript for $folder"
                repo_files=($( svn ls https://github.com/theofficialgman/RetroPie-Binaries/trunk/Binaries/$jetson_model/$folder/ ))
                mkdir $folder
                cd $folder
                sudo mkdir -p /opt/retropie/$folder
                package_list=()
                package_url_list=()
                for package in ${repo_files[@]}; do
                    if [[ $package == *.pkg ]]; then
                        package_url_list+=(https://raw.githubusercontent.com/theofficialgman/RetroPie-Binaries/master/Binaries/$jetson_model/$folder/$package)
                        package_list+=($package)
                    fi
                done
                wget -nv ${package_url_list[@]} --progress=bar:force:noscroll
                status "Downloading Precompiled Binaries from the Megascript if newer than local for $folder"
                status "This could take a few seconds depending on the speed of your internet connection"
                for package in ${package_list[@]}; do
                    package=$(echo "${package%.pkg}")
                    repo_binary_date=$(cat $package.pkg | grep "pkg_repo_date" | sed 's/^.*=//' | tr -d '"')
                    repo_binary_date=$(date -d $repo_binary_date +%s)
                    local_binary_date=$(cat /opt/retropie/$folder/$package/retropie.pkg | grep "pkg_repo_date" | sed 's/^.*=//' | tr -d '"')
                    local_binary_date=$(date -d $local_binary_date +%s)
                    if [[ $repo_binary_date -gt $local_binary_date ]] || ([[ $repo_binary_date == $local_binary_date ]] && ! diff "/opt/retropie/$folder/$package/retropie.pkg" "$package"); then
                        # only download and extract package if it is newer than local version or if equal to local version with later build date
                        wget https://raw.githubusercontent.com/theofficialgman/RetroPie-Binaries/master/Binaries/$jetson_model/$folder/$package.tar.gz --progress=bar:force:noscroll
                        cat ./$package.tar.gz | tar zxvf - -i
                        status_green "The compiled binary for $package is newer, updating local binary"
                        sudo cp -R ./$package /opt/retropie/$folder
                        current_dir="$(pwd)"
                        cd /home/$USER/RetroPie-Setup
                        sudo /home/$USER/RetroPie-Setup/retropie_packages.sh $package depends
                        sudo /home/$USER/RetroPie-Setup/retropie_packages.sh $package configure
                        cd "$current_dir"
                    else
                        status "nothing to be done, local version of $package is newer or the same version as the megascript package"
                    fi
                    rm -rf ./$package.tar.gz
                    rm -rf ./$package.pkg
                    rm -rf ./$package
                done
            fi
        done
        cd ~
		sudo rm -rf "/tmp/Retropie-Binaries"
	else
		warning "We don't host binaries for your platform, sorry!"
	fi
}

if [ $(id -u) != 0 ]; then
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
