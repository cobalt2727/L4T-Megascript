cd ~
cd .config
sudo mkdir dolphin-emu
sudo svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/Dolphin-Config
cd Dolphin-Config
ls
sudo mv *.ini ../dolphin-emu/
cd ..
sudo rm -rf Dolphin-Config
cd ~
