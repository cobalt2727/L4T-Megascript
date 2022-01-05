#!/bin/bash

clear -x

echo "CUDA installer script started!"

if grep -q bionic /etc/os-release; then
	sudo apt-get -y install cuda || error "Failed to install CUDA"
elif ! grep -q debian /etc/os-release; then
	echo "The CUDA installation script will only run on a Debian-based OS"
	sleep 1
	echo "Exiting..."
	sleep 5
	exit 1
fi

echo "CUDA script started!"

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/sbsa/cuda-ubuntu1804.pin || error "Failed to connect to Nvidia servers"
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_arm64.deb || error "Failed to download CUDA repository"
sudo dpkg -i cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_arm64.deb || error "Failed to install CUDA repository"
rm cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_arm64.deb
sudo apt-key add /var/cuda-repo-ubuntu1804-11-0-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda || error "Failed to install CUDA"

echo "CUDA successfully installed!"
sleep 3
