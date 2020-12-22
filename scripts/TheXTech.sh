cd
clear
echo "TheXTech script started!"
echo -e "\e[31mMMMMMMMMMMmmmmmmmmmmmmMMMMMMMMMM
MMMMMMmmmm    hhhh    mmmmMMMMMM
MMMMmmhh      yyyy      hhmmMMMM
MMmmhhyy    yyyyyyyy    yyhhmmMM
MMmm  yyyyyy++++++++yyyyyy  mmMM
mm      yy++        ++yy      mm
mm      yy            yy      mm
mm      yy            yy      mm
mm    yyyy            yyyy    mm
mmhhyyhhhhhh        hhhhhhyyhhmm
mmhhhhmmmmmmmmmmmmmmmmmmmmhhhhmm
MMmmmmmm----mm----mm----mmmmmmMM
MMMMmm--    mm    mm    --mmMMMM
MMMMmm--                --mmMMMM
MMMMMMmm----------------mmMMMMMM
MMMMMMMMmmmmmmmmmmmmmmmmMMMMMMMM\e[0m"
sudo rm -r /usr/share/TheXTech 
cd /usr/share/applications
sudo rm "Super Mario Bros X.desktop"
echo "Downloading the files and installing needed dependencies..."
sleep 3
cd 
sudo apt install -y cmake ninja-build gcc git mercurial p7zip-full libpng-dev libjpeg-dev
hash -r
git clone https://github.com/Wohlstand/TheXTech.git
cd TheXTech
git submodule init
git submodule update
git pull
mkdir build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug -DUSE_SYSTEM_LIBS=OFF -DUSE_FREEIMAGE_SYSTEM_LIBS=ON ..
echo
echo -e "\e[31mThis will take a while, please wait, if it seems like it is stuck it is not so please have patience.\e[0m"
echo
ninja
cd
if [ ! -d ~/.PGE_Project/thextech/ ]; then
mkdir -p ~/.PGE_Project/thextech/
cd ~/.PGE_Project/thextech
wget https://wohlsoft.ru/TheXTech/_downloads/thextech-smbx13-assets.7z
7z x thextech-smbx13-assets.7z
rm thextech-smbx13-assets.7z
fi
cd ~/TheXTech/build/
cd output 
rm -r include
cd ..
mv output TheXTech
sudo mv TheXTech -t /usr/share 
cd 
sudo rm -r TheXTech
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/TheXTech
cd TheXTech
sudo mv "Super Mario Bros X.desktop" -t /usr/share/applications
sudo mv TheXTech-Icon.png -t /usr/share/TheXTech 
rm -r TheXTech
echo
echo "Game Installed!"
echo "[NOTE] Remember NOT to move the TheXTech folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo
echo "Sending you back to the main menu..."
sleep 1
