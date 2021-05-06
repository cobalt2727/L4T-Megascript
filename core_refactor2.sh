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

conversion () {
for ((i = 1; i <= ${length}; i++)); do
if [[ ! " ${hidden[@]} " =~ " ${i} " ]]; then
  fn=""; d="";  e=""; f=""; sn=""
  eval "$( sed -n $i"p" < "/tmp/megascript_apps.txt" | tr ";" "\n" )"
  scripts[$i]=$sn
  if [ "$f" = "scripts" ]; then
    folder[$i]=$f
  else
    folder[$i]="scripts/$f"
  fi
  execute[$i]=$e
  if [[ $gui == "gui" ]]; then
    table+=(FALSE $i "$fn" "$d")
  else
    echo "$i...............$fn - $d"
  fi
fi
done
}

hidden=()
rm -rf /tmp/megascript_apps.txt
wget https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/megascript_apps.txt -O /tmp/megascript_apps.txt
sed -i '/^$/d' /tmp/megascript_apps.txt
length=$( wc -l "/tmp/megascript_apps.txt" | awk '{ print $1 }' )

while [ $x == 1 ]; do
  cd ~
  available_space=$(df -PH . | awk 'NR==2 {print $4"B"}')
  clear

  if [[ $gui == "gui" ]]; then
    zenity --info --width="500" --height="250" --title "Welcome!" --text "Welcome back to the main menu of the L4T Megascript, $USER. This isn't quite finished yet - we'll be ready eventually! \n\nAdd a check from the choices in the GUI and then press INSTALL to configure the specified program."
    #echo -e "\x1B[31mKeep in mind how much storage you have left on your SD card!\e[0m"
    zenity --warning --width="500" --height="250" --title "Welcome!" --text "You have $available_space of space left on your SD card! Make sure you don't use too much!"
    sleep 2

    table=()
    scripts=()
    folder=()
    execute=()
    conversion

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

    table=()
    scripts=()
    folder=()
    execute=()
    conversion

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
    if [ -z ${execute[$word]} ]; then
      bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/${folder[$word]}/${scripts[$word]})"
    else
      eval "${execute[$word]}"
    fi

  done
done

if [[ $gui == "gui" ]]; then
  zenity --info --width="500" --height="250" --title "Bye" --text "Thank you for using the L4T Megascript!\n\nCredits:\nCobalt - Manager/Lead Dev\nLugsole - Contributor/GUI Manager\nLang Kasempo - Contributor/Beta Tester/did a lot of the standalone game scripts\nGman - Contributor/RetroPie script/Celeste native port\n\nthe Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"
fi

unset repository_username
unset repository_branch

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
echo -e "All the contributors and beta testers that put up with Cobalt pinging them incessantly"
#echo "hey, if you're reading this, odds are you probably helped make the thing. you can add your name to the credits in your PRs!"
echo "the Switchroot L4T Ubuntu team (https://switchroot.org/) - making the actual OS you're running right now"

echo ""
echo -e 'Thank you for using the L4T Megascript! Stop by our \e[36mDiscord\e[0m server at [link not public yet] for support.'
echo 'Source code is available here: https://github.com/cobalt2727/L4T-Megascript/'
