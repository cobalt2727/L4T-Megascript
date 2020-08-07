echo "Making sure software-properties-common is installed..."
sudo apt install software-properties-common
#echo "looking to see if FlightGear's PPA already exists..."

#if ! grep -q "^deb .*saiarcot895/flightgear" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    #echo "FlightGear PPA not found, installing now!"
echo "Making sure the FlightGear PPA is installed..."
    sudo add-apt-repository ppa:saiarcot895/flightgear

#else
    #echo "You've already installed the PPA, moving on to checking for updates..."

#fi
sudo apt-get update
sudo apt install flightgear
echo
echo
echo "NOTE: If you already have FlightGear installed, you don't need to"
echo "check this script to update - just use the standard updater script and"
echo "FlightGear will get updated alongside everything else!"
sleep 10


echo "Sending you back to the main menu..."
sleep 1
