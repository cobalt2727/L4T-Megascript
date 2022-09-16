echo "Discord $(uname -m) script started!"
echo "CREDITS: https://github.com/SpacingBat3/WebCord"
sleep 2

cd /tmp
rm webcord*

if command -v apt >/dev/null; then
  echo "Installing dependencies..."
  sudo apt install git curl -y || error "Couldn't install dependencies"

  echo "Removing previous legacy Discord installs and inconsistent apt repo..."
  sudo dpkg -r electron-discord-webapp
  sudo rm /etc/apt/sources.list.d/webcord.list*

  echo "Downloading the most recent .deb from SpacingBat3's repository..."
  #note to self: fix this to be cross-architecture later
  curl -s https://api.github.com/repos/SpacingBat3/WebCord/releases/latest |
    grep "browser_download_url.*arm64.deb" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -i -

  echo "Done! Installing the package..."
  sudo apt install -y /tmp/*arm64.deb || error "Webcord install failed"

elif command -v dnf >/dev/null; then
  echo "Installing dependencies..."
  sudo dnf install git curl -y || error "Couldn't install dependencies"

  echo "Downloading the most recent .rpm from SpacingBat3's repository..."
  #note to self: fix this to be cross-architecture later
  curl -s https://api.github.com/repos/SpacingBat3/WebCord/releases/latest |
    grep "browser_download_url.*arm64.rpm" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -i -

  echo "Done! Installing the package..."
  sudo dnf install -y /tmp/*arm64.rpm || error "Webcord install failed"

else
  error "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi

cd ~

echo "Done!"
echo "Sending you back to the menu..."
sleep 1
