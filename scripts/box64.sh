#!/bin/bash

clear -x

echo "Box64 script started!"

case "$dpkg_architecture" in
"arm64")
  sudo wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
  if [ $? != 0 ];then
    sudo rm -f /etc/apt/sources.list.d/box64.list
    error "Failed to add box64.list file!"
  fi

  sudo rm -f /usr/share/keyrings/box64-debs-archive-keyring.gpg
  curl -fsSL https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/box64-debs-archive-keyring.gpg

  if [ $? != 0 ];then
    sudo rm -f /etc/apt/sources.list.d/box64.list
    error "Failed to add KEY.gpg to APT keyring!"
  fi

  if [[ "$SOC_ID" == "tegra-x1" ]] || [[ "$SOC_ID" == "tegra-x2" ]]; then
    sudo apt install -y box64-tegrax1 || exit 1
  elif [[ "$SOC_ID" == "rk3399" ]]; then
    sudo apt install -y box64-rk3399 || exit 1
  elif [[ "$SOC_ID" == "bcm2711" ]]; then
    sudo apt install -y box64 || exit 1
  else
    warning "There is no box64 pre-build for your device $SOC_ID $model"
    warning "Installing the RPI4 tuned box64 build as a fallback (no crypto extensions enabled)"
    sudo apt install -y box64 || exit 1
  fi
  ;;
"amd64")
  # add toolchain ppa for gcc 11 on bionic and focal
  # newer releases of ubuntu have gcc-11 in the normal repos
  # older releases of ubuntu are not supported
  case "$__os_codename" in
  bionic) ppa_name="theofficialgman/cmake-bionic" && ppa_installer ;;
  esac
  case "$__os_codename" in
  bionic | focal) ppa_name="ubuntu-toolchain-r/test" && ppa_installer ;;
  esac

  sudo apt install zenity cmake git build-essential gcc-11 g++-11 -y || error "Could not install dependencies"
  cd /tmp
  rm -rf box64
  git clone --depth=1 https://github.com/ptitSeb/box64
  cd box64
  mkdir build
  cd build
  cmake .. -DLD80BITS=1 -DNOALIGN=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=gcc-11
  echo "Building Box64"

  make -j$(nproc) || error "Compilation failed"
  sudo make install || error "Make install failed"
  sudo systemctl restart systemd-binfmt
  ;;
*)
  error_user "Error: your cpu architecture ($dpkg_architecture) is not supported by box64 and will fail to compile"
  ;;
esac

sudo mkdir /usr/share/box64
sudo wget https://github.com/ptitSeb/box64/raw/main/docs/img/Box64Icon.png -O /usr/share/box64/icon.png

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

rm -rf /tmp/box64

echo "Box64 successfully installed"
echo ""
echo "Start box64 from the applications list and select the x86_64 program or"
echo "start programs by typing 'box64 /path/to/my/application' in terminal"
sleep 3
