##Import config files
cd ~
cd .config/
sudo mkdir dolphin-emu
sudo svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin-Config
cd Dolphin-Config/
ls
sudo mv *.ini ../dolphin-emu/
cd ..
sudo rm -rf Dolphin-Config/
cd ~

##Import themes, game-specific settings, etc
##why does dolphin store these separately from the above files on Linux smh
cd .local/share/
sudo mkdir dolphin-emu
cd dolphin-emu/
sudo svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin
cd Dolphin/
sudo mv * ..
cd ..
sudo rm -rf Dolphin/
