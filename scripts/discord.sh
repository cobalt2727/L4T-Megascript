#!/bin/bash

echo "Discord $(uname -m) script started!"
echo "CREDITS: https://github.com/SpacingBat3/WebCord"
sleep 2

cd /tmp
rm webcord*

if
  command -v apt >/dev/null
then
  if [[ $dpkg_architecture == "amd64" ]] || [[ $dpkg_architecture == "arm64" ]] || [[ $dpkg_architecture == "armhf" ]]; then
    echo "Installing dependencies..."
    sudo apt install git curl python3-pip -y || error "Couldn't install dependencies"
    case "$__os_codename" in
    bionic)
      ppa_name="ubuntu-toolchain-r/test" && ppa_installer
      sudo apt install -y python3.8
      yes | python3.6 -m pip uninstall lastversion
      python3.8 -m pip install --upgrade --force-reinstall pip filelock lastversion || error "Couldn't install dependencies"
      ;;
    *)
      python3 -m pip install --upgrade pip lastversion || error "Couldn't install dependencies"
      ;;
    esac

    echo "Removing previous legacy Discord installs and inconsistent apt repo..."
    sudo dpkg -r electron-discord-webapp
    sudo rm /etc/apt/sources.list.d/webcord.list*

    echo "Downloading the most recent .deb from SpacingBat3's repository..."
    lastversion --assets --filter $dpkg_architecture.deb download https://github.com/SpacingBat3/WebCord

    echo "Done! Installing the package..."
    sudo apt install -y /tmp/webcord*$dpkg_architecture.deb || error "Webcord install failed"
  else
    error_user "Your architecture ($dpkg_architecture) is not supported."
  fi

elif
  command -v dnf >/dev/null
then
  # I'm not including 32-bit arm here despite Webcord (currently) providing downloads for it because
  # 1. Fedora deprecated it https://arm.fedoraproject.org/
  # 2. I'm too lazy to parse out armv7l and armv7hl
  if [[ $architecture == "arm64" ]] || [[ $architecture == "x86_64" ]]; then
    echo "Installing dependencies..."
    sudo yum -y install https://extras.getpagespeed.com/release-latest.rpm
    sudo yum -y install lastversion

    echo "Downloading and installing the most recent .rpm from SpacingBat3's repository..."
    # this command unfortunately doesn't work on Debian-based systems
    yes | sudo lastversion install webcord || error "Webcord install failed"

  else
    error_user "Your architecture ($architecture) is not supported."
  fi

else
  error_user "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

cd ~

echo "Done!"
echo "Sending you back to the menu..."
sleep 1
