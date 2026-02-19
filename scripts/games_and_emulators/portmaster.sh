#!/bin/bash

echo "PortMaster script started!"
echo -e "Credits: \e[36mhttps://github.com/PortsMaster/PortMaster-GUI/\e[0m"

wget "https://github.com/PortsMaster/PortMaster-GUI/releases/latest/download/Install.PortMaster.sh"
sudo bash Install.PortMaster.sh || error "PortMaster install failed..."
sleep 1

echo "Done!"
