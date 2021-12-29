echo "TurboWarp script started!"

#https://desktop.turbowarp.org
sudo bash -c "$(wget -qO- https://desktop.turbowarp.org/install.sh)" || error "Failed to run the official install script"


echo "Done!"
