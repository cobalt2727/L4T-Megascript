#!/bin/bash

param=("/usr/share/applications/" "$HOME/.local/share/applications/" "$HOME/.local/share/flatpack/exports/share/applications/" "/usr/local/share/applications/")
mkdir ~/RetroPie/roms/ports
cd ~/RetroPie/roms/ports
cp list.txt list_old.txt
rm -rf list.txt
for (( j=0; j< "${#param[@]}"; j++));
do
	FILES=("${param[j]}"*.desktop)
	for (( i=0; i< "${#FILES[@]}"; i++));
	do
		if grep -i -P -e "^[Cc]ategories[=].*[Gg]ame.*" "${FILES[i]}"
		then
			if grep -i -P -e "^[Nn]o[Dd]isplay[=].*[Tt]rue.*" "${FILES[i]}"
			then
				echo ""
			else
				filename=$(echo ${FILES[i]} | grep -o ".*.desktop" | rev | cut -f 1 -d / | rev)
        desktop_name=$filename
        filename=$(echo $filename | grep -oP '.*?(?=\.desktop)' | sed -e 's/ /_/g')
        echo 'nohup $(gtk-launch ' '"'"$desktop_name"'")' > $filename".sh"

				chmod +x $filename".sh"
				echo "$filename" >>list.txt
				path_var='./'"$filename"".sh"
				name_var=$(crudini --get "${FILES[i]}" "Desktop Entry" "name")
				if cat $HOME/.emulationstation/gamelists/ports/gamelist.xml | grep "$name_var"
				then
					echo ""
				else
					comment_var=$(crudini --get "${FILES[i]}" "Desktop Entry" "comment")
					image_var=$(crudini --get "${FILES[i]}" "Desktop Entry" "icon")
					if echo "$image_var" | grep '/';
					then
						echo "no python"
					else
						echo "python needed"
						image_var=$(./get-icon-path.py $image_var | tail -2)
					fi
					CONTENT="\t<game>\n\t<path>$path_var</path>\n\t\t<name>$name_var</name>\n\t\t<desc>$comment_var</desc>\n\t\t<image>$image_var</image>\n\t</game>"
					C=$(echo $CONTENT | sed 's/\//\\\//g')
					sed -i "/<\/gameList>/ s/.*/${C}\n&/" $HOME/.emulationstation/gamelists/ports/gamelist.xml
				fi
			fi
		fi
	done
done

grep -Fxv -f  list.txt list_old.txt > delete.txt
for f in $(cat delete.txt) ; do    rm "$f.sh"; done
rm -rf delete.txt
rm -rf list_old.txt

rm -rf retropie.sh