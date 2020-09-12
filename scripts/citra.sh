if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
clear
echo "Citra script successfully started!"
echo "Credits: i literally just took https://citra-emu.org/wiki/building-for-linux/ and made it run by itself"
sleep 3

echo "Running updates..."
sleep 1
apt update -y

echo "Installing dependencies..."
sleep 1
apt-get install libsdl2-2.0-0 libsdl2-dev qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev libfdk-aac-dev build-essential cmake ffmpeg libswscale-dev libavdevice57 libavformat-dev libavcodec-dev libavdevice-dev -y

echo "Building Citra..."
sleep 1
cd ~
git clone --recursive https://github.com/citra-emu/citra
cd citra
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
make install

echo "Removing build files..."
sleep 1
cd ~
rm -rf citra

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
