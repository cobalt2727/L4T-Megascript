clear
echo "These are here because I'm a lazy coder and i want an easy reference for text formatting in the menu - if you're able to read this inside the program, something is very wrong."
echo -e "\e[30mBlack Text\e[0m"
echo -e "\e[31mRed Text\e[0m"
echo -e "\e[32mGreen Text\e[0m"
echo -e "\e[33mBrown/Orange Text\e[0m"
echo -e "\e[34mBlue Text\e[0m"
echo -e "\e[35mPurple Text\e[0m"
echo -e "\e[36mCyan Text\e[0m"
echo -e "\e[37mLight Gray Text\e[0m"
echo -e "\e[1;30mDark Grey Text\e[0m"
echo -e "\e[1;31mLight Red Text\e[0m"
echo -e "\e[1;32mLight Green Text\e[0m"
echo -e "\e[1;33mYellow Text\e[0m"
echo -e "\e[1;34mLight Blue Text\e[0m"
echo -e "\e[1;35mLight Purple Text\e[0m"
echo -e "\e[1;36mLight Cyan Text\e[0m"
echo -e "\e[1;37mWhite Text\e[0m"

echo -e "\e[1mbold\e[0m"
echo -e "\e[3mitalic\e[0m"
echo -e "\e[3m\e[1mbold italic\e[0m"
echo -e "\e[4munderline\e[0m"
echo -e "\e[9mstrikethrough\e[0m"
echo -e "\e[31mHello World\e[0m"
echo -e "\x1B[31mHello World\e[0m"
#echo "create a desktop file for the script on this line"

while true
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

echo "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually!"
echo
echo "Enter a number from the choices below and then press ENTER to configure the specified program."
#echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
echo -e "\x1B[31mYou have about $available_space of space left on your Linux installation! Make sure you don't use too much!\e[0m"

sleep 2
#echo "note to self: get lakka firmware files and put in /lib/firmware - see L4T gbatemp release thread about that"
echo
echo
echo "0...............***WIP***Initial setup - swapfile, joycon mouse, 2.0 GHz overclock, SDL2, etc"
echo "................(2 GB of open space required for the swapfile!)"
echo "1...............Update your programs - download and install updates from the repos (check this at least once daily!)"
#echo "2...............Update L4T Megascript autoconfigs for games (very helpful, [FILESIZE] download size though)"
echo "3...............Dolphin - Gamecube and Wii emulator, latest development version"
#echo "4...............RetroArch - we've scrapped this idea in favor of RetroPie"
#echo "remind me to get a script working to sync save data between RetroPie/Arch if the user chooses to use regular RetroArch for whatever reason..."
#echo "5...............Minecraft - automatically install both Java and Bedrock versions (https://gitlab.com/devluke/mcswitchtools)"
echo "6...............moonlight-qt - stream games from your PC as long as it has an Nvidia GPU!"
#echo "7...............Discord setup - not the actual program, but the web app"
#echo "8...............Kodi - media center"
#echo "9...............Development IDEs - write code on your Switch!"
#echo "10..............i had the idea for an overscan fix here but that's something the user should fix in their TV settings, this is just a placeholder now"
echo "11..............Citra - 3DS emulator, currently confirmed broken on 18.04, should work when 20.04 releases!"
#echo "13..............CSE2-Tweaks (Git down due to DMCA, thanks Nicalis) - An enhanced version of Cave Story. 60 FPS, bug fixes, and alternate soundtrack support"
echo "14..............SRB2 - A 3D open-source Sonic the Hedgehog fangame built using a modified version of Doom"
echo "15..............RetroPie - Powerful frontend for both emulators and native programs alike"
echo "16..............Celeste (Pico-8 Port) - A tight platforming game which lead to the development of Celeste"
echo "17..............Flappy Bird - A game about a bird flying in between warp pipes"
echo "18..............SuperTux2 - A 2D jump'n run sidescroller game in a style similar to the original Super Mario games"
echo "19..............SM64Port - A native port of the classic game for the N64 (requires a ROM)"
echo "20..............SRB2Kart - A kart racing game based on the 3D Sonic the Hedgehog fangame SRB2"
echo "21..............TheXTech - Rewrite of the SMBX engine into C++ from VisualBasic 6."
#echo "extra...........Oh, you're looking around the source code? Try typing in "extra" in the console!"
echo "X...............Close L4T Megascript, view credits and source code, and get Discord support server link"
echo 
echo
read -p "Make a selection: " userInput

echo "you have chosen $userInput"

if [[ $userInput != X || $userInput != x || $userInput != exit || $userInput != Exit ]]; then
  cd ~
  mkdir -p RetroPie/roms/ports
fi

if [[ $userInput == 0 || $userInput == setup ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/init.sh)"
  
elif [[ $userInput == 1 || $userInput == update ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/update.sh)"

elif [[ $userInput == 2 ]]; then
  sudo apt install subversion
  clear
  echo "asset downloading probably going to be handled by individual scripts"
  echo "go ping cobalt on discord and yell at me about getting an updater system working"
  #something something svn
  sleep 4

elif [[ $userInput == 3 || $userInput == dolphin ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/dolphin/main.sh)"

elif [[ $userInput == 6 || $userInput == moonlight ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/moonlight.sh)"

elif [[ $userInput == 11 || $userInput == citra ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/citra.sh)"

elif [[ $userInput == 13 || $userInput == CSE2-Tweaks ]]; then 
echo "Unfortunately, the repository we use for setting up Cave Story is currently down due to a DMCA. Here's hoping GitHub restores it!"
echo "Sending you back to the main menu..."
sleep 1
  #bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/CSE2-Tweaks.sh)"
  
elif [[ $userInput == 14 || $userInput == SRB2 ]]; then 
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/SRB2.sh)"

elif [[ $userInput == 15 || $userInput == RetroPie ]]; then 
  #please don't change the sudo, my script is written with it in mind
  sudo bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/retropie_auto.sh)"

elif [[ $userInput == 16 || $userInput == Celeste ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/theofficialgman/ccleste/upstream_edits/celeste_install.sh)"

elif [[ $userInput == 17 || $userInput == FlappyBird ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/theofficialgman/flappy/master/flappy_install.sh)"
  
elif [[ $userInput == 18 || $userInput == SuperTux2 ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/ST2.sh)"
  
elif [[ $userInput == 19 || $userInput == SM64Port ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/SM64.sh)"

elif [[ $userInput == 20 || $userInput == SRB2Kart ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/SRB2Kart.sh)"

elif [[ $userInput == 21 || $userInput == TheXTech ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/TheXTech.sh)"
  
#well hello there
elif [[ $userInput == extra || $userInput == secret ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/extras/core_extra.sh)"



elif [[ $userInput == x || $userInput == X || $userInput == exit || $userInput == Exit ]]; then
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

exit 0
else
  echo ""
fi

done

