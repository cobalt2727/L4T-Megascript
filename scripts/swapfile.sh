clear
echo "Swapfile script started!"
sleep 1
cd ~
apt-get install nano util-linux* -y
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
grep -qxF '/swapfile swap swap defaults 0 0' /etc/fstab || echo '/swapfile swap swap defaults 0 0' | tee --append /etc/fstab

echo "Done!"
free -h
echo ""
echo "Moving on..."

sleep 5
