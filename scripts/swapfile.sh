clear
echo "Swapfile script started!"
sleep 1
cd ~
sudo apt-get install nano util-linux*
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
grep -qxF '/swapfile swap swap defaults 0 0' /etc/fstab || echo '/swapfile swap swap defaults 0 0' | sudo tee --append /etc/fstab

echo "Done!"
sudo free -h
echo ""
echo "Moving on..."

sleep 5
