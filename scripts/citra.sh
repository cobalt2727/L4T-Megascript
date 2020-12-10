clear
echo "Citra script successfully started!"
echo "Credits: i literally just took https://citra-emu.org/wiki/building-for-linux/ and made it run by itself"
sleep 3

echo "Running updates..."
sleep 1
sudo apt update -y

echo "Installing dependencies..."
sleep 1
sudo apt-get install git ninja-build libsdl2-2.0-0 libsdl2-dev qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev libqt5multimedia5-plugins libfdk-aac-dev build-essential cmake clang clang-format libc++-dev ffmpeg libswscale-dev libavdevice* libavformat-dev libavcodec-dev -y

echo "Building Citra..."
sleep 1
cd ~
git clone --recursive https://github.com/citra-emu/citra
cd citra
mkdir build
cd build
cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native
make -j$(nproc)
sudo make install

echo "Removing build files..."
sleep 1
cd ~
sudo rm -rf citra

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
