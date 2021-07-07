# Box64 application .desktop helper

zenity --info --width="500" --height="250" --title "Box64 application adder helper" \
    --text "This script will assist you in adding your x86_64 applications/programs/games to your applications list \n\All you need to do is follow some simple prompts in the GUI \n\You should verify that box64 can launch your program successfully before using this script" --window-icon=/usr/share/box64/icon.png
program_path=$(zenity --file-selection --title="Choose your x86_64 binary program/game")
path=$(zenity --file-selection --directory --title="Choose your path for program/game to run from (usually the directly which the program files reside in)")
image_path=$(zenity --file-selection --title="Choose the image to represent your application/game (png/ico file)")
name=$(zenity --entry --text="Enter the name of your program/application/game:" --title="Name")
declare -n selection=(TRUE "Game" FALSE "System" FALSE "Audio" FALSE "Video" FALSE "Development" FALSE "Education" FALSE "Graphics" FALSE "Network" FALSE "Office" FALSE "Science" FALSE "Settings" FALSE "Utility") 
category=$(
zenity \
    --width="1000" \
    --height="500" \
    --text "Chose a category(s) for your application/program/game" \
    --title "Category" \
    --window-icon=/usr/share/box64/icon.png \
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
Exec=box64 "$program_path"
Path=$path
Icon=$image_path
Type=Application
Categories=$category
Terminal=hidden
EOF
fi