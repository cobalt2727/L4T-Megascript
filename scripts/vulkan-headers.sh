#!/bin/bash
echo "Vulkan script started"


sudo apt install cmake gcc -y || error "Could not install packages"
cd /tmp || error "Could not move to /tmp folder"
rm -rf ./Vulkan-Headers
git clone https://github.com/KhronosGroup/Vulkan-Headers.git
cd Vulkan-Headers/
mkdir build
cd build

echo "Building..."
cmake ..  || error "Cmake failed!"
cmake --build . -j$(nproc) || error "Build failed!"
sudo make install || error "Make install failed"
echo "Done!"
rm -rf /tmp/Vulkan-Headers
sleep 2
