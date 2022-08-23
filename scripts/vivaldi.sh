echo "Vivaldi script started!"

if grep -q debian /etc/os-release; then
  wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/usr/share/keyrings/vivaldi-browser.gpg
  echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
  sudo apt update && sudo apt install vivaldi-stable -y

elif grep -q fedora /etc/os-release; then
  sudo dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo
  sudo dnf install vivaldi-stable -y
fi
