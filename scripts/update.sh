#!/bin/bash

clear -x
echo "Updater script successfully started!"

description="Do you want to remove unused programs (if any) and attempt to fix broken programs?\
\n(Keyboard required to confirm when it checks later, but any menus like this have mouse/touch support. If you don't have a keyboard set up, just choose no.)"
table=("no" "yes")
userinput_func "$description" "${table[@]}"
SystemFixUserInput="$output"

############UPDATER SCANNERS - SEE BELOW FOR MANUAL UPDATERS###########
##add more of these later!

#tests if the Dolphin Emulator program exists, then asks to re-run the installer script if it's found, binding the user's response to DolphinUserInput
#reset the variable first to be safe...
DolphinUserInput="no"
if test -f /usr/local/bin/dolphin-emu; then
  description="Do you want to update Dolphin? (May take 5 to 40 minutes)"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  DolphinUserInput="$output"
fi

#and so on and so forth.
MelonDSUserInput="no"
if test -f /usr/local/bin/melonDS; then
  description="Do you want to update melonDS? (May take 5 to 20 minutes)"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  MelonDSUserInput="$output"
fi

MetaforceUserInput="no"
if test -f /usr/local/bin/metaforce; then
  description="Do you want to update Metaforce? (May take 5 minutes to 3+ hours)"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  MetaforceUserInput="$output"
fi

RUserInput="no"
if test -f /usr/bin/R || test -f /usr/lib/R || test -f /usr/local/bin/R || test -f /usr/lib64/R; then
  description="Do you want to update R/CRAN packages? (May take 2 seconds to 2 hours)"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  RUserInput="$output"
fi

RetroPieUserInput="No"
if test -f /usr/bin/emulationstation; then
  description="Do you want to update parts of RetroPie?\
    \nBinaries should always be updated but may take a minute or two depending on the speed of your internet\
    \nUpdate RetroPie Setup Script and Megascript RetroPie Scripts\
    \nUpdate Everything from Source, could TAKE MULTIPLE HOURS, Not Recommended, builds all installed cores from source"
  table=("Binaries Only" "Update Scripts Only" "Update From Source" "No")
  userinput_func "$description" "${table[@]}"
  RetroPieUserInput="$output"
fi

XemuUserInput="no"
if test -f /usr/local/bin/xemu; then
  description="Do you want to update Xemu? (May take 5 minutes to 2 hours)"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  XemuUserInput="$output"
fi

WebcordUserInput="no"
if test -f /usr/bin/webcord; then
  description="Do you want to update Webcord/Discord? (May take 5 seconds to 5 minutes)"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  WebcordUserInput="$output"
fi

# run pi-apps updater if available
cd ~
if test -f ~/pi-apps/updater; then
  # pi-apps and the L4T-Megascript use many functions and variables with the same name.
  # to avoid conflicts always unset the DIRECTORY variable and re-load our functions after running pi-apps
  unset DIRECTORY
  if [[ $gui == "gui" ]]; then
    ~/pi-apps/updater gui
  else
    ~/pi-apps/updater cli
  fi
  #load functions from github source
  unset functions_downloaded
  source <(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/functions.sh)
  [[ ! -z ${functions_downloaded+z} ]] && status "Functions Loaded" || error_fatal "Oh no! Something happened to your internet connection! Exiting the Megascript - please fix your internet and try again!"
fi

#######################################################################

#fix error at https://forum.xfce.org/viewtopic.php?id=12752
sudo chown $USER:$USER $HOME/.local/share/flatpak
#fix potential root-owned files from older NPM versions
sudo chown -R 1001:1001 ~/.npm

##this is outside all the other y/n prompt runs at the bottom since you obviously need functioning repositories to do anything else
if [[ $SystemFixUserInput == "yes" ]]; then
  echo
  echo
  echo
  echo "Scanning for issues with system packages..."
  echo
  echo "If you receive a yes/no prompt in the following steps,"
  echo "Make sure you carefully read over the"
  echo "packages to be changed before proceeding."
  echo "If not, don't worry about it."
  echo "Purging, cleaning, and autoremoving are NORMALLY"
  echo "fine, but double-check packages to be safe."
  sleep 5


  #hotfix for users breaking their own install
  # only run on nintendo switch systems (previously named icosa or icosa_emmc but now named Nintendo Switch (20XX))
  if echo "$model" | grep -q [Ss]witch || echo "$model" | grep -q [Ii]cosa; then
    sudo apt purge flash-kernel -y
  fi

  # the LLVM apt repo we use updated from 13 to 14 in February, wiping out residual files from old 13 installs
  # there's probably a neater way to do this...
  case "$__os_codename" in
  bionic | focal)
    if package_installed "llvm-13"; then
      sudo apt remove llvm-13 -y
    fi
    if package_installed "clang-13"; then
      sudo apt remove clang-13 -y
    fi
    if package_installed "clang++-13"; then
      sudo apt remove clang++-13 -y
    fi
    if package_installed "libclang13-dev"; then
      sudo apt remove libclang13-dev -y
    fi
    if package_installed "libmlir-13-dev"; then
      sudo apt remove libmlir-13-dev -y
    fi
    ;;
  esac

  case "$__os_codename" in
  bionic)
    ubuntu_ppa_installer "theofficialgman/opt-qt-5.12.0-bionic-arm" && ppa_purger
    ubuntu_ppa_installer "beineri/opt-qt-5.12.0-bionic" && ppa_purger
    ;;
  focal)
    sudo apt install --reinstall -y python-is-python3
    ;;
  esac

  if grep -q "debian" <<<"$__id_like"; then
    ##maintenance (not passing with -y to prevent potentially breaking something for a user)

    sudo rm -rf /var/lib/apt/lists/
    sudo apt clean
    sudo apt autoclean
    sudo apt update
    sudo dpkg --configure -a
    sudo apt --fix-broken install
    sudo apt autoremove --purge
    clear -x
    description="Please carefully examine the output of the command\nthat's about to run, and make sure it doesn't remove\nanythingyou *need* without providing a replacement.\nYou accept responsibility by confirming the next command."
    table=("I understand")
    sudo apt-get purge $(dpkg -l | grep '^rc' | awk '{print $2}') #-y
  elif grep -q "fedora" <<<"$__id"; then
    # roughly translated the debian side of this using https://wiki.archlinux.org/title/Pacman/Rosetta
    sudo dnf clean all
    sudo dnf check-update
    sudo dnf repoquery --unsatisfied
    sudo dnf remove
    clear -x
    description="Please carefully examine the output of the command\nthat's about to run, and make sure it doesn't remove\nanythingyou *need* without providing a replacement.\nYou accept responsibility by confirming the next command."
    table=("I understand")
    userinput_func "$description" "${table[@]}"
    sudo dnf --refresh --best --allowerasing upgrade
    # sudo rpm -Va # this takes way too long, I have no idea when it would actually be used
  else
    error "Something's not right. Are you on a Debian, Ubuntu, or Fedora system?"
  fi

  echo "Fixing flatpak issues (if any)..."
  sudo rm -rf ~/.local/share/flatpak/repo/tmp/cache/
  sudo flatpak remove --unused
  flatpak remove --unused
  sudo flatpak repair
  flatpak repair --user

else

  echo "Skipping apt fixes..."
fi

echo "Running system updates..."
if grep -q "debian" <<<"$__id_like"; then
  sudo apt-get dist-upgrade -y || error "Looks like something went wrong with your system updates. Please do not send in this report unless you are running a Nintendo Switch, and you've seen this message MULTIPLE TIMES."
elif grep -q "fedora" <<<"$__id"; then
  # I feel like distro-sync would be a bad idea, haven't tested myself though
  sudo dnf upgrade -y || error "Looks like something went wrong with your system updates. Please do not send in this report unless you are running a Nintendo Switch, and you've seen this message MULTIPLE TIMES."
else
  error "Something's not right. Are you on a Debian, Ubuntu, or Fedora system?"
fi

if [ -f /etc/switchroot_version.conf ]; then
  swr_ver=$(cat /etc/switchroot_version.conf)
  if [ $swr_ver == "3.4.0" ]; then
    # check for bad wifi/bluetooth firmware, overwritten by linux-firmware upgrade
    # FIXME: future versions of Switchroot L4T Ubuntu will fix this and the check will be removed
    if [[ $(sha1sum /lib/firmware/brcm/brcmfmac4356-pcie.bin | awk '{print $1}') != "6e882df29189dbf1815e832066b4d6a18d65fce8" ]]; then
      warning "Wifi was probably broken after an apt upgrade to linux-firmware"
      warning "Replacing with known good version copied from L4T 3.4.0 updates files"
      sudo wget -O /lib/firmware/brcm/brcmfmac4356-pcie.bin https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/switch-firmware-3.4.0/brcm/brcmfmac4356-pcie.bin
      warning "L4T 5.0.0 is available, you should Upgrade to it."
    fi
  fi
fi

if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
  sudo apt install unity-tweak-tool hud -y
else
  echo "Not using Unity as the current desktop, skipping theme manager install..."
fi

echo "Updating Flatpak packages (if you have any)..."
##two separate flatpak updaters to catch all programs regardless of whether the user installed them for the system or just the user
sudo flatpak update -y --noninteractive
flatpak update --user -y --noninteractive

echo "Marking all AppImages under ~/Applications as executable..."
chmod +x ~/Applications/*.AppImage

#################MANUAL UPDATERS - SEE ABOVE FOR SCANNERS#################

if [[ $DolphinUserInput == "yes" ]]; then
  echo "Updating Dolphin..."
  echo -e "\e[33mTO FIX, RESET, AND/OR UPDATE CONFIGS (not game saves) YOU HAVE\e[0m"
  echo -e "\e[33mTO RE-RUN THE DOLPHIN SCRIPT FROM THE MENU\e[0m"
  sleep 5
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/install.sh)" || exit $?
else
  echo "Skipping Dolphin update..."
fi

if [[ $MelonDSUserInput == "yes" ]]; then
  echo "Updating melonDS..."
  sleep 5
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/melonDS.sh)" || exit $?
else
  echo "Skipping melonDS update..."
fi

if [[ $MetaforceUserInput == "yes" ]]; then
  echo "Updating Metaforce..."
  sleep 5
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/metaforce.sh)" || exit $?
else
  echo "Skipping Metaforce update..."
fi

if [[ $RetroPieUserInput == "Update From Source" ]]; then
  echo "Updating RetroPie Cores from Source..."
  echo -e "\e[33mThis can take a VERY long time - possibly multiple hours.\e[0m"
  echo -e "\e[33mCharge your device & remember you can close this terminal or press\e[0m"
  echo -e "\e[33mCtrl+C at any time to stop the process.\e[0m"
  sleep 10
  curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/retropie_auto.sh | bash -s "update_cores"
elif [[ $RetroPieUserInput == "Update Scripts Only" ]]; then
  echo "Updating RetroPie-Setup script and Megascript scripts Only..."
  curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/retropie_auto.sh | bash -s "update_scripts"
elif [[ $RetroPieUserInput == "Binaries Only" ]]; then
  echo "Updating RetroPie binaries only..."
  curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/retropie_auto.sh | bash -s "install_binaries"
else
  echo "Skipping RetroPie updates..."
fi

if [[ $RUserInput == "yes" ]]; then
  echo "Updating R/CRAN packages..."
  sleep 2
  Rscript -e 'update.packages(ask = FALSE)' #there is no error handling here: packages installed from distro repos are guaranteed to fail
else
  echo "Skipping R package updates..."
fi

if [[ $XemuUserInput == "yes" ]]; then
  echo "Updating Xemu..."
  sleep 5
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/xemu.sh)" || exit $?
else
  echo "Skipping Xemu update..."
fi

if [[ $WebcordUserInput == "yes" ]]; then
  echo "Updating Webcord/Discord..."
  sleep 5
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/discord.sh)" || exit $?
else
  echo "Skipping Webcord update..."
fi

##########################################################################

cd ~
if test -f customupdate.sh; then
  echo "Looks like you've made a custom update file - running that..."
  chmod +x customupdate.sh
  ./customupdate.sh
else
  echo -e "You can add your own commands to automatically run with this updater"
  echo -e "by creating a file in \e[34m/home/$USER/\e[0m (this is your default ~ folder) named \e[36mcustomupdate.sh\e[0m"
  sleep 4
fi

echo "One more upgrade check for good measure..."
#depending on the user's setup, the script could take a while
#especially if they're using the helper script to run the updater and missing out on our sudo timer hack
if grep -q "debian" <<<"$__id_like"; then
  sudo apt update
  sudo apt dist-upgrade -y || error "Looks like something went wrong with your system updates. Please do not send in this report unless you are running a Nintendo Switch, and you've seen this message MULTIPLE TIMES."
elif grep -q "fedora" <<<"$__id"; then
  sudo dnf --refresh upgrade -y || error "Looks like something went wrong with your system updates. Please do not send in this report unless you are running a Nintendo Switch, and you've seen this message MULTIPLE TIMES."
else
  error "This should be unreachable."
fi


sleep 1

echo
echo "Done! Sending you back to the main menu..."
sleep 4
