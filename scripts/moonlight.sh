clear
echo "Moonlight script started!"
sleep 1
echo "deb https://dl.bintray.com/moonlight-stream/moonlight-l4t bionic main" | sudo tee /etc/apt/sources.list.d/moonlight-l4t.list
echo "Adding key..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
echo "Updating sources and installing Moonlight"
sudo apt-get update
sudo apt install moonlight-qt -y
echo "Done!"
echo "Ctrl + click this link before this message disappears in 20 seconds"
echo "For a guide on how to set Moonlight up on your PC and connect"
echo "to it from your Switch!"
echo
echo "https://github.com/moonlight-stream/moonlight-docs/wiki/Setup-Guide"
echo
echo "Remember that you must have a computer"
echo "on the same network with a capable Nvidia GPU to run this."
echo "The program on your Switch can be run from"
echo "your apps list or by typing 'moonlight-qt' into a terminal."
sleep 20
echo "Going back to the menu..."
sleep 2
