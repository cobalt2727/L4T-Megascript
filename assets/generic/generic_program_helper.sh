# Generic application .desktop helper (works for Box64 Too)
clear -x

zenity --info --width="500" --height="250" --title "Generic application adder helper" \
    --text "This script will assist you in adding your arm64 (or x86_64 with Box64) applications/programs/games to your applications list \n\All you need to do is follow some simple prompts in the GUI \n\Note: If using box64, you should verify that box64 can launch your program successfully before using this script" --window-icon=/usr/share/icons/L4T-Megascript.png
program_path=$(zenity --file-selection --title="Choose your binary program/game")
path=$(zenity --file-selection --directory --title="Choose your path for program/game to run from (usually the directly which the program files reside in)")
image_path=$(zenity --file-selection --title="Choose the image to represent your application/game (png/ico) file)")
name=$(zenity --entry --text="Enter the name of your program/application/game:" --title="Name")
declare -n selection=(TRUE "Game" FALSE "System" FALSE "Audio" FALSE "Video" FALSE "Development" FALSE "Education" FALSE "Graphics" FALSE "Network" FALSE "Office" FALSE "Science" FALSE "Settings" FALSE "Utility") 
category=$(
zenity \
    --width="1000" \
    --height="500" \
    --text "Chose a category(s) for your application/program/game" \
    --title "Category" \
    --window-icon=/usr/share/icons/L4T-Megascript.png \
    --list \
    --checklist \
    --column "Selection" \
    --column "Category" \
    --ok-label="Done" \
    "${selection[@]}" \
    --separator=';' \
    --cancel-label "Cancel Helper" \
)
if [ $? -eq 0 ]; then
tee "$HOME/.local/share/applications/$name.desktop" <<EOF
[Desktop Entry]
Name=$name
Exec=$program_path
Path=$path
Icon=$image_path
Type=Application
Categories=$category
Terminal=false
EOF
working=$(zenity --width 750 --question \
--title="Application .desktop file created" \
--text="Please test out your application ($name) NOW to make sure it is working \n\If the application launches, then answer 'IT WORKED' and if it didn't then select 'ITS BROKEN' and the .desktop file will be deleated." \
--ok-label "IT WORKED" \
--cancel-label "ITS BROKEN")
if [[ $? -ne 0 ]]; then
    rm "$HOME/.local/share/applications/$name.desktop"
    zenity --info --width="500" --height="250" --title "Removal Success" \
    --text "$HOME/.local/share/applications/$name.desktop has been removed"
else
    zenity --info --width="500" --height="250" --title "Application Success" \
    --text "$HOME/.local/share/applications/$name.desktop has successfully added"
fi
fi