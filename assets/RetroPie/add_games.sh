#!/bin/bash

total_start_time=$(date +%s.%3N)
param=("/usr/share/applications/" "$HOME/.local/share/applications/" "$HOME/.local/share/flatpak/exports/share/applications/" "/usr/local/share/applications/")
mkdir -p ~/RetroPie/roms/ports
mkdir -p "$HOME/.emulationstation/gamelists/ports"
cd ~/RetroPie/roms/ports
cp list.txt list_old.txt
rm -rf list.txt
total=0

config="$HOME/.emulationstation/gamelists/ports/gamelist.xml"
if [[ ! -f "$config" ]]; then
	echo "<gameList />" >"$config"
fi	

for ((j = 0; j < "${#param[@]}"; j++)); do
	FILES=("${param[j]}"*.desktop)
	for ((i = 0; i < "${#FILES[@]}"; i++)); do
		if grep -i -P "^[Cc]ategories[=].*[Gg]ame.*" "${FILES[i]}"; then
			if grep -i -P "^[Nn]o[Dd]isplay[=].*[Tt]rue.*" "${FILES[i]}"; then
				echo ""
			else
				start_time=$(date +%s.%3N)
				filename="$(echo ${FILES[i]} | grep -o ".*.desktop" | rev | cut -f 1 -d / | rev)"
				desktop_name="$filename"
				filename="$(echo $filename | grep -oP '.*?(?=\.desktop)' | sed -e 's/ /_/g')"
				echo '# this is a hacky way to get the terminal to un-fullscreen' >$filename".sh"
				echo 'hexNum=$(wmctrl -lp | grep "$(pidof gnome-terminal-server)" | grep "Terminal" | head -n 1 | awk {'"'"'print $1}'"'"')' >>$filename".sh"
				echo 'xdotool windowactivate --sync $(( $hexNum )) key F11' >>$filename".sh"
				echo 'nohup $(gtk-launch ' '"'"$desktop_name"'")' >>$filename".sh"
				echo 'xdotool windowactivate --sync $(( $hexNum )) key F11' >>$filename".sh"

				chmod +x "$filename"".sh"
				echo "$filename" >>list.txt
				path='./'"$filename"".sh"
				
				# name="$(crudini --get "${FILES[i]}" "Desktop Entry" "name")"
				# desc="$(crudini --get "${FILES[i]}" "Desktop Entry" "comment")"
				# image="$(crudini --get "${FILES[i]}" "Desktop Entry" "icon")"
				
				name="$(cat "${FILES[i]}" | sed -ne '/[Desktop Entry]/,$ p' | sed -n -e 's/^Name=//p' | sed -n '1p')"
				desc="$(cat "${FILES[i]}" | sed -ne '/[Desktop Entry]/,$ p' | sed -n -e 's/^Comment=//p' | sed -n '1p')"
				image="$(cat "${FILES[i]}" | sed -ne '/[Desktop Entry]/,$ p' | sed -n -e 's/^Icon=//p' | sed -n '1p')"

				if echo "$image" | grep '/'; then
					echo "icon already is path"
				else
					image_path=""
					image_path="$(xmlstarlet sel -t -v "/gameList/game[path='$path']/image" "$config")"
					echo ""
					echo "$path"
					echo "$image_path"
					echo ""
					if [ -f "$image_path" ]; then
						echo "icon already set"
						image="$image_path"
					else
						echo "python needed for icon path"
						image="$(./get-icon-path.py "$image" | tail -2)"
					fi
				fi
				if [[ $(xmlstarlet sel -t -v "count(/gameList/game[path='$path'])" "$config") -eq 0 ]]; then
					xmlstarlet ed -L -s "/gameList" -t elem -n "game" -v "" \
							-s "/gameList/game[last()]" -t elem -n "path" -v "$path" \
							-s "/gameList/game[last()]" -t elem -n "name" -v "$name" \
							-s "/gameList/game[last()]" -t elem -n "desc" -v "$desc" \
							-s "/gameList/game[last()]" -t elem -n "image" -v "$image" \
							"$config"
				else
					# remove current occurances of name, desc, and image
					xmlstarlet ed -L -d "/gameList/game[path='$path']/name" -d "/gameList/game[path='$path']/desc" -d "/gameList/game[path='$path']/image" "$config"

					# add name, desc, and image
					xmlstarlet ed -L \
							-s "/gameList/game[path='$path']" -t elem -n "name" -v "$name" \
							-s "/gameList/game[path='$path']" -t elem -n "desc" -v "$desc" \
							-s "/gameList/game[path='$path']" -t elem -n "image" -v "$image" \
							"$config"
				fi
				end_time=$(date +%s.%3N)
				elapsed=$(echo "scale=3; $end_time - $start_time" | bc)
				echo ""
				echo "iteration time: $elapsed"
				echo ""
				total=$(echo "$total + $elapsed" | bc)
			fi
		fi
	done
done

grep -Fxv -f list.txt list_old.txt >delete.txt
for f in $(cat delete.txt); do rm "$f.sh"; done
rm -rf delete.txt
rm -rf list_old.txt
rm -rf retropie.sh
total_end_time=$(date +%s.%3N)
elapsed=$(echo "scale=3; $total_end_time - $total_start_time" | bc)
echo ""
echo "total time: $elapsed"
echo ""
echo "calculated sum: $total"
