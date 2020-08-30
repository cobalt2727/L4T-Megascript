#!/usr/bin/env bash
cd ~
available_space=$(df -PH . | awk 'NR==2 {print $4"B"}')
clear
echo "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually!"
echo
echo "Add a check from the choices in the GUI and then press INSTALL to configure the specified program."
#echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
echo -e "\x1B[31mYou have $available_space of space left on your SD card! Make sure you don't use too much!\e[0m"

sleep 2

CHOICE=$(zenity \
	--width="1000"\
	--height="500"\
    --list \
    --checklist \
    --column "Install" \
    --column "Program" \
    --column "Details" \
    --ok-label="INSTALL"\
    FALSE RetroPie "Powerful frontend for both emulators and native programs alike"\
    FALSE "Celeste (Pico-8 Port)" "A tight platforming game which lead to the development of Celeste" \
    FALSE "Flappy Bird" "A game about a bird flying in between warp pipes" \
    FALSE "moonlight-qt" "stream games from your PC as long as it has an Nvidia GPU!"\
    FALSE "FlightGear" "Free, open source flight simulator (3 GB DOWNLOAD)"\
    FALSE "Dolphin" "Gamecube and Wii emulator, latest development version"\
    FALSE "SRB2" "A 3D open-source Sonic the Hedgehog fangame built using a modified version of Doom"\
    FALSE "CSE2" "An enhanced version of Cave Story. 60 FPS and other soundtracks support"\
    FALSE "Citra" "3DS emulator, currently broken")
    


if ["$?" != 0 ]
then
PRIVATE=`zenity --password`
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/sdl2_install_helper.sh | bash
fi
if echo $CHOICE | grep -q "RetroPie";
then echo "install retropie..."
#zenity --progress --text="Installing retropie" --percentage=0 | 
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/theofficialgman/RetroPie-Setup/master/auto_install.sh | bash
#zenity --info --text="Sucessfully installed"
fi
if echo $CHOICE | grep -q "Celeste (Pico-8 Port)"
then echo "install celeste..."
#zenity --progress --text="Installing celeste" --percentage=0 | 
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/theofficialgman/ccleste/master/celeste_install.sh | bash
#zenity --info --text="Sucessfully installed"
fi
if echo $CHOICE | grep -q "Flappy Bird"
then echo "install flappy bird..."
#zenity --progress --text="Installing flappy bird" --percentage=0 | 
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/theofficialgman/flappy/master/flappy_install.sh | bash
#zenity --info --text="Sucessfully installed"
fi
if echo $CHOICE | grep -q "moonlight-qt"
then echo "install moonlight..."
#zenity --progress --text="Installing moonlight" --percentage=0 | 
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/moonlight.sh | bash
#zenity --info --text="Sucessfully installed"
fi
if echo $CHOICE | grep -q "FlightGear"
then echo "install FlightGear..."
#zenity --progress --text="Installing FlightGear" --percentage=0 |
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/flightgear.sh | bash
#zenity --info --text="Sucessfully installed"
fi
if echo $CHOICE | grep -q "CSE2"
then echo "install CSE2..."
#zenity --progress --text="Installing CSE2" --percentage=0 |
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/CSE2.sh | bash
#zenity --info --text="Sucessfully installed"
fi
if echo $CHOICE | grep -q "SRB2"
then echo "install SRB2..."
#zenity --progress --text="Installing SRB2" --percentage=0 | 
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/SRB2.sh | bash
#zenity --info --text="Sucessfully installed"
fi
if echo $CHOICE | grep -q "Citra"
then echo "install Citra..."
#zenity --progress --text="Installing Citra" --percentage=0 |
echo $PRIVATE | sudo -S curl -L https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/citra.sh | bash
#zenity --info --text="Sucessfully installed"
fi

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

echo ""
echo -e 'Thank you for using the L4T Megascript! Stop by our \e[36mDiscord\e[0m server at https://tinyurl.com/L4TScript for support.'
echo 'If that link is down for whatever reason, use https://discord.gg/UYsUFCY.'
echo 'Source code is available here: https://github.com/cobalt2727/L4T-Megascript/'

exit 0
