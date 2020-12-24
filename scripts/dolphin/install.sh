clear
echo "Dolphin script started!"
echo -e "\e[36m                                
                                
                                
       -////////  ./:--::       
   //s//////////+s/////         
 /o///:--      .---///o/        
 ++++/:----:////     --+s/      
s+++-----++++:++ss/-    -+s     
-         -++s/  ---s//   -+/   
             ---      -:    -/  
                             -/ 
                              -:
                                
                                
                                
                                \e[0m"
sleep 1
cd ~
echo "Installing dependencies..."
sleep 1
sudo apt update
sudo apt install git cmake ffmpeg libavcodec-dev libevdev-dev libusb-1.0-0-dev libavformat-dev libswscale-dev libsfml-dev libminiupnpc-dev libmbedtls-dev curl libhidapi-dev libpangocairo-1.0-0 libgtk2.0-dev libbluetooth-dev qt5-default qtbase5-private-dev libudev-dev portaudio19-dev libavutil-dev libxrandr-dev libxi-dev  -y
echo "Downloading the source..."
git clone https://github.com/dolphin-emu/dolphin
cd dolphin
git pull
mkdir build
cd build
echo "Building..."
#if you're looking at this script as a reference for building Dolphin on your own hardware,
#you can do "cmake .." and nothing else on the next line for a slight performance hit with a much faster build time

if grep -q bionic /etc/os-release; then
  
  echo "Ubuntu 18.04 detected, skipping LTO optimization..."
  echo "If that means nothing to you, don't worry about it."
  
  cmake .. -D -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native -DCMAKE_C_FLAGS_INIT="-static"

else  
  
  cmake .. -D ENABLE_LTO=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_C_FLAGS=-march=native -DCMAKE_C_FLAGS_INIT="-static"

fi




make -j$(nproc)
echo "Installing..."
sudo make install
cd ~
#commenting out the below line since the first build takes way too long to do on weak hardware like the Switch
#leaving the source folder there will make future builds faster
##sudo rm -rf dolphin
echo "Done!"
echo "Sending you back to the main menu..."
sleep 2
