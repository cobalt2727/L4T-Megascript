echo "LibreOffice script started!"

case "$__os_id" in
Ubuntu)
  ubuntu_ppa_installer "libreoffice/ppa" || error "PPA failed to install"
  sudo apt install -y --no-install-recommends libreoffice libxrender1 libreoffice-gtk3 || error "Failed to install dependencies"

  if echo $XDG_CURRENT_DESKTOP | grep -q 'GNOME'; then
    sudo apt install -y --no-install-recommends libreoffice-gnome || error "Failed to install dependencies"
  elif echo $XDG_CURRENT_DESKTOP | grep -q 'KDE'; then
    sudo apt install -y --no-install-recommends libreoffice-kf5 || error "Failed to install dependencies"
  fi
  ;;
Fedora)
  sudo dnf install -y libreoffice || error "Failed to install dependencies"
  ;;
Raspbian | Debian)
  package_available libreoffice-gtk2
  if [[ $? == "0" ]]; then
    sudo apt install -y --no-install-recommends libreoffice libxrender1 libreoffice-gtk3 || error "Failed to install dependencies"
  else
    sudo apt install -y --no-install-recommends libreoffice libxrender1 libreoffice-gtk2 libreoffice-gtk3 || error "Failed to install dependencies"
  fi
  ;;
*)
  error "Unknown distro detected"
  ;;
esac

echo "Done!"
