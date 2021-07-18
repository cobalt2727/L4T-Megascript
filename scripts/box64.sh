clear -x

echo "Box64 script started!"

echo "Installing Dependencies"
sudo apt install zenity -y
cd
git clone https://github.com/ptitSeb/box64 --depth=1
cd box64
git pull --depth=1
if [[ $? -ne 0 ]]; then
    cd ~
    rm -rf box64
    git clone https://github.com/ptitSeb/box64 --depth=1
    cd box64
fi
rm -rf build
mkdir build
cd build
# obtain the cpu info
get_system
case "$architecture" in
    "aarch64") case "$jetson_model" in
        "tegra-x1") cmake .. -DTEGRAX1=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo; echo "Tegra X1 based system" ;;
        *) cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo; echo "Universal aarch64 system";;
        esac
        ;;
    "x86_64") cmake .. -DLD80BITS=1 -DNOALIGN=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo; echo "x86_64 based system" ;;
    *) echo "Error: your cpu architecture ($architecture) is not supporeted by box64 and will fail to compile"; rm -rf ~/box64; echo ""; echo "Exiting the script"; sleep 3; exit $? ;;
esac

echo "Building Box64"

make -j$(nproc)
sudo make install
sudo systemctl restart systemd-binfmt
sudo mkdir /usr/share/box64
cd ..
sudo cp Box64Icon.png /usr/share/box64/icon.png

echo "Adding box64 to applications list"
sudo tee /usr/share/applications/box64.desktop <<'EOF'
[Desktop Entry]
Type=Application
Exec=bash -c '/usr/local/bin/box64 "$(zenity --file-selection)"'
Name=Box64
Icon=/usr/share/box64/icon.png
Terminal=hidden
Categories=Game;System
EOF

echo "Adding box64 application helper to list"
sudo tee /usr/share/applications/box64_helper.desktop <<'EOF'
[Desktop Entry]
Type=Application
Exec=bash -c 'bash <( wget -O - https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/Box64/box64_program_helper.sh )'
Name=Box64 Application Helper
Icon=/usr/share/box64/icon.png
Terminal=hidden
Categories=System
EOF

echo "Box64 successfully installed"
echo ""
echo "Start box64 from the applications list and select the x86_64 program or"
echo "start programs by typing 'box64 /path/to/my/application' in terminal"
sleep 3
