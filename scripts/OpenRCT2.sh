echo "This will compile and install the latest version of OpenRCT2 on your system."
echo "You will still need to get the files for a valid RCT2 install yourself"
echo "Follow these instructions at the below link if you don't know how to do it."
echo "https://github.com/OpenRCT2/OpenRCT2/wiki/Installation-on-Linux-and-macOS"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo "updating sources"
sudo apt update
sudo apt upgrade

echo "Installing requirements"
sudo apt-get install --no-install-recommends -y cmake libsdl2-dev libicu-dev gcc pkg-config libspeex-dev libspeexdsp-dev libcurl4-openssl-dev libcrypto++-dev libfontconfig1-dev libfreetype6-dev libpng-dev libssl-dev libzip-dev build-essential make duktape-dev libbenchmark-dev

## Manual Download of Nlohmann JSON3 - https://packages.ubuntu.com/focal/all/nlohmann-json3-dev/download
wget http://mirrors.kernel.org/ubuntu/pool/universe/n/nlohmann-json3/nlohmann-json3-dev_3.7.3-1_all.deb
sudo dpkg -i nlohmann-json3-dev_3.7.3-1_all.deb
rm nlohmann-json3-dev_3.7.3-1_all.deb

echo "Downloading Source Code"
sudo rm -rf OpenRCT2
git clone --depth=1 https://github.com/OpenRCT2/OpenRCT2.git
cd OpenRCT2
mkdir build && cd build
echo "Building & Installing OpenRCT2 (should take 20-30 minutes)"
cmake ../ -DCMAKE_BUILD_TYPE=Release -DDISABLE_GOOGLE_BENCHMARK=ON
make
make install
echo ""
echo "OpenRCT2 Installed Successfully!"
echo "The first time OpenRCT2 runs it will ask for the location of your RCT2 Files."
echo "Enjoy!"

