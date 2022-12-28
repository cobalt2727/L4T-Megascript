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

#tests if the Citra Emulator program exists, then asks to re-run the installer script if it's found, binding the user's response to DolphinUserInput
#reset the variable first to be safe...
CitraUserInput="no"
if test -f /usr/local/bin/citra-qt; then
  description="Do you want to update Citra? (May take 5 to 40 minutes)"
  table=("yes" "no")
  userinput_func "$description" "${table[@]}"
  CitraUserInput="$output"
fi

#Same as above, but for Dolphin, using the dolphin-emu binary as the test
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
  if [[ $gui == "gui" ]]; then
    ~/pi-apps/updater gui
  else
    ~/pi-apps/updater cli
  fi
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
  # and here's the neater way!
  ##LLVM fixes to possibly be uncommented later - storing them here for reference, for now
  # LLVM_VERSION_STRING=$(curl -s https://apt.llvm.org/llvm.sh | grep "CURRENT_LLVM_STABLE=")
  # STABLE_LLVM=${LLVM_VERSION_STRING#*=}
  # echo "stable LLVM is $STABLE_LLVM"
  # LATEST_LLVM=$(($STABLE_LLVM + 1))
  # echo "latest LLVM is $LATEST_LLVM"
  # OLD_LLVM=$(($STABLE_LLVM - 1))
  # echo "old LLVM is $OLD_LLVM"

  # APT_LLVM_VERSION=$(echo $(dpkg -s llvm | grep -i version) | sed 's/.*\://' | awk -F\. '{print $1}')
  # echo "version of LLVM from apt is $APT_LLVM_VERSION"
  # if [ $OLD_LLVM == $APT_LLVM_VERSION ]; then
  #   echo 'the "old" version of LLVM is default for the system - DO NOT REMOVE'
  # else
  #   echo "All clear to remove LLVM and Clang $OLD_LLVM"
  # fi
  # possibly come up with a way later to remove all versions between system version and OLD_LLVM?

  case "$__os_codename" in
  bionic)
    ppa_name="theofficialgman/opt-qt-5.12.0-bionic-arm" && ppa_purger
    ppa_name="beineri/opt-qt-5.12.0-bionic" && ppa_purger
    ;;
  esac

  ##maintenance (not passing with -y to prevent potentially breaking something for a user)
  sudo rm -rf /var/lib/apt/lists/
  sudo apt clean
  sudo apt autoclean
  sudo apt update
  sudo dpkg --configure -a
  sudo apt --fix-broken install
  sudo apt autoremove --purge
  sudo apt-get purge $(dpkg -l | grep '^rc' | awk '{print $2}') #-y

  echo "Fixing flatpak issues (if any)..."
  sudo flatpak remove --unused
  flatpak remove --unused
  sudo flatpak repair
  flatpak repair --user

  case "$__os_codename" in
  bionic)
    if [ -f /etc/alternatives/python ]; then
      echo "Fixing possibly broken Python setup (this was my fault)..."
      sudo rm /etc/alternatives/python && sudo apt install --reinstall python-minimal -y
    else
      echo "No issues detected with Python, skipping fix for that..."
    fi
    ;;
  esac

else

  echo "Skipping apt fixes..."
fi

echo "Running APT updates..."
if package_installed xserver-xorg-input-joystick; then
  # upgrade xserver-xorg-input-joystick before other packages to workaround package conflicts
  sudo apt install xserver-xorg-input-joystick -y
fi
sudo apt-get dist-upgrade -y || error "Temporarily turning on error reporting for apt upgrades to aid in bugfixing with Switchroot's 5.0 update! Please do not send in this report unless you are running a Nintendo Switch, and you've seen this message MULTIPLE TIMES."

if [ -f /etc/switchroot_version.conf ]; then
  swr_ver=$(cat /etc/switchroot_version.conf)
  if [ $swr_ver == "3.4.0" ]; then
    # check for bad wifi/bluetooth firmware, overwritten by linux-firmware upgrade
    # FIXME: future versions of Switchroot L4T Ubuntu will fix this and the check will be removed
    if [[ $(sha1sum /lib/firmware/brcm/brcmfmac4356-pcie.bin | awk '{print $1}') != "6e882df29189dbf1815e832066b4d6a18d65fce8" ]]; then
      warning "Wifi was probably broken after an apt upgrade to linux-firmware"
      warning "Replacing with known good version copied from L4T 3.4.0 updates files"
      sudo wget -O /lib/firmware/brcm/brcmfmac4356-pcie.bin https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/switch-firmware-3.4.0/brcm/brcmfmac4356-pcie.bin
    fi
  fi
fi

#this is an apt package in the Switchroot repo, for documentation join their Discord https://discord.gg/9d66FYg and check https://discord.com/channels/521977609182117891/567232809475768320/858399411955433493
# sudo apt install switch-multimedia -y
sudo apt install python-minimal -y
if [[ $(echo $XDG_CURRENT_DESKTOP) = 'Unity:Unity7:ubuntu' ]]; then
  sudo apt install unity-tweak-tool hud -y
else
  echo "Not using Unity as the current desktop, skipping theme manager install..."
fi

case "$__os_codename" in
bionic)
  if $(dpkg --compare-versions $(dpkg-query -f='${Version}' --show libc6) lt 2.28); then
    echo "Continuing the installs"
  else
    echo "Force downgrading libc and related packages"
    echo "libc 2.28 was previously required for the minecraft bedrock install"
    echo "this is no longer the case so the hack is removed"
    echo ""
    echo "You may need to recompile other programs such as Dolphin and BOX64 if you see this message"
    sudo rm -rf /etc/apt/sources.list.d/zorinos-ubuntu-stable-bionic.list*
    sudo rm -rf /etc/apt/preferences.d/zorinos*
    sudo rm -rf /etc/apt/sources.list.d/debian-stable.list*
    sudo rm -rf /etc/apt/preferences.d/freetype*

    sudo apt update
    sudo apt install libc-bin=2.27* libc-dev-bin=2.27* libc6=2.27* libc6-dbg=2.27* libc6-dev=2.27* libfreetype6=2.8* libfreetype6-dev=2.8* locales=2.27* -y --allow-downgrades
  fi
  ;;
esac

echo "Updating Flatpak packages (if you have any)..."
##two separate flatpak updaters to catch all programs regardless of whether the user installed them for the system or just the user
sudo flatpak update -y
flatpak update -y

#echo "Updating NPM (if you have it)..."
##commenting this out until i figure out a better way to replace it with an updater for all NodeJS packages
#sudo npm install -g npm

echo "Marking all AppImages under ~/Applications as executable..."
chmod +x ~/Applications/*.AppImage

#################MANUAL UPDATERS - SEE ABOVE FOR SCANNERS#################

if [[ $CitraUserInput == "yes" ]]; then
  echo "Updating Citra..."
  sleep 5
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/citra.sh)" || exit $?
else
  echo "Skipping Citra update..."
fi

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
sudo apt update
sudo apt upgrade -y

sleep 1

echo
echo "Done! Sending you back to the main menu..."
sleep 4
