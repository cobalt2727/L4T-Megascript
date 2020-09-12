echo "Making sure software-properties-common is installed..."
apt install software-properties-common
#echo "looking to see if Dolphin's PPA already exists..."

#if ! grep -q "^deb .*dolphin-emu/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    #echo "Dolphin PPA not found, installing now!"
echo "Making sure the Dolphin PPA is installed..."
    apt-add-repository ppa:dolphin-emu/ppa
#else
    #echo "You've already installed the PPA, moving on to checking for updates..."

#fi
apt update
apt install dolphin-emu-master
echo
echo
echo "NOTE: If you already have dolphin installed, you don't need to"
echo "check this script to update - just press 1 on the main menu and"
echo "Dolphin will get updated alongside everything else!"
sleep 10


echo "Sending you back to the main menu..."
sleep 1
