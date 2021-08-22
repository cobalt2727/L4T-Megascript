cd ~
sudo apt install cmake libsdl2-dev libxrandr-dev pkg-config qtbase5-dev qtbase5-private-dev qtbase5-dev-tools qttools5-dev libevdev-dev git libcurl4-gnutls-dev libgbm-dev libdrm-dev ninja-build -y

git clone https://github.com/stenzek/duckstation
cd duckstation
git pull
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -GNinja ..
#cmake -DCMAKE_BUILD_TYPE=Release ..
ninja
#make -j$(nproc)
