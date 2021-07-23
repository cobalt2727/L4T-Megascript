#!/bin/bash

if grep -E 'bionic|focal|groovy' /etc/os-release > /dev/null; then
    ppa_added=$(grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep openjdk-r | wc -l)
    if [[ $ppa_added -eq "1" ]]; then
        echo "Skipping OpenJDK PPA, already added"
    else
        echo "Adding OpenJDK PPA, needed for Minecraft 1.17+"
        ppa_name="openjdk-r/ppa" && ppa_installer
    fi
fi
sudo apt install cmake curl zlib1g-dev openjdk-8-jdk openjdk-11-jdk openjdk-16-jdk qtbase5-dev -y
# make all the folders
cd
mkdir -p ~/MultiMC
cd ~/MultiMC
mkdir -p build
mkdir -p install
# clone the complete source
git clone --recursive https://github.com/MultiMC/MultiMC5.git src # You can clone from MultiMC's main repo, no need to use a fork.
cd src
git pull --recurse-submodules
cd ..
# configure the project
cd build
# obtain the cpu info
get_system
# temporary hotfix to build with java 11 (build currently fails on java 16 autodetection)
# https://github.com/MultiMC/MultiMC5/issues/3949
# remove cmake cache until bug is fixed
rm -rf CMakeCache.txt
case "$architecture" in
    "aarch64") cmake -DJAVA_HOME='/usr/lib/jvm/java-11-openjdk-arm64'  -DCMAKE_INSTALL_PREFIX=../install -DMultiMC_META_URL:STRING="https://raw.githubusercontent.com/theofficialgman/meta-multimc/master/index.json" ../src ;;
    "x86_64"|"i386") cmake -DCMAKE_INSTALL_PREFIX=../install ../src ;;
    *) echo "Error: your cpu architecture ($architecture) is not supporeted by MultiMC and will fail to compile"; rm -rf ~/MultiMC; echo ""; echo "Exiting the script"; sleep 3; exit $? ;;
esac

# build & install (use -j with the number of cores your CPU has)
make -j$(nproc) install
cd
sudo sh -c "cat > /usr/local/share/applications/MultiMC.desktop << _EOF_
[Desktop Entry]
Type=Application
Exec=/home/$USER/MultiMC/install/MultiMC
Hidden=false
NoDisplay=false
Name=MutiMC
Icon=/home/$USER/MultiMC/src/application/resources/multimc/scalable/multimc.svg
Categories=Game
_EOF_"