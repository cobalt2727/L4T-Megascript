echo "Started Prusaslicer Build Script"
echo ""
echo "Installing dependencies"
sudo apt install git cmake build-essential curl libwxgtk3.0-dev libboost-dev openssl libtbb-dev libgtest-dev libcereal-dev libnlopt-dev libqhull-dev libblosc-dev libopenexr-dev libopenvdb-dev -y
echo "Getting the source code"
cd ~
git clone https://github.com/prusa3d/PrusaSlicer.git
cd PrusaSlicer
git pull
cd cmake/modules
echo "Patching the source code until fixed in master"
rm -rf FindTBB.cmake
wget https://raw.githubusercontent.com/ceres-solver/ceres-solver/master/cmake/FindTBB.cmake
cd ~/PrusaSlicer
mkdir -p build && cd build
echo "Running cmake"
cmake .. -DSLIC3R_WX_STABLE=1 -DSLIC3R_GTK=3
echo "Startig compilation with two threads only (due to ram limitations)"
make -j2
echo "Now installing"
sudo make install
echo "Sending you back to the megascript"
