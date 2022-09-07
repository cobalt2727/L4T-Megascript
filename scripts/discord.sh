echo "Discord $(uname -m) script started!"
echo "CREDITS: https://github.com/SpacingBat3/WebCord"
sleep 2

if command -v apt >/dev/null; then
  echo "Installing dependencies..."
  sudo apt install git curl -y

  echo "Removing previous legacy Discord installs..."
  sudo dpkg -r electron-discord-webapp

  wget -qO- http://download.tuxfamily.org/webcordapt/add-repo.sh | sudo bash
  sudo apt install webcord -y || error "Webcord install failed"

elif command -v dnf >/dev/null; then
  echo "Installing dependencies..."
  sudo dnf install git curl -y

  cd ~
  mkdir -p discord-tmp/
  cd discord-tmp/
  rm *

  echo "Downloading the most recent .rpm from SpacingBat3's repository..."
  #note to self: fix this to be cross-architecture later
  curl -s https://api.github.com/repos/SpacingBat3/WebCord/releases/latest |
    grep "browser_download_url.*arm64.rpm" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -qi -

  echo "Done! Installing the package (and maybe fixing dependencies)..."
  sudo rpm -i *arm64.rpm || error "Webcord install failed"
  ## can we find a Fedora equivalent to this? the only one I saw seemed like it needs to be done manually
  #sudo apt --fix-broken install -y

  cd ..
  rm -rf discord-tmp/
else
  error "No available package manager found. Are you using a ubuntu/debian or fedora based system?"
fi

echo "Done!"
echo "Sending you back to the menu..."
sleep 1
