#!/bin/bash

echo "RPGMakerLinux-cicpoffs script started!"
echo -e "Credits: \e[36mhttps://github.com/bakustarver/rpgmakermlinux-cicpoffs\e[0m"

wget -qO- "https://raw.githubusercontent.com/bakustarver/rpgmakermlinux-cicpoffs/main/installgithub.sh" | bash
export PATH=$PATH:$HOME/.local/bin
sleep 1

echo "Done!"
