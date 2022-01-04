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
You're in luck - we've got a Discord server: <a href="https://discord.gg/abgW2AG87Z">
    Join the <img src="https://img.shields.io/discord/719014537277210704.svg?color=7289da&label=Discord%20server&logo=discord" alt="Join the Discord server"></a>

### Below is a list of supported Megascript install scripts with a short description and link to the source.
[Games and Emulators](https://github.com/cobalt2727/L4T-Megascript/wiki#games-and-emulators)
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
        fl="$(echo "$f" | sed -e 's/_/-/g')"
        if [[ "$ff" != "$prev_f" ]];then
            echo '['"$ff"']((https://github.com/cobalt2727/L4T-Megascript/wiki#'"$fl"')'
        fi
        if [ "$f" != "scripts" ]; then
            f="scripts/$f"
        fi
        prev_f="$ff"
      fi
    fi
  done

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
