clear
echo "SuperTux2 script started!"
echo -e "\e[1;34m         ////.......-..o..      
       -- --/s+yo+ooyyo/:.:     
     :::.::s/+ossssssosyys+     
     ::o:/:+oshh++/+dhhm+       
     h++.+ooosh                 
     +/-/ooooooosyhs:: :        
     ssoosssssssooooh/..++      
       +/sso+++syysooh:::::     
                  s+/+y/---/    
                  /-.:ohos-/    
        --       /////oooosm    
   ..:::....::ooyooo/oooooyd    
  //soyoyhyyo+os/-:/oooooohm    
  //::/+ooooo+o++ooooooosyd     
   +s++oooooooooooosssyhs+      
      /+///++syyo+//o+:         \e[0m"
echo "Downloading the files and installing needed dependencies..."
sleep 3
cd ~
cd ~/RetroPie/roms/ports
rm -r supertux2.sh
cd ~/.local/share/supertux2
mv profile1 -t ~/
cd 
git clone --recursive https://github.com/SuperTux/supertux
sudo apt install build-essential libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev curl libcurl4 libcurl4-openssl-dev libvorbis-dev libogg-dev cmake extra-cmake-modules libopenal-dev libglew-dev libboost-dev libboost-all-dev subversion -y
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/ST2
cd ST2
mv supertux2.sh -t ~/RetroPie/roms/ports
cd
cd ~/supertux/data/images/engine/menu
rm logo_dev.png
mv logo.png logo_dev.png
cd ~/supertux
mkdir build && cd build
echo
echo "Compiling the game..."
sleep 1
echo
cmake .. -DCMAKE_BUILD_TYPE=RELEASE
make -j$(nproc)
echo
echo "Game compiled!"
sleep 1
echo "Installing game...."
sudo make install
echo "Erasing temporary build files to save space..."
sleep 2
echo
cd ~/.local/share && mkdir supertux2
cd ~/ST2
mv config -t ~/.local/share/supertux2
cd ~
sudo rm -r supertux
rm -r ST2
mv profile1 -t ~/.local/share/supertux2
echo
echo "Game installed!"
echo
echo
echo "[NOTE] Remember NOT to move the SuperTux2 folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo
echo "Sending you back to the main menu..."
sleep 1


