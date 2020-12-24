clear
echo "Minecraft Java script started!"
echo -e "\e[32m++++++oooooooooo++++oooooooossoo
++oo++++++hhoooooo////++oooooooo
//hh//oooohh++hh++++////hhssoohh
hhsshhhh++hhhhhhoohhoohhyyhhhhyy
ssyyss++hhssyyyyhhhhhhssyysshhyy
yyhhssssyysshhhhhhyyyyhhyyyyyy++
++yyyyyyooyyyy++++yy++++yyssyyss
yyyy++++ssssyyyysshhssssyyyyssss
ssyyyyssyyssyyhhyyssssyyyyyyhhyy
yysshhyyyyhhhhyyyyyyyyyy++++yyss
yyssyy++++yy++sshh++++hhssssooyy
ssyyyyssss++yyssssssssyyhhssyyhh
yyhhssyyssss++yyyyyyyyyyyyyy++++
yyssyyyyyyyyssssyyhh++hhyy++ssss
ssyyhh++yyhhyyhh++++yyssyyyyssss
ssyy++ssssyyooyyssssyyyyssssyyhh\e[0m"
sleep 1
cd ~
mkdir minecraft-temp && cd minecraft-temp
echo "Downloading dependencies..."
##these should do the trick - jarwrapper is included to make it so that .jar files (like OptiFine) can be run with ./[filepath]/[filename] like .deb files
sudo apt install default-jre default-jdk jarwrapper -y

echo "Downloading Luke Chambers's MCSwitchTools GitLab repo..."
##i wish gitlab supported svn.
##but noooooo.
git clone https://gitlab.com/devluke/mcswitchtools
cd mcswitchtools/
echo "Moving the Minecraft files to the $HOME/ folder..."
sudo mv MCSwitchTools/ ~
cd ~
sudo rm -rf minecraft-temp/
echo "Starting up initialization..."
sudo apt update
sudo apt install openjdk-11-jdk openjdk-8-jdk -y
~/MCSwitchTools/tools.sh init
##shoutouts to Luke for telling me how to restart a terminal entirely automated
source ~/.bashrc
mc lwjgl 3
echo "You will now need to log into your Minecraft/Mojang account, and then immediately close the launcher."
echo "Please do so when the program launches in 10 seconds."
sleep 10
##sudo jetson_clocks
mc run
sleep 3


##ask user if they want optifine, sodium, or both

##if they answer optifine
#############################
echo "Downloading and installing OptiFine..."
echo "If the script automatically installs a version that's not up to date,"
echo "let us know on GitHub or Discord - we haven't figured out how to automate updating yet..."
cd ~
wget https://optifine.net/downloadx?f=OptiFine_1.16.3_HD_U_G3.jar&x=ba40d84b0b4333b35fde7329aa59ba31
sudo chmod +x OptiFine_1.16.3_HD_U_G3.jar
echo "You will now need to click Install and then exit the program when prompted."
echo "Please do so when the installer launches in 10 seconds."
./OptiFine_1.16.3_HD_U_G3.jar
sudo rm OptiFine_1.16.3_HD_U_G3.jar

sleep 1
echo "Fixing profiles for use with the Switch..."
mc profiles
#############################

##if they answer sodium
#############################
##sodium install script
#############################

##if they answer neither
#############################
##echo "Skipping Minecraft game optimizations."

##echo "Please do not message us asking why the game is lagging until you rerun the script and choose one or both optimization programs."
##echo "Enjoy your low framerates..."
#############################

##note: i have a .desktop file already made, but it's back home on an SD card and i'm currently at college.
##oops. -cobalt
echo "Done!"
echo "[NOTE] Remember NOT to move the MCSwitchTools folder or any file inside it or the game will stop working."
echo "If the game icon doesn't appear inmediately, restart the system."
echo "This message will close in 10 seconds."
sleep 10
echo "Going back to the menu..."
sleep 2
