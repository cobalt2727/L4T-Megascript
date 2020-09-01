clear
echo "Building and instaling CMake (This can take some time)"
sudo apt install wget
wget https://github.com/Kitware/CMake/archive/master.zip
unzip master.zip
cd CMake-master
./bootstrap
make -j$(nproc)
sudo make install
hash -r
echo "Done!"
echo
echo "Moving on..."
sleep 5