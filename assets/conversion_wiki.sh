rm -rf /tmp/megascript_apps.txt
wget https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/megascript_apps.txt -O /tmp/megascript_apps.txt
sed -i '/^$/d' /tmp/megascript_apps.txt
length=$(wc -l "/tmp/megascript_apps.txt" | awk '{ print $1 }')
prev_f=""
conversion() {

  cat << EOF 
## Welcome to the L4T Megascript wiki! Use the sidebar on your right to navigate through here.
### (or start with the [initial setup](https://github.com/cobalt2727/L4T-Megascript/wiki/Initial-Setup) )

### Need some help or want to contribute?
You're in luck - we've got a Discord server: <Br>
[![Discord invite](https://discord.com/assets/ff41b628a47ef3141164bfedb04fb220.png)](https://discord.gg/abgW2AG87Z "Discord server invite link") <Br>
[Click to join](https://discord.gg/abgW2AG87Z) <Br>

### Below is a list of supported Megascript install scripts with a short description and link to the source.
EOF

  for ((i = 1; i <= ${length}; i++)); do
    if [[ ! " ${hidden[@]} " =~ " ${i} " ]]; then
      fn=""
      d=""
      e=""
      f=""
      sn=""
      line=$(sed -n $i"p" <"/tmp/megascript_apps.txt")
      if [[ "$line" != \#* ]]; then
        eval "$(echo "$line" | tr ";" "\n")"
        ff="$(echo "$f" | sed -e 's/_/ /g' | sed -e "s/\b\(.\)/\u\1/g")"
        if [[ "$ff" != "$prev_f" ]];then
            echo "## $ff"
        fi
        if [ "$f" != "scripts" ]; then
            f="scripts/$f"
        fi
        echo "**[$fn](https://github.com/cobalt2727/L4T-Megascript/blob/master/$f/$sn)**: $d "
        echo ""
        prev_f="$ff"
      fi
    fi
  done
}
clear
conversion > Home.md
