#!/bin/bash

clear -x
echo "Dolphin script started!"
sleep 1
cd ~
echo "Installing dependencies..."
sleep 1

#acquire system info for use in scripts - see functions.sh for info
get_system

case "$__os_id" in
    Raspbian|Debian|LinuxMint|Linuxmint|Ubuntu|[Nn]eon|Pop|Zorin|[eE]lementary|[jJ]ing[Oo][sS])
        sudo apt install --no-install-recommends ca-certificates qtbase5-dev qtbase5-private-dev git cmake make gcc g++ pkg-config udev libudev1 libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxi-dev libxrandr-dev libevdev-dev libsfml-dev libminiupnpc-dev libmbedtls-dev libcurl4-openssl-dev libhidapi-dev libbluetooth-dev libasound2-dev libpulse-dev libpugixml-dev libbz2-dev libzstd-dev liblzo2-dev libpng-dev libusb-1.0-0-dev gettext -y || error "Failed to install dependencies!"
        
        #the following lines attempt to handle issues with installing on distros without systemd (namely AntiX)
        package_available libudev-dev #this will install on mainstream distros
        if [[ $? == "0" ]]; then
          sudo apt install -y libudev-dev || error "Failed to install udev development libraries!"
        fi
        package_available libsystemd-dev #this will also install on mainstream distros, install both this and libudev-dev if you're using this as a reference
        if [[ $? == "0" ]]; then
          sudo apt install -y libsystemd-dev || error "Failed to install systemd development libraries!"
        fi
        package_available libeudev-dev #this is a udev replacement that works without systemd, you can't even install it on a regular Debian/Ubuntu spin
        if [[ $? == "0" ]]; then
          sudo apt install -y libeudev-dev || error "Failed to install eudev development libraries!"
        fi
    ;;
    Fedora)
        sudo dnf install -y vulkan-loader vulkan-loader-devel cmake git gcc-c++ libXext-devel libgudev qt5-qtbase-devel qt5-qtbase-private-devel systemd-devel openal-soft-devel libevdev-devel libao-devel SOIL-devel libXrandr-devel pulseaudio-libs-devel bluez-libs-devel libusb-devel libXi-devel || error "Failed to install dependencies!"
    ;;
    *)
        echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install necessary dependencies yourself following https://wiki.dolphin-emu.org/index.php?title=Building_Dolphin_on_Linux if you haven't already...\\e[39m"
        sleep 5
    ;;
esac

echo "Downloading the source..."
git clone https://github.com/dolphin-emu/dolphin
cd dolphin
git pull || error_user "Failed to download source code from GitHub!"

#https://dolphin-emu.org/blog/2021/07/21/integrated-gba/
git submodule update --init Externals/mGBA || error_user "Failed to download source code from GitHub!"
git submodule update --init Externals/spirv_cross || error_user "Failed to download source code from GitHub!"
git submodule update --init Externals/zlib-ng || error_user "Failed to download source code from GitHub!"
git submodule update --init Externals/libspng || error_user "Failed to download source code from GitHub!"

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
    #to be fair, the only *known* bug here (for now) is that emulated Wii remote cursors don't work with GCC 7 builds
    echo "Adding Ubuntu Toolchain Test PPA to install GCC 11..."
    ppa_name="ubuntu-toolchain-r/test" && ppa_installer
    sudo apt install gcc-11 g++-11 -y || error "Failed to install dependencies!"
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
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static" -DCMAKE_C_COMPILER=gcc-9 -DCMAKE_CXX_COMPILER=g++-9 || error "We'll still take this error report, but PLEASE upgrade your system."
    
    
    elif grep -q focal /etc/os-release; then
    
    echo "Ubuntu 20.04 detected..."
    echo "We need to get you a newer compiler to prevent some bugs."
    sudo apt install gcc-10 g++-10 -y || error "Failed to install dependencies!"
    echo "Alright, NOW we can start the building process."
    echo -e "\e[1;33mIf it freezes, especially around 80% or 100%, even for a few minutes, that's normal.\e[0m"
    sleep 10
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static" -DCMAKE_C_COMPILER=gcc-10 -DCMAKE_CXX_COMPILER=g++-10
    
else
    
    echo -e "\e[1;33mIf it freezes, especially around 80%, even for a few minutes, that's normal.\e[0m"
    sleep 10
    cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -DCMAKE_C_FLAGS_INIT="-static"
    
fi

if test -d /usr/include/*-linux-gnu/qt6/; then
    echo "QT6 packages found - since Dolphin will default to this when possible,"
    echo "We'll need to install relevant dependencies..."
    sleep 1
    package_available qt6-base-private-dev
    if [[ $? == "0" ]]; then
        sudo apt install -y qt6-base-private-dev || error "Failed to install QT6 dependencies!"
    else
        error "Unknown error occurred..."
    fi
fi

make -j$(nproc) || error "Make failed!"
echo "Installing..."
sudo make install || error "Make install failed!"

# FIXME: remove incompatible libs until dolphin bug is solved (causes issues with MultiMC and potentially other applications too)
sudo rm /usr/local/lib/libz.a /usr/local/include/zlib.h /usr/local/include/zlib_name_mangling.h /usr/local/include/zconf.h /usr/local/lib/pkgconfig/zlib.pc
hash -r

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
