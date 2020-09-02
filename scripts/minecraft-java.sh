clear
echo "Minecraft Java script started!"
sleep 1
cd ~
mkdir minecraft-temp && cd minecraft-temp
echo "Downloading Luke Chambers's MCSwitchTools GitLab repo..."
##i wish gitlab supported svn
git clone https://gitlab.com/devluke/mcswitchtools
cd mcswitchtools/
echo "Moving the Minecraft files to the /home/$USER/ folder..."
sudo mv MCSwitchTools/ ~
cd ~
sudo rm -rf minecraft-temp/
echo "Starting up initialization..."
sudo apt update
~/MCSwitchTools/tools.sh init
##how in God's name do I automate restarting a terminal
mc lwjgl 3
echo "You will now need to log into your Minecraft/Mojang account, and then immediately close the launcher."
echo "Please do so when the program launches in 10 seconds."
sleep 10
##sudo jetson_clocks
mc run
sleep 3
mc profiles


##note: i have a .desktop file already made, but it's back home on an SD card and i'm currently at college.
##oops. -cobalt
echo "Done!"
echo "[NOTE] Remember NOT to move the MCSwitchTools folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo "Going back to the menu..."
sleep 2
