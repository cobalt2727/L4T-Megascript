#https://github.com/Itai-Nelken/Etcher-arm-32-64
#https://github.com/ryanfortner/balenaetcher-debs

echo "Balena Etcher script started!"

case "$__os_id" in
Raspbian | Debian | LinuxMint | Linuxmint | Ubuntu | [Nn]eon | Pop | Zorin | [eE]lementary | [jJ]ing[Oo][sS])
  sudo apt install make git libass-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-regex-dev libboost-locale-dev libboost-thread-dev libopengl0 libicu-dev libwxgtk3.0-gtk3-dev zlib1g-dev fontconfig luajit --no-install-recommends libffms2-dev libfftw3-dev libhunspell-dev libopenal-dev uchardet libuchardet-dev intltool -y || error "Failed to install dependencies!"
  ;;
Fedora)
  #TODO
  sudo dnf install git autoconf gettext-devel automake freetype-devel fontconfig-devel libass-devel boost-devel wxBase-devel wxBase3-devel wxGTK3-devel intltool -y || error "Failed to install dependencies!"
  ;;
*)
  echo -e "\\e[91mUnknown distro detected - this script should work, but you'll need to install necessary dependencies yourself following https://github.com/wangqr/Aegisub#autoconf--make-for-linux-and-macos if you haven't already...\\e[39m"
  sleep 5
  ;;
esac

echo "Done! Sending you back to the main menu..."
