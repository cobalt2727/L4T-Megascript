clear
echo "Joycon mouse script started!"
echo -e "\e[30m                                
    -sdNMMMMMMMo  yMMMMMNdo.    
   yMmo-.....mMo  yMMMMMMMMMy   
  hMhh  ..   dMo  yMMMMMMMMMMy  
  MM: :NMMm- dMo  yMMMMMMMMMMN  
  MM: oMMMM+ dMo  hMMMMMMMMMMN  
  MM-  -++-  dMo  hMMMMMMMMMMN  
  MM-        dMo  hMMm+::sNMMN  
  MM-        dMo  hMM.    +MMN  
  MM-        dMo  hMMss  -dMMN  
  MM:        dMo  hMMMMNNMMMMN  
  MM:        dMo  yMMMMMMMMMMN  
  yMhh       dMo  yMMMMMMMMMMy  
   yMNs:.....mMo  yMMMMMMMMMs   
    .ohNNMMMMMMo  yMMMMMmho.    
                                \e[0m"
sleep 1
cd ~
sudo apt install xserver-xorg-input-joystick wget -y
sudo rm -rf /usr/share/X11/xorg.conf.d/50-joystick.conf
wget https://cdn.discordapp.com/attachments/527677698672427008/770290009638174750/50-joystick.conf && sudo mv 50-joystick.conf /usr/share/X11/xorg.conf.d

echo "Done! Restart your Switch when you're ready to gain access to using your joycons as a mouse."

sleep 2
