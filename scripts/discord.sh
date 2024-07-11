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
    pipx_install
    case "$__os_codename" in
    bionic)
      sudo apt install -y python3.8 python3.8-dev

      #fix edge case with broken folder ownership that popped up in our GitHub Actions runs
      mkdir -p ~/.cache/
      mkdir -p ~/.cache/pip/
      sudo chown -R $USER:$USER ~/.cache/
      sudo chown -R $USER:$USER ~/.cache/pip/

      yes | python3.6 -m pip uninstall lastversion
      python3.8 -m pipx install --force pip pipx lastversion || error "Couldn't install dependencies"
      ;;
    *)
      python3 -m pipx install --force pip pipx lastversion || error "Couldn't install dependencies"
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
  if [[ $architecture == "aarch64" ]] || [[ $architecture == "x86_64" ]]; then
    echo "Installing dependencies..."
    sudo yum -y install https://extras.getpagespeed.com/release-latest.rpm
    sudo yum -y install lastversion

    # bootleg $dpkg_architecture on Fedora for the only two use cases we expect
    fedoraArch=""
    if grep -q "x86_64" <<<$(uname -m); then
      fedoraArch="x86_64" #yes, really.
    elif grep -q "aarch64" <<<$(uname -m); then
      fedoraArch="arm64"
    else
      error_user "Your architecture $(uname -m) is not supported by this script!"
    fi

    echo "Downloading and installing the most recent .rpm from SpacingBat3's repository..."
    # this command unfortunately doesn't work on Debian-based systems
    yes | sudo lastversion install webcord --filter $fedoraArch.rpm || error "Webcord install failed"

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
