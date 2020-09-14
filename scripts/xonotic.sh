clear
echo "Xonotic build script started!"
echo "Steps used: https://gitlab.com/xonotic/xonotic/-/wikis/Repository_Access"
sleep 1
echo "ETA: Asset download speed depends on your network, but 10 minutes to build on a Raspberry Pi 4b."
sleep 1
echo "I'm sure it'll be faster on the Switch... -Cobalt"
cd ~
sleep 3
echo "Installing dependencies..."
sudo apt install autoconf build-essential curl git libtool libgmp-dev libjpeg-turbo8-dev libsdl2-dev libxpm-dev xserver-xorg-dev zlib1g-dev unzip libasound2-dev libxext-dev libxxf86vm-dev p7zip-full unzip wget x11proto-xf86vidmode-dev -y

##if the xonotic folder is not found...
git clone git://git.xonotic.org/xonotic/xonotic.git  # download main repo
cd xonotic
./all update -l best
./all clean
./all compile -r

##if the xonotic folder is found...
#cd xonotic
#./all checkout  # switch to main branch on all repos (usually master)
#./all update  # pull and prune
#./all compile -r  # recompile what changed



echo "We'll have a desktop file ready later, but for now, you can run Xonotic with"
echo
echo "./all run +vid_fullscreen 0"
echo
echo 'In the terminal! Type just "./all run" without parentheses if the fullscreen mode breaks and let me know to fix the script...'
sleep 10
echo "Going back to the menu..."
sleep 1
