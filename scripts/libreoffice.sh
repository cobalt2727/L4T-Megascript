echo "LibreOffice script started!"
sleep 2

get_system

case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
  ppa_name="libreoffice/ppa" && ppa_installer
  sudo apt install -y --no-install-recommends libreoffice libxrender1 libreoffice-gtk || error "Failed to install dependencies"

  if echo $XDG_CURRENT_DESKTOP | grep -q 'GNOME'; then
    sudo apt install -y --no-install-recommends libreoffice-gnome || error "Failed to install dependencies"
  elif echo $XDG_CURRENT_DESKTOP | grep -q 'Plasma'; then
    sudo apt install -y --no-install-recommends libreoffice-kde5 || error "Failed to install dependencies"
  fi
  ;;
Fedora)
  sudo dnf install -y libreoffice
  ;;
*)
  error "Unknown distro detected"
  ;;
esac

echo "Done!"
