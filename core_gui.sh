#!/usr/bin/env bash
cd ~
available_space=$(df -PH . | awk 'NR==2 {print $4"B"}')
clear

#allow developer to set repository username and branch
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
zenity --info --width="500" --height="250" --title "Welcome!" --text "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually! \n\nAdd a check from the choices in the GUI and then press INSTALL to configure the specified program."
#echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
zenity --warning --width="500" --height="250" --title "Welcome!" --text "You have $available_space of space left on your SD card! Make sure you don't use too much!"
sleep 2

num1="Initial Setup"
num2="RetroPie"
num3="Celeste (Pico-8 Port)"
num4="Flappy Bird"
num5="moonlight-qt"
num6="Dolphin"
num7="SRB2"
num8="CSE2-Tweaks"
num9="SM64Port"


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
    TRUE 1 "$num1" "Installs the swapfile, joycon mouse, 2.0 GHz overclock(in the future), SDL2 etc"\
    FALSE 2 "$num2" "Powerful frontend for both emulators and native programs alike"\
    FALSE 3 "$num3" "A tight platforming game which lead to the development of Celeste" \
    FALSE 4 "$num4" "A game about a bird flying in between warp pipes" \
    FALSE 5 "$num5" "stream games from your PC as long as it has an Nvidia GPU!"\
    FALSE 6 "$num6" "Gamecube and Wii emulator, latest development version"\
    FALSE 7 "$num7" "A 3D open-source Sonic the Hedgehog fangame built using a modified version of Doom"\
    FALSE 8 "$num8" "An enhanced version of Cave Story. 60 FPS and other soundtracks support"\
    FALSE 9 "$num9" "A native port of the classic game for the N64 (requieres a ROM)"\
    --separator=':')

if [ "$?" != 1 ]
then
PRIVATE=`zenity --password`
fi

IFS=":" ; for word in $CHOICE ; do 
   case $word in
      1) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/init.sh | bash ;;
      2) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/retropie_auto.sh | sudo bash ;;
      3) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/theofficialgman/ccleste/upstream_edits/celeste_install.sh | bash ;;
      4) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/theofficialgman/flappy/master/flappy_install.sh | bash ;;
      5) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/moonlight.sh | bash ;;
      6) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/main.sh | bash ;;
      7) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/SRB2.sh | bash ;;
      8) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/CSE2-Tweaks.sh | bash ;;
      9) echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/SM64.sh | bash ;;
   esac
done

zenity --info --width="500" --height="250" --title "Bye" --text "Thank you for using the L4T Megascript!\n\nCredits:\nCobalt - Manager/Lead Dev\nLugsole - Contributor/GUI Manager\nLang Kasempo - Contributor/Beta Tester/did a lot of the standalone game scripts\nGman - Contributor/RetroPie script/Celeste native port\n\nthe Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"

echo "Thank you for using the L4T Megascript!"
sleep 2
clear
echo "Credits:"
echo "CTRL + CLICK ON A LINK TO OPEN IT"
echo
echo -e "\e[38;2;0;71;171mCobalt - Manager/Lead Dev\e[0m"
echo -e "\e[38;2;$(shuf -i 0-255 -n 1);$(shuf -i 0-255 -n 1);$(shuf -i 0-255 -n 1)mLugsole - Contributor/GUI Manager\e[0m"
echo -e "\e[35mLang Kasempo - Contributor/Beta Tester/did a lot of the standalone game scripts\e[0m"
echo -e "\e[32mGman - Contributor/RetroPie script/Celeste native port\e[0m"
#echo "hey, if you're reading this, you probably helped make the thing. you can add stuff to your credits in your PRs if you want to!"
echo "the Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"

echo
echo -e 'Thank you for using the L4T Megascript! Stop by our \e[36mDiscord\e[0m server at https://tinyurl.com/L4TScript for support.'
echo 'If that link is down for whatever reason, use https://discord.gg/UYsUFCY.'
echo 'Source code is available here: https://github.com/cobalt2727/L4T-Megascript/'

echo -e 'Thank you for using the L4T Megascript! Stop by our \e[36mDiscord\e[0m server at https://tinyurl.com/L4TScript for support.'
echo 'If that link is down for whatever reason, use https://discord.gg/UYsUFCY.'
echo 'Source code is available here: https://github.com/cobalt2727/L4T-Megascript/'

exit 0
