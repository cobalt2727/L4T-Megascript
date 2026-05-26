#!/bin/bash

echo "PortMaster script started!"
echo -e "Credits: \e[36mhttps://github.com/PortsMaster/PortMaster-GUI/\e[0m"

wget "https://github.com/PortsMaster/PortMaster-GUI/releases/latest/download/Install.Full.PortMaster.sh" -O /tmp/Install.Full.PortMaster.sh || error "PortMaster download failed..."
bash /tmp/Install.Full.PortMaster.sh || error "PortMaster install failed..."

echo "Done!"
