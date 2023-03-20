#!/bin/bash

clear -x
echo "Piper script started!"
sleep 1

echo "Checking if Piper can be installed from a repo..."
sleep 1
if command -v apt >/dev/null; then
  if PPA_check; then
    # TODO: convince PPA maintainers to fix 18.04 or remove it from the PPA
    echo "Installing Piper from the PPA..."
    ppa_name="libratbag-piper/piper-libratbag-git" && ppa_installer
    sudo apt install -y piper || error "Failed to install Piper!"

  else
    echo "Looks like the PPA doesn't support your device - checking to see if you're able to install it from apt anyways..." #e.g. Debian 11+
    package_available piper
    if [[ $? == "0" ]]; then
      sudo apt install -y piper || error "Failed to install Piper!"
    else
      echo "Check failed - installing Piper from source instead..."
      cd /tmp/
      rm -rf libratbag/
      rm -rf piper/
      sudo apt install git python3-pip libjson-glib-dev libunistring-dev check swig python-gi-dev python3-lxml python3-evdev appstream flake8 || error "Failed to install development libraries!"

      # yes, there's cases where ratbag is in apt but Piper isn't. but ratbag source builds = more device compatibility
      echo "Installing the 'ratbag' daemon Piper uses to communicate with the mice..."
      cd /tmp/
      git clone https://github.com/libratbag/libratbag --depth=1
      git clone https://github.com/libratbag/piper --depth=1

      package_available libgtk-4-bin
      if [[ $? == "0" ]]; then
        sudo apt install -y libgtk-4-bin #this is some sort of optional icon cache dependency, looks like
      fi
      case "$__os_codename" in
      bionic | buster)

        # note: https://www.reddit.com/r/ProgrammerHumor/comments/8pdebc/only_god_and_i_knew/

        ppa_name="deadsnakes/ppa" && ppa_installer
        sudo apt install python3.8 pkg-config libcairo2-dev gcc python3-dev libgirepository1.0-dev -y || error "Could not install dependencies!"
        sudo apt purge meson -y
        yes | python3.6 -m pip uninstall meson
        yes | python3.8 -m pip uninstall meson
        python3.8 -m pip install --upgrade pip meson gobject PyGObject || error "Failed to install meson from pip!" #meson from bionic is too old
        # TODO: hack meson around to use python3.8 in build steps below similar to how Xemu does it - Meson 62 or higher will require Python3.7+
        sed -i -e 's/#!\/usr\/bin\/env python3/#!\/usr\/bin\/env python3.8/g' piper/data/generate-piper-gresource.xml.py
        sed -i -e 's/#!\/usr\/bin\/env python3/#!\/usr\/bin\/env python3.8/g' piper/piper.in
        sed -i -e 's/#!\/usr\/bin\/env python3/#!\/usr\/bin\/env python3.8/g' piper/tests/svg-lookup-ini-test.py
        sed -i -e 's/#!\/usr\/bin\/env python3/#!\/usr\/bin\/env python3.8/g' piper/tests/check-svg.py

        ;;
      *)
        echo "Installing Meson..."
        python3 -m pip install --upgrade pip meson || error "Failed to install meson from pip!" #meson from bionic is too old
        ;;
      esac
      cd libratbag || error_user "Failed to download source code from GitHub!"
      meson builddir || error "Meson failed!"
      ninja -C builddir || error "Ninja failed!"
      sudo ninja -C builddir install || error "Installation failed!"

      echo "Installing Piper itself..."
      cd /tmp/piper || error_user "Failed to download source code from GitHub!"
      meson builddir || error "Meson failed!"
      ninja -C builddir || error "Ninja failed!"
      sudo ninja -C builddir install || error "Installation failed!"
    fi

  fi

elif command -v dnf >/dev/null; then
  echo "Installing Piper directly from the Fedora repos..."
  sudo dnf install -y piper || error "Failed to install Piper!"
else
  error "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

cd ~
echo "Done!"
