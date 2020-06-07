echo '---Making sure dependencies are installed...---'
sudo apt update
sudo apt install git -y
cd ~

#set up IF statement to download the repo if not existent
echo '---Downloading the L4T-Megascript repository...---'
git clone https://github.com/cobalt2727/L4T-Megascript
cat ~/L4T-Megascript/README.md


#else git pull
echo '---Checking for updates to the script files...---'
cd ~/L4T-Megascript
git pull
cd ~
