#!/bin/bash
# Download and install Mods compatible with minecraft version

wget -q --spider https://github.com && wget -q --spider https://raw.githubusercontent.com/

# only run update/install script if the user has an active internet connection
if [ $? == 0 ]
then
	megascript_mods=$(sed -n "p" <"/home/$USER/MultiMC/scripts/megascript-mods.txt")
	user_mods=$(sed -n "p" <"/home/$USER/MultiMC/scripts/user-mods.txt")
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
            --borders="20" --center --fixed\
            --window-icon=/usr/share/icons/L4T-Megascript.png \
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
            --borders="20" --center --fixed\
            --window-icon=/usr/share/icons/L4T-Megascript.png \
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
	echo -e "The megascript uses Minecraft Mod Manager to keep all your Mods up to date and install a pregenerated list of Fabric Mods.\
Do you want to update/install the following Mods: \n\n$minecraft_mods_list\n\n\n\
If this list above is emtpty, you haven't clicked (Yes, Update/Install My Mods and Megascript Suggested Fabric mods) before, you should do that to install suggested performance mods.\
\n\nMake sure you have already clicked the Install Fabric button (or Forge button if you are supplying your own mods) otherwise these mods won't activate!\n\n\
You might want to select the (Yes, Update/Install ONLY My Mods) button if you plan on using forge mods. This button will skip the pregenerated list of Fabric mods" | yad --image "dialog-question" \
	--borders="20" --center --fixed\
	--window-icon=/usr/share/icons/L4T-Megascript.png \
	--text-info --fontname="@font@ 11" --wrap --width=800 --height=500 \
	--show-uri \
	"$add_button" \
    --button="Yes, Update/Install ONLY My Mods":1 \
	--button="No, skip this and save time":2
	
	case "$?" in
        "0")
            echo "Selected: Update/Install My Mods and Megascript Suggested Fabric mods"
            echo "Downloading latest gamecontrollerdb.txt"
            wget "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt" -O ../config/gamecontrollerdb_temp.txt && rm -rf ../config/gamecontrollerdb.txt && mv ../config/gamecontrollerdb_temp.txt ../config/gamecontrollerdb.txt
            echo "Patching gamecontrollerdb.txt for combined joycons to work around bug in lwjgl3"
            echo "060000004e696e74656e646f20537700,Nintendo Combined Joy-Cons 2 (joycond),a:b0,b:b1,back:b9,dpdown:b15,dpleft:b16,dpright:b17,dpup:b14,leftshoulder:b5,leftstick:b12,lefttrigger:b7,leftx:a0,lefty:a1,rightshoulder:b6,rightstick:b13,righttrigger:b8,rightx:a2,righty:a3,start:b10,x:b3,y:b2,platform:Linux," >> ../config/gamecontrollerdb.txt
            minecraft-mod-manager -v "$mc_version" --mod-loader fabric --beta --alpha install $megascript_mods $user_mods
            minecraft-mod-manager -v "$mc_version" --mod-loader fabric --beta --alpha update
            ;;
        "1")
            echo "Selected: Update/Install ONLY My Mods"
            echo "Downloading latest gamecontrollerdb.txt"
            wget "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt" -O ../config/gamecontrollerdb_temp.txt && rm -rf ../config/gamecontrollerdb.txt && mv ../config/gamecontrollerdb_temp.txt ../config/gamecontrollerdb.txt
            echo "Patching gamecontrollerdb.txt for combined joycons to work around bug in lwjgl3"
            echo "060000004e696e74656e646f20537700,Nintendo Combined Joy-Cons 2 (joycond),a:b0,b:b1,back:b9,dpdown:b15,dpleft:b16,dpright:b17,dpup:b14,guide:b11,leftshoulder:b5,leftstick:b12,lefttrigger:b7,leftx:a0,lefty:a1,rightshoulder:b6,rightstick:b13,righttrigger:b8,rightx:a2,righty:a3,start:b10,x:b3,y:b2,platform:Linux," >> ../config/gamecontrollerdb.txt
            minecraft-mod-manager -v "$mc_version" --beta --alpha update
            ;;
        "2")
            echo "Skipped Mod install/update"
            ;;
	esac
fi
echo "Mod script finished or skipped"