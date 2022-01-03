#!/bin/bash

clear -x
echo "Dolphin script started!"
sleep 1
cd ~
echo "Installing dependencies..."
sleep 1
sudo apt install --no-install-recommends ca-certificates qtbase5-dev qtbase5-private-dev git cmake make gcc g++ pkg-config udev libudev1 libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxi-dev libxrandr-dev libudev-dev libevdev-dev libsfml-dev libminiupnpc-dev libmbedtls-dev libcurl4-openssl-dev libhidapi-dev libsystemd-dev libbluetooth-dev libasound2-dev libpulse-dev libpugixml-dev libbz2-dev libzstd-dev liblzo2-dev libpng-dev libusb-1.0-0-dev gettext -y


echo "Downloading the source..."
git clone https://github.com/dolphin-emu/dolphin
cd dolphin
git pull

#https://dolphin-emu.org/blog/2021/07/21/integrated-gba/
git submodule update --init Externals/mGBA

mkdir -p build
cd build
rm -rf CMakeCache.txt
echo "Building..."
echo
#if you're looking at this script as a reference for building Dolphin on your own hardware,
#you can do "cmake .." and nothing else on the next line for a slight performance hit with a much faster build time

if grep -q bionic /etc/os-release; then
    
    echo "Ubuntu 18.04 detected, skipping LTO optimization..."
    echo "If that means nothing to you, don't worry about it."
    echo "That being said, we need to get you a newer compiler to prevent some bugs."
    #oddly enough the only *known* bug here is that emulated wii remote cursors don't work with GCC 7 builds
    echo "Adding Ubuntu Toolchain Test PPA to install GCC 11..."
    ppa_name="ubuntu-toolchain-r/test" && ppa_installer
    sudo apt install gcc-11 g++-11 -y
    echo "Alright, NOW we can start the building process."
    echo -e "\e[1;33mIf it freezes, especially around 80% or 100%, even for a few minutes, that's normal.\e[0m"
    sleep 10
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static" -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11
    
    elif grep -q xenial /etc/os-release; then
    
    #there really is no use case for this, is there
    echo "Ubuntu 16.04 detected... good luck, you'll need it"
    sleep 2
    echo "Adding Cmake 3.12 PPA..."
    ppa_name="janisozaur/cmake-update" && ppa_installer
    echo "Adding Ubuntu Toolchain Test PPA to install GCC 9..."
    ppa_name="ubuntu-toolchain-r/test" && ppa_installer
    sudo apt install cmake gcc-9 g++-9 -y
    echo "Alright, NOW we can start the building process."
    echo -e "\e[1;33mIf it freezes, especially around 80% or 100%, even for a few minutes, that's normal.\e[0m"
    sleep 10
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static" -DCMAKE_C_COMPILER=gcc-9 -DCMAKE_CXX_COMPILER=g++-9
    
    
    elif grep -q focal /etc/os-release; then
    
    echo "Ubuntu 20.04 detected..."
    echo "We need to get you a newer compiler to prevent some bugs."
    sudo apt install gcc-10 g++-10 -y
    echo "Alright, NOW we can start the building process."
    echo -e "\e[1;33mIf it freezes, especially around 80% or 100%, even for a few minutes, that's normal.\e[0m"
    sleep 10
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static" -DCMAKE_C_COMPILER=gcc-10 -DCMAKE_CXX_COMPILER=g++-10
    
else
    
    echo -e "\e[1;33mIf it freezes, especially around 80%, even for a few minutes, that's normal.\e[0m"
    sleep 10
    cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static"
    
fi




make -j$(nproc)
echo "Installing..."
sudo make install || error "Make install failed"
cd ~
#commenting out the below line since the first build takes way too long to do on weak hardware like the Switch
#leaving the source folder there will make future builds faster
##sudo rm -rf dolphin


if test -f /usr/bin/emulationstation; then
    echo "Found RetroPie installation - adding Dolphin entries"
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


echo "Done!"
echo "Sending you back to the main menu..."
sleep 2
