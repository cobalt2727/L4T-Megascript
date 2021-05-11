#!/bin/bash


##Import config files
cd ~
sudo apt install subversion -y
cd .config/
mkdir -p dolphin-emu
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin-Config
cd Dolphin-Config/
ls
mv * ../dolphin-emu/
cd ..
rm -rf Dolphin-Config/
cd ~

##Import themes, game-specific settings, etc
##why does dolphin store these separately from the above files on Linux smh
cd .local/share/
mkdir -p dolphin-emu
cd dolphin-emu/
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin
cd Dolphin/
mv * ..
cd ..
rm -rf Dolphin/
cd ~
