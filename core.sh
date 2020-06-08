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

clear
#echo "create a desktop file for the script on this line"
echo "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually!"
echo
echo "Enter a number from the choices below and then press ENTER to configure the specified program."
echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
sleep 2
#echo "note to self: get lakka firmware files and put in /lib/firmware - see L4T gbatemp release thread about that"
echo
echo
#echo "0...............Initial setup - swapfile, joycon mouse, Bluetooth audio, USB controller support, 2.0 GHz overclock, etc"
echo "1...............Update your programs - download and install updates from the repos (check this at least once daily!)"
echo "2...............Dolphin - Gamecube and Wii emulator, latest development version"
#echo "3...............RetroArch - Not quite working yet, I don't have a collection of working cores"
#echo "4...............Minecraft - automatically install Luke Chambers's MCSwitchTools (https://gitlab.com/devluke/mcswitchtools)"
#echo "5...............moonlight-qt - stream games from your PC as long as it has an Nvidia GPU!"
#echo "6...............Discord setup - not the actual program, but the web app"
#echo "7...............Kodi - media center"
#echo "8...............Development IDEs - write code on your Switch!"
#echo "9...............Video Settings - Is your display going past the edges of your TV?"
#echo "10..............Citra - 3DS emulator, this probably is completely broken"
echo "any other key...Close L4T Megascript, view credits and source code, and get Discord support server link"
echo
echo
read -p "Make a selection: " userInput

echo "you have chosen $userInput"
if [[ $userInput == 0 ]]; then
  echo "This is where the initial setup script will be!"
  #  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/init.sh)"
  
elif [[ $userInput == 1 ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/apt.sh)"


elif [[ $userInput == 2 ]]; then
  bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/scripts/dolphin/main.sh)"

else
  echo ""
fi

echo "Thank you for using the L4T Megascript!"
sleep 2
clear
echo "Credits:"
echo "CTRL + CLICK ON A LINK TO OPEN IT"
echo
echo -e "\e[34mCobalt - Manager/Lead Coder\e[0m"

#echo "put other people that helped me write this here later if anyone gives some suggestions
echo "the Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"
echo "https://twitter.com/jsjfree34/ - MASSIVE help in testing and giving me the idea for this in the first place"
#echo "credit everyone else here later when it's not 2 AM"
echo ""
echo -e 'Thank you for using the L4T Megascript! Stop by our \e[36mDiscord\e[0m server at https://tinyurl.com/L4TScript for support.'
echo 'If that link is down for whatever reason, use https://discord.gg/UYsUFCY.'
echo 'Source code is available here: https://github.com/cobalt2727/L4T-Megascript/'
