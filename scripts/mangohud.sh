clear -x

echo "MangoHud script started!"

package_available glslang-tools
if [[ $? == "0" ]]; then
  sudo apt install glslang-tools -y || error "Could not install apt dependencies"
else
  rm -rf /tmp/mangohud-debs
  mkdir /tmp/mangohud-debs
  cd /tmp/mangohud-debs
  wget http://ftp.us.debian.org/debian/pool/main/s/spirv-tools/spirv-tools_2020.6-1~bpo10+1_arm64.deb http://ftp.us.debian.org/debian/pool/main/g/glslang/glslang-tools_8.13.3743-1~bpo10+1_arm64.deb
  sudo apt install ./*.deb -y || error "Could not install apt dependencies"
  rm -rf /tmp/mangohud-debs
fi

sudo apt install ninja-build git build-essential python3-pip -y || error "Could not install apt dependencies"
python3 -m pip install --upgrade pip meson || error "Could not install python dependencies"
cd /tmp
git clone https://github.com/flightlessmango/MangoHud.git
cd MangoHud
git pull || error "Could Not Pull Latest Source Code"
meson build --prefix /usr -Dappend_libdir_mangohud=false -Dwith_xnvctrl=disabled || error "Could Not Build Source"
sudo ninja -C build install || error "Could Not Install Mangohud"
rm -rf MangoHud

echo "MangoHud successfully installed"
echo ""
echo "Start mangohud by adding it before your command"
echo "mangohud %command%"
echo "or some opengl programs may need"
echo "mangohud --dlsym %command%"
echo "Replace %command% with something like chromium-browser to start chromium with the mangohud overlay"
echo ""
echo "For more info, refer to the readme: https://github.com/flightlessmango/MangoHud"
sleep 10
