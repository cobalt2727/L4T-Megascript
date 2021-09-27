export gui=$1
echo "These are here because I'm a lazy coder and i want an easy reference for text formatting in the menu - if you're able to read this inside the program, something is very wrong."
echo -e "\e[30mBlack Text\e[0m"
echo -e "\e[31mRed Text\e[0m"
echo -e "\e[32mGreen Text\e[0m"
echo -e "\e[33mBrown Text\e[0m"
echo -e "\e[34mBlue Text\e[0m"
echo -e "\e[35mPurple Text\e[0m"
echo -e "\e[36mCyan Text\e[0m"
echo -e "\e[37mLight Gray Text\e[0m"

echo -e "\e[1mbold\e[0m"
echo -e "\e[3mitalic\e[0m"
echo -e "\e[3m\e[1mbold italic\e[0m"
echo -e "\e[4munderline\e[0m"
echo -e "\e[9mstrikethrough\e[0m"
echo -e "\e[31mHello World\e[0m"
echo -e "\x1B[31mHello World\e[0m"
clear -x
x=1

dependencies=("bash" "dialog" "gnutls-bin" "curl" "zenity")
## Install dependencies if necessary
if [[ $gui == "gui" ]]; then
  dpkg -s "${dependencies[@]}" >/dev/null 2>&1 || pkexec sh -c "apt update; apt upgrade -y; apt-get install $(echo "${dependencies[@]}")  -y; hash -r"
else
  dpkg -s "${dependencies[@]}" >/dev/null 2>&1 || sudo sh -c "apt update; apt upgrade -y; apt-get install $(echo "${dependencies[@]}")  -y; hash -r"
fi

#allow developer to set repository username and branch
#developers use export repository_username= and export repository_branch= for your own github username and branch of the L4T-Megascript
if [ -v $repository_username ] || [ $repository_username == cobalt2727 ]; then
  export repository_username=cobalt2727
else
  echo "Developer Mode Enabled! Repository = $repository_username"
fi
if [ -v $repository_branch ] || [ $repository_branch == master ]; then
  export repository_branch=master
else
  echo "Developer Mode Enabled! Branch = $repository_branch"
fi

#functions used by megascript scripts
function userinput_func {
  unset uniq_selection
  height=$(( $(echo "$description" | grep -o '\\n' | wc -l) + 8))
  if [[ $gui == "gui" ]]; then
     for string in "${@:2}"; do
      uniq_selection+=(FALSE "$string")
     done
     uniq_selection[0]=TRUE
     output=$(
          zenity \
          --text "$1" \
          --list \
          --radiolist \
          --column "" \
          --column "Selection" \
          --ok-label="OK" \
          "${uniq_selection[@]}" \
          --cancel-label "Cancel Choice"
        )
  else
    for string in "${@:2}"; do
      uniq_selection+=("$string" "")
    done
    output=$(dialog --clear \
                --backtitle "CLI Chooser Helper" \
                --title "Choices" \
                --menu "$1" \
                "$height" "120" "$($# - 1)" \
                "${uniq_selection[@]}" \
                2>&1 >/dev/tty)
  fi
  status=$?
  if [[ $status = "1" ]]; then
    clear -x
    echo "Canceling Install, Back to the Megascript"
    exit 1
  fi
  clear -x
}
export -f userinput_func

hidden=(2 8 9 10 11 12 13 22)

num=()
num[0]="Initial Setup"
num[1]="Auto Updater"
num[2]="Auto Config Updater"
num[3]="Dolphin"
num[4]="MultiMC (Minecraft Java)"
num[5]="Minecraft Bedrock"
num[6]="moonlight-qt"
num[7]="Discord"
num[8]="Kodi"
num[9]="Development IDEs"
#num[10]="Overscan Fix"
num[11]="Citra"
num[12]="empty"
num[13]="CSE2-Tweaks"
num[14]="SRB2"
num[15]="RetroPie"
num[16]="Celeste (Pico-8 Port)"
num[17]="Flappy Bird"
num[18]="supertux"
num[19]="SM64Port"
num[20]="SRB2Kart"
num[21]="Barrier"
num[22]="extra"

length=${#num[@]}

t=()
t[0]="Installs the joycon mouse, flatpak repo, SDL2 etc"
t[1]="download and install updates from the repos (check this at least once daily!)"
t[2]="Update L4T Megascript autoconfigs for games (very helpful, [FILESIZE] download size though)"
t[3]="Gamecube and Wii emulator, latest development version"
t[4]="Mincraft Launcher, Instance, and Mod Manager"
t[5]="Android Minecraft Bedrock Version. Ownership of the Android Version Required"
t[6]="stream games from your PC as long as it has an Nvidia GPU!"
t[7]="Discord Web App"
t[8]="media center"
t[9]="write code on your Switch!"
#t[10]="i had the idea for an overscan fix here but that's something the user should fix in their TV settings, this is just a placeholder now"
t[11]="3DS emulator, currently confirmed broken on 18.04, should work when 20.04 releases!"
t[12]="empty"
t[13]="An enhanced version of Cave Story. 60 FPS, bug fixes, and alternate soundtrack support"
t[14]="A 3D open-source Sonic the Hedgehog fangame built using a modified version of Doom"
t[15]="Powerful frontend for both emulators and native programs alike"
t[16]="A tight platforming game which lead to the development of Celeste"
t[17]="A game about a bird flying in between warp pipes"
t[18]="A 2D jump'n run sidescroller game in a style similar to the original Super Mario games"
t[19]="A native port of the classic game for the N64 (requires a ROM)"
t[20]="A kart racing game based on the 3D Sonic the Hedgehog fangame SRB2"
t[21]="Share your mouse and keyboard between multiple computers"
t[22]="hidden stuff"

while [ $x == 1 ]; do
  cd ~
  available_space=$(df -PH . | awk 'NR==2 {print $4"B"}')
  clear -x

  if [[ $gui == "gui" ]]; then
    zenity --info --width="500" --height="250" --title "Welcome!" --text "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually! \n\nAdd a check from the choices in the GUI and then press INSTALL to configure the specified program."
    #echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
    zenity --warning --width="500" --height="250" --title "Welcome!" --text "You have $available_space of space left on your SD card! Make sure you don't use too much!"
    sleep 2

    table=()
    for ((i = 0; i < ${length}; i++)); do
      if [[ ! " ${hidden[@]} " =~ " ${i} " ]]; then
        table+=(FALSE $i "${num[$i]}" "${t[$i]}")
      fi
    done

    CHOICE=$(
      zenity \
      --width="1000" \
      --height="500" \
      --list \
      --checklist \
      --column "Install" \
      --column "Number" \
      --column "Program" \
      --column "Details" \
      --ok-label="INSTALL" \
      "${table[@]}" \
      --separator=':'
    )

    if [ "$?" != 1 ]; then
      sudo -k
      state="0"
      while [ "$state" == "0" ]; do
        zenity --password | sudo -S echo "" 2>&1 > /dev/null | grep -q "incorrect"
        state=$?
      done
    fi
    x=0
  else

    echo "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually!"
    echo
    echo "Enter a number from the choices below and then press ENTER to configure the specified program."
    #echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
    echo -e "\x1B[31mYou have about $available_space of space left on your Linux installation! Make sure you don't use too much!\e[0m"

    sleep 2
    #echo "note to self: get lakka firmware files and put in /lib/firmware - see L4T gbatemp release thread about that"
    echo
    echo

    echo "0...............***WIP***${num[0]} - ${t[0]}"
    echo "................(2 GB of open space required for the swapfile!)"

    for ((i = 1; i < ${length}; i++)); do
      if [[ ! " ${hidden[@]} " =~ " ${i} " ]]; then
        echo "$i...............${num[$i]} - ${t[$i]}"
      fi
    done

    echo "X...............Close L4T Megascript, view credits and source code, and get Discord support server link"
    echo
    echo
    read -p "Make a selection: " CHOICE
    if [[ $CHOICE == x || $CHOICE == X || $CHOICE == exit || $CHOICE == Exit ]]; then
      x=0
      continue
    else
      sudo -S echo ""
    fi

    echo "you have chosen $CHOICE"

  fi
  # https://unix.stackexchange.com/questions/261103/how-do-i-maintain-sudo-in-a-bash-script
  # initialize sudo password and extent timeout so we never run out
  IFS=":"
  while true; do
    sleep 60
    sudo -v
    kill -0 "$$" 2>/dev/null || exit
  done &
  for word in $CHOICE; do
    case $word in
    0) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/init.sh)" ;;
    1) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/update.sh)" ;;
    2) echo "go ping cobalt on discord and yell at me about getting an updater system working" ;;
    3) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/main.sh)" ;;
    4) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/minecraft_java_multimc.sh)" ;;
    5) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/minecraft-bedrock-appimage.sh)" ;;
    6) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/moonlight.sh)" ;;
    7) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/discord.sh)" ;;
    8) echo "scripts not ready yet" ;;
    9) echo "scripts not ready yet" ;;
    #10) echo "overscan is your own problem" ;;
    11) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/citra.sh)" ;;
    12) echo "empty for some reason" ;;
    13)
      echo "Unfortunately, the repository we use for setting up Cave Story is currently down due to a DMCA. Here's hoping GitHub restores it!"
      echo "Sending you back to the main menu..."
      ;;
    14) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/SRB2.sh)" ;;
    15) sudo bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/retropie_auto.sh)" ;;
    16) bash -c "$(curl -s https://raw.githubusercontent.com/theofficialgman/ccleste/upstream_edits/celeste_install.sh)" ;;
    17) bash -c "$(curl -s https://raw.githubusercontent.com/theofficialgman/flappy/master/flappy_install.sh)" ;;
    18) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/ST2.sh)" ;;
    19) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/SM64.sh)" ;;
    20) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/SRB2Kart.sh)" ;;
    21) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/extras/barrier.sh)" ;;
    22) bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/extras/core_extra.sh)" ;;

    esac
  done
done

if sudo -n true
then
  #create .desktop file for the megascript
  sudo rm -rf /usr/share/applications/L4T-Megascript.desktop
  sudo rm -rf /usr/share/icons/L4T-Megascript.png

  sudo curl https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/L4T_Megascript-logo-transparent.png --output /usr/share/icons/L4T-Megascript.png
  sudo curl https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/assets/L4T-Megascript.desktop --output /usr/share/applications/L4T-Megascript.desktop
  sudo chmod +x '/usr/share/applications/L4T-Megascript.desktop'
else
  echo "didn't add the L4T-Megascript.desktop file, Sudo timer ran out"
fi

if [[ $gui == "gui" ]]; then
  zenity --info --width="500" --height="250" --title "Bye" --text "Thank you for using the L4T Megascript!\n\nCredits:\nCobalt - Manager/Lead Dev\nLugsole - Contributor/GUI Manager\nLang Kasempo - Contributor/Beta Tester/did a lot of the standalone game scripts\nGman - Contributor/RetroPie script/Celeste native port\n\nthe Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"
fi

unset repository_username
unset repository_branch
unset gui

echo "Thank you for using the L4T Megascript!"
sleep 2
clear -x
echo "Credits:"
echo "CTRL + CLICK ON A LINK TO OPEN IT"
echo
echo -e "\e[38;2;0;71;171mCobalt - Manager/Lead Dev/Benevolent Dictator\e[0m"
echo -e "\e[38;2;$(shuf -i 0-255 -n 1);$(shuf -i 0-255 -n 1);$(shuf -i 0-255 -n 1)mLugsole - Contributor\e[0m"
echo -e "\e[35mLang Kasempo - Contributor/Beta Tester\e[0m"
echo -e "\e[32mGman - Contributor/Beta Tester\e[0m"
echo -e "All the contributors and beta testers that put up with Cobalt pinging them incessantly"
#echo "hey, if you're reading this, odds are you probably helped make the thing. you can add your name to the credits in your PRs!"
echo "the Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"

echo ""
echo -e 'Thank you for using the L4T Megascript! Stop by our \e[36mDiscord\e[0m server at [link not public yet] for support.'
echo 'Source code is available here: https://github.com/cobalt2727/L4T-Megascript/'
