#!/bin/bash
# Download and install Mods compatible with minecraft version
MMC_ROOT="${INST_DIR%/*/*/*}/scripts"
# if scripts directory does not exist, fallback to using the pre-launch.sh script directory for files
[ ! -d "$MMC_ROOT" ] && MMC_ROOT="$(dirname "$0")"
wget -q --spider https://github.com && wget -q --spider https://raw.githubusercontent.com/

# only run update/install script if the user has an active internet connection
if [ $? != 0 ]; then
  echo "No internet connection is available. Skipping pre-launch mod installer script."
  exit 0
fi

echo "Checking megascript-mods list from online"
wget -qO /tmp/megascript-mods.txt "https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/MultiMC/megascript-mods.txt"
mv /tmp/megascript-mods.txt "$MMC_ROOT/megascript-mods.txt"

echo "Checking pre-launch script from online."
wget -qO /tmp/pre-launch.sh "https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/assets/MultiMC/pre-launch.sh" && diff /tmp/pre-launch.sh "$MMC_ROOT/pre-launch.sh"

if [[ "$?" == 1 ]]; then
  echo "Online script is newer"
  rm "$MMC_ROOT/pre-launch.sh"
  mv /tmp/pre-launch.sh "$MMC_ROOT/pre-launch.sh"
  chmod +x "$MMC_ROOT/pre-launch.sh"
  echo "Running new downloaded script and skipping this old one"
  "$MMC_ROOT/pre-launch.sh" || exit $?
  exit 0
else
  echo "Pre-Launch script already up to date."
fi

### make sure to comment this out if the mod script is working. staring here ###

echo "Skipping automatic mod installation script as minecraft-mod-manager is currently broken due to Modrinth API v1 removal."
echo "See L4T-Megascript Discord for more info"
echo "Issue tracked here: https://github.com/Senth/minecraft-mod-manager/issues/206"
echo -e "Skipping automatic mod installation script as minecraft-mod-manager is currently broken due to Modrinth API v1 removal.\
See L4T-Megascript Discord for more info. When this is fixed, this notice will be removed and the script will automatically update and function again.\
\n\nIssue tracked here: https://github.com/Senth/minecraft-mod-manager/issues/206" | yad --image "dialog-info" \
--borders="20" --center --fixed \
--class L4T-Megascript --name "L4T Megascript" --window-icon=/usr/share/icons/L4T-Megascript.png \
--text-info --fontname="@font@ 11" --wrap --width=800 --height=250 --timeout=20 --timeout-indicator=bottom \
--show-uri \
--button="OK, Skipping Mod Installation Script":0
exit 0

### ends here ###

megascript_mods=$(sed -n "p" <"$MMC_ROOT/megascript-mods.txt")
user_mods=$(sed -n "p" <"$MMC_ROOT/user-mods.txt")
cd "$INST_DIR"
mc_version=$(jq -M -r '.components[] | "\(.uid)/\(.version)"' mmc-pack.json | sed -n -e 's/^.*net.minecraft\///p')
fabric_version=$(jq -M -r '.components[] | "\(.uid)/\(.version)"' mmc-pack.json | sed -n -e 's/^.*net.fabricmc.fabric-loader\///p')
forge_version=$(jq -M -r '.components[] | "\(.uid)/\(.version)"' mmc-pack.json | sed -n -e 's/^.*net.minecraftforge\///p')
if [[ -d "minecraft" ]]; then
  cd minecraft
else
  mkdir -p .minecraft
  cd .minecraft
fi
mkdir -p mods
mkdir -p config
cd mods
modloader=""
add_button=""
if [[ -z "$fabric_version" ]]; then
  if [[ -z "$forge_version" ]]; then
    # forge and fabric are not installed
    echo -e "Fabric is not installed so L4T-Megascript Performance mods can NOT be run.\
\n\nDo you want to cancel launching minecraft so you can go click Install Fabric under your minecraft instance?\
\n\nIf you don't care for the Fabric performance mods, or are running an older version of Minecraft without Fabric, then you should Continue to Launch Minecraft." | yad --image "dialog-question" \
      --borders="20" --center --fixed --window-icon=/usr/share/icons/L4T-Megascript.png \
      --text-info --fontname="@font@ 11" --wrap --width=800 --height=250 \
      --show-uri \
      --button="Yes, Cancel launching Minecraft":0 \
      --button="No, Continue to Launch Minecraft":1
    case "$?" in
    "0")
      echo "User canceled Launching Minecraft"
      exit 1
      ;;
    esac
  else
    # forge is installed
    echo -e "Forge is installed so L4T-Megascript Performance mods can NOT be run and installation of them has been disabled.\
\n\nNOTE: Megascript Performance mods only work on Minecraft 1.16+ Fabric Instances.\
\n\nDo you want to cancel launching minecraft so you can remove forge and install Fabric under your instance?" | yad --image "dialog-question" \
      --borders="20" --center --fixed --window-icon=/usr/share/icons/L4T-Megascript.png \
      --text-info --fontname="@font@ 11" --wrap --width=800 --height=250 \
      --show-uri \
      --button="Yes, Cancel launching Minecraft":0 \
      --button="No, Continue to Launch Minecraft":1
    case "$?" in
    "0")
      echo "User canceled Launching Minecraft"
      exit 1
      ;;
    esac
    modloader="forge"
  fi
else
  # fabric is installed, add button to install megascript mods
  modloader="fabric"
  add_button='--button=Yes, Update/Install My Mods and Megascript Suggested Fabric mods:0'
fi
minecraft_mods_list=$(minecraft-mod-manager list | tail -n +2)
if [[ $(echo "$minecraft_mods_list" | wc -l) -gt 2 ]]; then
  echo -e "The megascript uses Minecraft Mod Manager to keep all your Mods up to date and install a pregenerated list of Fabric Mods.\
Do you want to update/install the following Mods: \n\n$minecraft_mods_list\n\n\n\
You might want to select the (Yes, Update/Install ONLY My Mods) button if you plan on using Forge mods. This button will skip the pregenerated list of Fabric mods" | yad --image "dialog-question" \
    --borders="20" --center --fixed --window-icon=/usr/share/icons/L4T-Megascript.png \
    --text-info --fontname="@font@ 11" --wrap --width=800 --height=500 \
    --show-uri \
    "$add_button" \
    --button="Yes, Update/Install ONLY My Mods":1 \
    --button="No, skip this and save time":2
  user_output="$?"
else
  echo -e "The megascript uses Minecraft Mod Manager to keep all your Mods up to date and install a pregenerated list of Fabric Mods.\n\n\
You do not currently have any mods installed. Click (Yes, Update/Install My Mods and Megascript Suggested Fabric mods) to install suggested Fabric performance mods.\n\
You might want to select the (Yes, Update/Install ONLY My Mods) button if you plan on using Forge mods. This button will skip the pregenerated list of Fabric mods" | yad --image "dialog-question" \
    --borders="20" --center --fixed --window-icon=/usr/share/icons/L4T-Megascript.png \
    --text-info --fontname="@font@ 11" --wrap --width=800 --height=500 \
    --show-uri \
    "$add_button" \
    --button="Yes, Update/Install ONLY My Mods":1 \
    --button="No, skip this and save time":2
  user_output="$?"
fi
case "$user_output" in
"0" | "1")
  shopt -s extglob
  function version { echo "$@" | awk -F. '{ printf("%d%03d%03d\n", $1,$2,$3); }'; }
  # updating minecraft-mod-manager if its below 1.3.0
  cur_version=$(minecraft-mod-manager --version | tail -n 1 | awk '{print $2}')
  if [ $(version "${cur_version//$'\e'\[+([0-9;])m/}") -lt $(version "1.4.2") ]; then
    # set each variable individually since Fedora prints all output to one line

    # first check if lsb_release has an upstream option -u
    # if not, check if there is an upstream-release file
    # if not, check if there is a lsb-release.diverted file
    # if not, assume that this is not a ubuntu derivative
    if lsb_release -a -u &>/dev/null; then
      # This is a Ubuntu Derivative, checking the upstream-release version info
      __os_id="$(lsb_release -s -i -u)"
      __os_desc="$(lsb_release -s -d -u)"
      __os_release="$(lsb_release -s -r -u)"
      __os_codename="$(lsb_release -s -c -u)"
    elif [ -f /etc/upstream-release/lsb-release ]; then
      # ubuntu 22.04+ linux mint no longer includes the lsb_release -u option
      # add a parser for the /etc/upstream-release/lsb-release file
      source /etc/upstream-release/lsb-release
      __os_id="$DISTRIB_ID"
      __os_desc="$DISTRIB_DESCRIPTION"
      __os_release="$DISTRIB_RELEASE"
      __os_codename="$DISTRIB_CODENAME"
      unset DISTRIB_ID DISTRIB_DESCRIPTION DISTRIB_RELEASE DISTRIB_CODENAME
    elif [ -f /etc/lsb-release.diverted ]; then
      # ubuntu 22.04+ popOS no longer includes the /etc/upstream-release/lsb-release or the lsb_release -u option
      # add a parser for the new /etc/lsb-release.diverted file
      source /etc/lsb-release.diverted
      __os_id="$DISTRIB_ID"
      __os_desc="$DISTRIB_DESCRIPTION"
      __os_release="$DISTRIB_RELEASE"
      __os_codename="$DISTRIB_CODENAME"
      unset DISTRIB_ID DISTRIB_DESCRIPTION DISTRIB_RELEASE DISTRIB_CODENAME
    else
      __os_id="$(lsb_release -s -i)"
      __os_desc="$(lsb_release -s -d)"
      __os_release="$(lsb_release -s -r)"
      __os_codename="$(lsb_release -s -c)"
    fi
    # default to python3 if OS can not be determined
    python_version="python3"
    case "$__os_id" in
    Raspbian | Debian)
      case "$__os_codename" in
      bullseye) python_version="python3" ;;
      buster) python_version="python3.8" ;;
      esac
      ;;
    Ubuntu)
      case "$__os_codename" in
      bionic) python_version="python3.8" ;;
      *) python_version="python3" ;;
      esac
      ;;
    esac
    $python_version -m pip install --upgrade pip
    $python_version -m pip install --upgrade minecraft-mod-manager
  else
    echo "minecraft-mod-manager is up to date enough, current version is ${cur_version//$'\e'\[+([0-9;])m/}"
  fi

  # downloading patched gamecontrollerdb.txt to workaround glfw bug
  echo "Downloading latest gamecontrollerdb.txt"
  wget "https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt" -O ../config/gamecontrollerdb_temp.txt && rm -rf ../config/gamecontrollerdb.txt && mv ../config/gamecontrollerdb_temp.txt ../config/gamecontrollerdb.txt
  echo "Patching gamecontrollerdb.txt for combined joycons to work around bug in lwjgl3"
  echo "060000004e696e74656e646f20537700,Nintendo Combined Joy-Cons 2 (joycond),a:b0,b:b1,back:b9,dpdown:b15,dpleft:b16,dpright:b17,dpup:b14,guide:b11,leftshoulder:b5,leftstick:b12,lefttrigger:b7,leftx:a0,lefty:a1,rightshoulder:b6,rightstick:b13,righttrigger:b8,rightx:a2,righty:a3,start:b10,x:b3,y:b2,platform:Linux," >>../config/gamecontrollerdb.txt
  cp ../config/gamecontrollerdb.txt ../config/gamecontrollercustommappings.txt
  ;;
esac

case "$user_output" in
"0")
  echo "Selected: Update/Install My Mods and Megascript Suggested Fabric mods"
  # setting all phosphor versions to disabled
  for f in phosphor*.jar; do
    [ -f "$f" ] && mv "$f" "${f}.disabled" || rm -f "${f}"
  done
  minecraft-mod-manager -v "$mc_version" --mod-loader fabric --beta --alpha update
  minecraft-mod-manager -v "$mc_version" --mod-loader fabric --beta --alpha install $megascript_mods $user_mods
  ;;
"1")
  echo "Selected: Update/Install ONLY My Mods"
  minecraft-mod-manager -v "$mc_version" --beta --alpha update
  minecraft-mod-manager -v "$mc_version" --beta --alpha install $user_mods
  ;;
"2")
  echo "Skipped Mod install/update"
  ;;
esac
echo "Mod script finished."
