#!/bin/bash

#add armhf architecture (multiarch)
if [[ $(dpkg --print-foreign-architectures) == *"armhf"* ]]; then
  echo "armhf arcitecture already added..."
else
  sudo dpkg --add-architecture armhf
  # perform an apt update to check for errors
  # if apt update errors, assume that adding the foreign arch caused it and remove it
  sudo apt update
  if [[ "$?" != 0 ]]; then
    sudo dpkg --remove-architecture armhf
    error "armhf architecture caused apt to error so it has been removed!"
  fi
fi

# add mesa 22+ ppa
# this is known to conflict with the LLVM 14 APT repo. it must be removed if a user has installed it

if grep -q "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-14 main" /etc/apt/sources.list; then
  sudo add-apt-repository -r 'deb http://apt.llvm.org/bionic/   llvm-toolchain-bionic-14  main'
  sudo apt remove libclang-14-dev clang-14 lldb-14 lld-14 clangd-14 --autoremove -y
  sudo apt update
fi

# add updated mesa ppa
case "$__os_codename" in
bionic)
  # use stable mesa ppa on bionic as upstream intends to remove bionic from the fresh ppa
  sudo rm -f /etc/apt/sources.list.d/kisak-ubuntu-kisak-mesa-*.list
  ubuntu_ppa_installer "kisak/turtle" || error "PPA failed to install"
  ;;
noble|mantic|lunar)
  # skip
  true
  ;;
*)
  sudo rm -f /etc/apt/sources.list.d/kisak-ubuntu-turtle-*.list
  ubuntu_ppa_installer "kisak/kisak-mesa" || error "PPA failed to install"
  ;;
esac

# allow loading of MESA libraries (still uses ARM64 proprietary nvidia drivers)
sudo sed -i "s/\"library_path\" : .*/\"library_path\" : \"libEGL_mesa.so.0\"/g" "/usr/share/glvnd/egl_vendor.d/50_mesa.json"
sudo sed -i 's:^DISABLE_MESA_EGL="1":DISABLE_MESA_EGL="0":' /etc/systemd/nv.sh

# upgrade mesa and libglvnd
sudo apt-get dist-upgrade -y || error "Could not upgrade MESA (needed for Steam VirtualGL hardware acceleration)"
sudo apt install ninja-build python3 python3-pip libdrm-dev libgbm-dev pkg-config -y || error "Could not install VIRGL build dependencies"
hash -r
if package_is_new_enough meson 0.55.0 ;then
  sudo apt install meson -y || error "Could not install meson VIRGL build dependency"
else
  sudo -H python3 -m pip install --upgrade meson || error "Could not install meson VIRGL build dependency"
fi
hash -r

case "$__os_codename" in
bionic)
  # compile and install epoxy
  cd /tmp
  rm -rf libepoxy
  git clone https://github.com/anholt/libepoxy || "Could not clone libepoxy"
  cd libepoxy
  # checkout stable 1.5.11 commit
  git checkout a96abf1a4d29f78034273cbce96006cde950390c
  meson -Dprefix=/usr build || error "Could not configure libepoxy"
  ninja -j$(nproc) -C build || error "Could not build libepoxy"
  sudo ninja -C build install || error "Could not install libepoxy"
  cd
  rm -rf /tmp/libepoxy
  ;;
*)
  sudo apt install libepoxy-dev -y || "Could not install libepoxy"
  hash -r
  ;;
esac

# virgl
cd /tmp
rm -rf virglrenderer
git clone https://gitlab.freedesktop.org/virgl/virglrenderer.git || "Could not clone virglrenderer"
cd virglrenderer
meson -Dprefix=/usr build || error "Could not configure virglrenderer"
ninja -j$(nproc) -C build || error "Could not build virglrenderer"
sudo ninja -C build install || error "Could not install virglrenderer"
cd
rm -rf /tmp/virglrenderer

# install sdl2
bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/sdl2_install_helper.sh)" || error "Could not install SDL2"
# installing dependencies
sudo apt install -y libegl1-mesa:armhf libgl1-mesa-glx:armhf libgles2-mesa:armhf libsdl2-2.0-0:arm64 libsdl2-2.0-0:armhf libsdl2-mixer-2.0-0:arm64 libgtk3-nocsd0:armhf libnss3:armhf libnm0:armhf libdbus-glib-1-2:armhf libudev1:armhf libnspr4:armhf libgudev-1.0-0:armhf libxtst6:armhf libsm6:armhf libice6:armhf libusb-1.0-0:armhf libnss3 libnm0 libdbus-glib-1-2 libudev1 libnspr4 libgudev-1.0-0 libxtst6 libsm6 libice6 libusb-1.0-0 || error "Could not install steam dependencies"

bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/box86.sh)" || exit $?
bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/box64.sh)" || exit $?

echo "Installing steam.deb"
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb -O /tmp/steam.deb || wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb -O /tmp/steam.deb || error "Failed to download steam.deb"
sudo apt install --no-install-recommends --reinstall -y /tmp/steam.deb || error "Failed to install steam.deb"
hash -r

# steam UDEV rules conflict with HID-Nintendo/joycond, so disable the rules for Switch Pro Controller
# sudo sed -i 's/^KERNEL=="hidraw\*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0660", TAG+="uaccess"/#KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0660", TAG+="uaccess"/g' /lib/udev/rules.d/60-steam-input.rules
# sudo sed -i 's/^KERNEL=="hidraw\*", KERNELS=="\*057E:2009\*", MODE="0660", TAG+="uaccess"/#KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0660", TAG+="uaccess"/g' /lib/udev/rules.d/60-steam-input.rules

sudo mkdir -p /usr/local/bin /usr/local/share/applications
# if a matching name binary is found in /usr/local/bin it takes priority over /usr/bin
echo '#!/bin/bash
if ! pgrep virgl_test_ser*; then
  virgl_test_server --use-glx & export pid_virgl=$!
  echo "VIRGL Server Started"
fi
export STEAMOS=1
export STEAM_RUNTIME=1
export DBUS_FATAL_WARNINGS=0
GALLIUM_DRIVER=virpipe BOX64_LOG=1 BOX86_LOG=1 BOX64_EMULATED_LIBS=libmpg123.so.0 /usr/lib/steam/bin_steam.sh -no-cef-sandbox "$@"

rm -f /home/${USER}/Desktop/steam.desktop
kill $pid_virgl' | sudo tee /usr/local/bin/steam || error "Failed to create steam launch script"

# set execution bit
sudo chmod +x /usr/local/bin/steam

# copy official steam.desktop file to /usr/local and edit it
# we can't edit the official steam.desktop file since this will get overwritten on a steam update
# if a matching name .desktop file is found in /usr/local/share/applications it takes priority over /usr/share/applications
sudo cp /usr/share/applications/steam.desktop /usr/local/share/applications/steam.desktop
sudo sed -i 's:Exec=/usr/bin/steam:Exec=/usr/local/bin/steam:' /usr/local/share/applications/steam.desktop

# remove deb
rm /tmp/steam.deb
rm -f /home/${USER}/Desktop/steam.desktop

if ! echo "$XDG_DATA_DIRS" | grep -q "/usr/local/share" || ! echo "$PATH" | grep -q "/usr/local/bin"; then
  warning "YOU NEED TO REBOOT before starting steam. This is because Steam is the first application on your system to be installed into the /usr/local folder."
else
  warning "You should restart your system before trying to launch Steam otherwise errors may occur."
fi
