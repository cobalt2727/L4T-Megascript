rm -rf /tmp/megascript_apps.txt
wget https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/megascript_apps.txt -O /tmp/megascript_apps.txt
sed -i '/^$/d' /tmp/megascript_apps.txt
length=$(wc -l "/tmp/megascript_apps.txt" | awk '{ print $1 }')
prev_f=""
conversion() {
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
conversion
