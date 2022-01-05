#!/bin/bash

clear -x

if grep -q bionic /etc/os-release; then
	sudo apt-get -y install cuda
elif ! grep -q debian /etc/os-release; then
	echo "Script will only run on debian based OS"
	exit 1
fi

echo "CUDA script started!"

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/sbsa/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_arm64.deb
sudo dpkg -i cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_arm64.deb
rm cuda-repo-ubuntu1804-11-0-local_11.0.2-450.51.05-1_arm64.deb
sudo apt-key add /var/cuda-repo-ubuntu1804-11-0-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda

echo "CUDA successfully installed"
sleep 3
