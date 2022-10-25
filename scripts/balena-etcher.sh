#https://github.com/Itai-Nelken/Etcher-arm-32-64
#https://github.com/ryanfortner/balenaetcher-debs

echo "Balena Etcher script started!"

sudo wget http://ryanfortner.github.io/balenaetcher-debs/etcher.list -O /etc/apt/sources.list.d/etcher.list || error "Downloading etcher.list failed"
wget -qO- http://ryanfortner.github.io/balenaetcher-debs/KEY.gpg | sudo apt-key add -
sudo apt update && sudo apt install balena-etcher-electron -y || error "Apt Update/Install Failed"


echo "Done! Sending you back to the main menu..."
