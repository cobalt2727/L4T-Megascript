#!/bin/bash

echo "T210 MangoHud Fork script started!"

package_available glslang-tools
if [[ $? == "0" ]]; then
  sudo apt install glslang-tools -y || error "Could not install apt dependencies"
else
  error "glslang-tools is not available so mangohud can not be compiled and installed"
fi

sudo apt install ninja-build git build-essential python3-mako -y || error "Could not install apt dependencies"
if package_is_new_enough meson 0.60.0 ;then
  sudo apt install -y meson || error "Could not install apt dependencies"
else
  pipx_install meson || exit 1
fi
cd /tmp
rm -rf MangoHud
git clone https://github.com/theofficialgman/MangoHud.git --depth=1 -b master-l4t
cd MangoHud
meson build --prefix /usr -Dappend_libdir_mangohud=false -Dwith_xnvctrl=disabled || error "Could Not Configure Source"
ninja -C build || error "Could Not Build Mangohud"
sudo ninja -C build install || error "Could Not Install Mangohud"
rm -rf MangoHud
cd ~

status_green "MangoHud successfully installed"
echo ""
echo "Start mangohud by adding it before your command"
echo "mangohud %command%"
echo "or some opengl programs may need"
echo "mangohud --dlsym %command%"
echo "Replace %command% with something like chromium-browser to start chromium with the mangohud overlay"
echo ""
echo "For more info, refer to the readme: https://github.com/flightlessmango/MangoHud"
