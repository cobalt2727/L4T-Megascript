clear
echo "Citra script successfully started!"
echo -e "\e[33m                                
                    ..          
               ..---..----      
           ..- ---..----.-. o   
        ..:--- -..----.--:.-+-  
        ....--  ...------.-+++  
     .:-----   ------... -/+++  
   .:::.------ -----:: -///+++  
   .:.::-..-------:..-/////++   
   ::::..:---  :...:://///++-   
   .:..:::::.  :::::::://++-    
   -     ...:.-:::::::://+      
    -./:::::::::::::::/-        
       ...::::::::/..           
                                
                                \e[0m"
echo "Credits: i literally just took https://citra-emu.org/wiki/building-for-linux/ and made it run by itself"
sleep 3

echo "Running updates..."
sleep 1
sudo apt update -y

echo "Installing dependencies..."
sleep 1
sudo apt-get install git ninja-build libsdl2-2.0-0 libsdl2-dev qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev libqt5multimedia5-plugins libfdk-aac-dev build-essential cmake clang clang-format libc++-dev ffmpeg libswscale-dev libavdevice* libavformat-dev libavcodec-dev -y

if grep -q bionic /etc/os-release; then
	echo "-------UBUNTU 18.04 DETECTED-------"
  echo
  echo "This message will close in 30 seconds and kick you back to the main menu."
  echo "If you want more time to read this, press Ctrl + C at any point to stop the script entirely."
  echo "This script will not work, as you need a newer version of QT installed."
  echo "We'll either add a script to build THAT from source later, or you can wait for Switchroot to release an upgrade to 20.04."
  echo "If you just so happen to already have that set up on your Switch, make a PR on the GitHub to get your build method incorporated into this script!"
  echo "Note that trying to upgrade L4T Ubuntu from within your existing installation is not supported and will break your Linux install!"
  echo "When 20.04 launches you'll have to reinstall completely to upgrade."
  sleep 30
  exit
fi

echo "Building Citra..."
sleep 1
cd ~
git clone --recursive https://github.com/citra-emu/citra
cd citra
mkdir build
cd build
cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DENABLE_FFMPEG_AUDIO_DECODER=ON -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native
make -j$(nproc)
sudo make install

echo "Removing build files..."
sleep 1
cd ~
sudo rm -rf citra

echo "Done!"
echo "Sending you back to the main menu..."
sleep 5
