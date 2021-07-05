echo "Box64 script started!"

cd
git clone https://github.com/ptitSeb/box64 --depth=1
cd box64
git pull --depth=1
rm -rf build
mkdir build
cd build
# obtain the cpu info
get_system
case "$architecture" in
    "aarch64") case "$jetson_model" in
        "nintendo-switch"|"tx1"|"nano") cmake .. -DTEGRAX1=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo; echo "Tegra X1 based system" ;;
        *) cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo; echo "Universal aarch64 system";;
        esac
        ;;
    "x86_64") cmake .. -DLD80BITS=1 -DNOALIGN=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo; echo "x86_64 based system" ;;
    *) echo "Error: your cpu architecture ($architecture) is not supporeted by box64 and will fail to compile" ;;
esac


make -j$(nproc)
sudo make install

echo "Box64 successfully installed"
echo ""
echo "you can now run some x86_64 linux applications by typing 'box64 /path/to/my/application' in terminal"
sleep 3