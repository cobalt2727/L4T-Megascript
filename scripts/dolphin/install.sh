clear
echo "Dolphin script started!"
sleep 1

if grep -q bionic /etc/os-release; then
	echo "Ubuntu 18.04 detected, using the PPA..."
    
    echo "Making sure software-properties-common is installed..."
    sudo apt install software-properties-common -y

    echo "Making sure the Dolphin PPA is installed..."
    sudo apt-add-repository ppa:dolphin-emu/ppa -y

    sudo apt update
    sudo apt install dolphin-emu-master -y

else
	echo "Building from source with device-specific optimizations..."

    cd ~
    echo "Installing dependencies..."
    sleep 1
    sudo apt update
    sudo apt install git cmake ffmpeg libavcodec-dev libevdev-dev libusb-1.0-0-dev libavformat-dev libswscale-dev libsfml-dev libminiupnpc-dev libmbedtls-dev curl libhidapi-dev libpangocairo-1.0-0 libgtk2.0-dev libbluetooth-dev qt5-default qtbase5-private-dev libudev-dev portaudio19-dev libavutil-dev libxrandr-dev libxi-dev  -y
    echo "Downloading the source..."
    git clone https://github.com/dolphin-emu/dolphin
    cd dolphin
    mkdir build && cd build
    echo "Building..."
    cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native -DCMAKE_C_FLAGS_INIT="-static"
    make -j$(nproc)
    echo "Installing..."
    sudo make install
    #wget any game-specific configs, maybe autolaunch stuff like Wii sports with real Wii remotes forced on by default
    cd ../..
    sudo rm -rf dolphin
fi
echo "Done!"
echo "Sending you back to the main menu..."
sleep 2
