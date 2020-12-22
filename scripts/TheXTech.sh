cd
clear
echo "TheXTech script started!"
echo "MMMMMMMMMMmmmmmmmmmmmmMMMMMMMMMM
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
MMMMMMMMmmmmmmmmmmmmmmmmMMMMMMMM"
echo "Downloading the files and installing needed dependencies..."
sleep
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
echo "This will take a while, please wait, if it seems like it is stuck it is not so please have patience."
ninja
cd
mkdir -p ~/.PGE_Project/thextech/
cd ~/.PGE_Project/thextech
wget https://wohlsoft.ru/TheXTech/_downloads/thextech-smbx13-assets.7z
7z x thextech-smbx13-assets.7z
rm thextech-smbx13-assets.7z
echo
echo "Game Installed!"
echo
sleep 10
echo
echo "Sending you back to the main menu..."
sleep 1
