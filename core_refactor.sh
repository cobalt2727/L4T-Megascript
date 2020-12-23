gui=$1
clear
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
#echo "create a desktop file for the script on this line"
x=1

while [ $x == 1 ]
do
cd ~
available_space=$(df -PH . | awk 'NR==2 {print $4"B"}')
clear
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

num0="Initial Setup"
num1="Auto Updater"
num2="Auto Config Updater"
num3="Dolphin"
num4="RetroArch"
num5="Minecraft"
num6="moonlight-qt"
num7="Discord"
num8="Kodi"
num9="Development IDEs"
num10="Overscan Fix"
num11="Citra"
num12="empty"
num13="CSE2-Tweaks"
num14="SRB2"
num15="RetroPie"
num16="Celeste (Pico-8 Port)"
num17="Flappy Bird"
num18="supertux"
num19="SM64Port"
num20="SRB2Kart"
num21="TheXTech"
numextra="extra"

t0="Installs the swapfile, joycon mouse, 2.0 GHz overclock(in the future), SDL2 etc"
t1="download and install updates from the repos (check this at least once daily!)"
t2="Update L4T Megascript autoconfigs for games (very helpful, [FILESIZE] download size though)"
t3="Gamecube and Wii emulator, latest development version"
t4="we've scrapped this idea in favor of RetroPie"
t5="automatically install both Java and Bedrock versions (https://gitlab.com/devluke/mcswitchtools)"
t6="stream games from your PC as long as it has an Nvidia GPU!"
t7="not the actual program, but the web app"
t8="media center"
t9="write code on your Switch!"
t10="i had the idea for an overscan fix here but that's something the user should fix in their TV settings, this is just a placeholder now"
t11="3DS emulator, currently confirmed broken on 18.04, should work when 20.04 releases!"
t12="empty"
t13="An enhanced version of Cave Story. 60 FPS, bug fixes, and alternate soundtrack support"
t14="A 3D open-source Sonic the Hedgehog fangame built using a modified version of Doom"
t15="Powerful frontend for both emulators and native programs alike"
t16="A tight platforming game which lead to the development of Celeste"
t17="A game about a bird flying in between warp pipes"
t18="A 2D jump'n run sidescroller game in a style similar to the original Super Mario games"
t19="A native port of the classic game for the N64 (requires a ROM)"
t20="A kart racing game based on the 3D Sonic the Hedgehog fangame SRB2"
t21="Rewrite of the SMBX engine into C++ from VisualBasic 6."
textra="hidden stuff"

if [[ $gui == "gui" ]]; then
  zenity --info --width="500" --height="250" --title "Welcome!" --text "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually! \n\nAdd a check from the choices in the GUI and then press INSTALL to configure the specified program."
  #echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
  zenity --warning --width="500" --height="250" --title "Welcome!" --text "You have $available_space of space left on your SD card! Make sure you don't use too much!"
  sleep 2

  CHOICE=$(zenity \
    --width="1000"\
    --height="500"\
      --list \
      --checklist \
      --column "Install" \
      --column "Number" \
      --column "Program" \
      --column "Details" \
      --ok-label="INSTALL"\
      TRUE 0 "$num0" "$t0"\
      FALSE 1 "$num1" "$t1" \
      FALSE 2 "$num2" "$t2" \
      FALSE 3 "$num3" "$t3" \
      FALSE 4 "$num4" "$t4" \
      FALSE 5 "$num5" "$t5" \
      FALSE 6 "$num6" "$t6" \
      FALSE 7 "$num7" "$t7" \
      FALSE 8 "$num8" "$t8" \
      FALSE 9 "$num9" "$t9" \
      FALSE 10 "$num10" "$t10" \
      FALSE 11 "$num11" "$t11" \
      FALSE 12 "$num12" "$t12" \
      FALSE 13 "$num13" "$t13" \
      FALSE 14 "$num14" "$t14" \
      FALSE 15 "$num15" "$t15" \
      FALSE 16 "$num16" "$t16" \
      FALSE 17 "$num17" "$t17" \
      FALSE 18 "$num18" "$t18" \
      FALSE 19 "$num19" "$t19" \
      FALSE 20 "$num20" "$t20" \
      FALSE 21 "$num21" "$t21" \
      FALSE extra "$numextra" "$textra" \
      --separator=':')

  if [ "$?" != 1 ]
  then
  PRIVATE=`zenity --password`
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
  echo "0...............***WIP***$num0 - $t0"
  echo "................(2 GB of open space required for the swapfile!)"
  echo "1...............$num1 - $t1"
  echo "2...............$num2 - $t2"
  echo "3...............$num3 - $t3"
  echo "4...............$num4 - $t4"
  echo "5...............$num5 - $t5"
  echo "6...............$num6 - $t6"
  echo "7...............$num7 - $t7"
  echo "8...............$num8 - $t8"
  echo "9...............$num9 - $t9"
  echo "10...............$num10 - $t10"
  echo "11...............$num11 - $t11"
  echo "12...............$num12 - $t12"
  echo "13...............$num13 - $t13"
  echo "14...............$num14 - $t14"
  echo "15...............$num15 - $t15"
  echo "16...............$num16 - $t16"
  echo "17...............$num17 - $t17"
  echo "18...............$num18 - $t18"
  echo "19...............$num19 - $t19"
  echo "20...............$num20 - $t20"
  echo "21...............$num21 - $t21"
  echo "X...............Close L4T Megascript, view credits and source code, and get Discord support server link"
  echo 
  echo
  read -p "Make a selection: " CHOICE
  if [[ $CHOICE == x || $CHOICE == X || $CHOICE == exit || $CHOICE == Exit ]]; then
  x=0
  else
    read -p "Enter your password: " PRIVATE
  fi  

  echo "you have chosen $CHOICE"



fi

IFS=":" ; for word in $CHOICE ; do 
case $word in
    0) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/init.sh | bash ;;
    1) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/update.sh | bash ;;
    2) echo "go ping cobalt on discord and yell at me about getting an updater system working" ;;
    3) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/main.sh | bash ;;
    4) echo "we ditched RetroArch for Retropie, sorry" ;;
    5) echo "scripts not ready yet" ;;
    6) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/moonlight.sh | bash ;;
    7) echo "scripts not ready yet" ;;
    8) echo "scripts not ready yet" ;;
    9) echo "scripts not ready yet" ;;
    10) echo "overscan is your own problem" ;;
    11) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/citra.sh | bash ;;
    12) echo "empty for some reason" ;;
    13) echo "Unfortunately, the repository we use for setting up Cave Story is currently down due to a DMCA. Here's hoping GitHub restores it!"; echo "Sending you back to the main menu..." ;;
    14) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/SRB2.sh | bash ;;
    15) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/retropie_auto.sh | bash ;;
    16) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/theofficialgman/ccleste/upstream_edits/celeste_install.sh | bash ;;
    17) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/theofficialgman/flappy/master/flappy_install.sh | bash ;;
    18) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/ST2.sh | bash ;;
    19) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/SM64.sh | bash ;;
    20) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/SRB2Kart.sh | bash ;;
    21) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/TheXTech.sh | bash ;;
    extra)  echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/extras/core_extra.sh | bash ;;

esac
done


done
if [[ $gui == "gui" ]]; then
zenity --info --width="500" --height="250" --title "Bye" --text "Thank you for using the L4T Megascript!\n\nCredits:\nCobalt - Manager/Lead Dev\nLugsole - Contributor/GUI Manager\nLang Kasempo - Contributor/Beta Tester/did a lot of the standalone game scripts\nGman - Contributor/RetroPie script/Celeste native port\n\nthe Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"
fi

echo "Thank you for using the L4T Megascript!"
sleep 2
clear
echo "Credits:"
echo "CTRL + CLICK ON A LINK TO OPEN IT"
echo
echo -e "\e[38;2;0;71;171mCobalt - Manager/Lead Dev/Benevolent Dictator\e[0m"
echo -e "\e[38;2;$(shuf -i 0-255 -n 1);$(shuf -i 0-255 -n 1);$(shuf -i 0-255 -n 1)mLugsole - Contributor\e[0m"
echo -e "\e[35mLang Kasempo - Contributor/Beta Tester\e[0m"
echo -e "\e[32mGman - Contributor/Beta Tester\e[0m"
echo -e "Fafabis: Contributor"
echo -e "Quacka: Beta Tester"
#echo "hey, if you're reading this, odds are you probably helped make the thing. you can add your name to the credits in your PRs!"
echo "the Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"

echo ""
echo -e 'Thank you for using the L4T Megascript! Stop by our \e[36mDiscord\e[0m server at https://tinyurl.com/L4TScript for support.'
echo 'If that link is down for whatever reason, use https://discord.gg/UYsUFCY.'
echo 'Source code is available here: https://github.com/cobalt2727/L4T-Megascript/'




