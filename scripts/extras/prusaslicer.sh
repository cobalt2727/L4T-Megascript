#my thanks goes out to kaweksl on github who's script I mostly used

sudo apt install git cmake build-essential
# Gonna download to home folder
cd ~
git clone --recursive --branch version_2.2.0 https://github.com/prusa3d/PrusaSlicer.git
cd PrusaSlicer
# Selecting version (lateset at a time)
cd deps
mkdir -p build && cd build
cmake ..
# This gonna download and build static libraries
# you can't move or delete those after compiling, path gonna be hardcoded
# This gonna take a while
make
cd destdir/usr/local
# cd back to PrusaSlicer main folder
cd ~/PrusaSlicer
mkdir -p build && cd build

# change DCMAKE_PREFIX_PATH to path saved above
cmake .. -DSLIC3R_STATIC=1 -DCMAKE_PREFIX_PATH=~/PrusaSlicer/deps/build/destdir/usr/local
# This gonna take a while
make


#Test PrusaSlicer
#~/PrusaSlicer/build/src/prusa-slicer -help
