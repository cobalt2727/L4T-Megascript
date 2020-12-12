##Import config files
cd ~
cd .config/
mkdir dolphin-emu
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin-Config
cd Dolphin-Config/
ls
mv *.ini ../dolphin-emu/
cd ..
rm -rf Dolphin-Config/
cd ~

##Import themes, game-specific settings, etc
##why does dolphin store these separately from the above files on Linux smh
cd .local/share/
mkdir dolphin-emu
cd dolphin-emu/
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin
cd Dolphin/
mv * ..
cd ..
rm -rf Dolphin/
cd ~
