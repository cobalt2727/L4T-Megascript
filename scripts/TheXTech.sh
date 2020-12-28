cd
clear
echo "TheXTech script started!"
echo -e "\e[31m          mmmmmmmmmmmm          
      mmmm    hhhh    mmmm      
    mmhh      yyyy      hhmm    
  mmhhyy    yyyyyyyy    yyhhmm  
  mm  yyyyyy++++++++yyyyyy  mm  
mm      yy++        ++yy      mm
mm      yy            yy      mm
mm      yy            yy      mm
mm    yyyy            yyyy    mm
mmhhyyhhhhhh        hhhhhhyyhhmm
mmhhhhmmmmmmmmmmmmmmmmmmmmhhhhmm
  mmmmmm----mm----mm----mmmmmm  
    mm--    mm    mm    --mm    
    mm--                --mm    
      mm----------------mm      
        mmmmmmmmmmmmmmmm        \e[0m"
sudo rm -r /usr/share/TheXTech 
cd /usr/share/applications
sudo rm "Super Mario Bros X.desktop"
echo "Downloading the files and installing needed dependencies..."
sleep 3
cd 
sudo apt install -y cmake ninja-build gcc git mercurial p7zip-full
hash -r
git clone https://github.com/Wohlstand/TheXTech.git
cd TheXTech
git submodule init
git submodule update
git pull
mkdir build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug ..
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
if [ ! -d ~/.PGE_Project/thextech/worlds ]; then
mv worlds.7z -t ~/.PGE_Project/thextech/
cd ~/.PGE_Project/thextech/
7z x worlds.7z 
rm worlds.7z
cd ~/TheXTech
fi
if [ ! -d ~/.PGE_Project/thextech/battle ]; then
mv battle.7z -t ~/.PGE_Project/thextech/
cd ~/.PGE_Project/thextech/
7z x battle.7z 
rm battle.7z
fi
cd
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
