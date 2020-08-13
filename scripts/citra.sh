clear
echo "Citra script successfully started!"
sleep 1

sudo apt update -y

sudo apt-get install libsdl2-2.0-0 libsdl2-dev qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev libfdk-aac-dev build-essential cmake ffmpeg libswscale-dev libavdevice57 libavformat-dev libavcodec-dev libavdevice-dev -y

cd ~
git clone --recursive https://github.com/citra-emu/citra
cd citra
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
cd ~
sudo rm -rf citra
