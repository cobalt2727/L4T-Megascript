echo "Started Prusaslicer Build Script"
echo ""
echo "Adding Ubuntu Toolchain Test PPA to install GCC 11..."
ppa_name="ubuntu-toolchain-r/test" && ppa_installer 

# get the $DISTRIB_RELEASE and $DISTRIB_CODENAME first from lsb-release (for ubuntu) and then from the upstream for derivatives
source /etc/lsb-release
source /etc/upstream-release/lsb-release
case "$DISTRIB_CODENAME" in
    bionic)
        echo "Adding Boost 1.67 PPA..."
        ppa_name="theofficialgman/boost1.67-bionic" && ppa_installer
        sudo apt install libcgal-dev -y || error "Dependencies failed to install"
        sudo tee /usr/lib/aarch64-linux-gnu/cmake/CGAL/CGALConfigVersion.cmake <<'EOF' >>/dev/null
set(CGAL_MAJOR_VERSION 5)
set(CGAL_MINOR_VERSION 0)
set(CGAL_BUGFIX_VERSION 0)
set(CGAL_VERSION_PUBLIC_RELEASE_VERSION "5.0.0")
set(CGAL_VERSION_PUBLIC_RELEASE_NAME "CGAL-${CGAL_VERSION_PUBLIC_RELEASE_VERSION}")

if (CGAL_BUGFIX_VERSION AND CGAL_BUGFIX_VERSION GREATER 0)
  set(CGAL_CREATED_VERSION_NUM "${CGAL_MAJOR_VERSION}.${CGAL_MINOR_VERSION}.${CGAL_BUGFIX_VERSION}")
else()
  set(CGAL_CREATED_VERSION_NUM "${CGAL_MAJOR_VERSION}.${CGAL_MINOR_VERSION}")
endif()

set(PACKAGE_VERSION ${CGAL_CREATED_VERSION_NUM})

if(PACKAGE_VERSION VERSION_LESS PACKAGE_FIND_VERSION)
  set(PACKAGE_VERSION_COMPATIBLE FALSE)
else()
  if(PACKAGE_FIND_VERSION_MAJOR STREQUAL CGAL_MAJOR_VERSION)
    set(PACKAGE_VERSION_COMPATIBLE TRUE)
  else()
    set(PACKAGE_VERSION_COMPATIBLE FALSE)
  endif()
  if(PACKAGE_FIND_VERSION STREQUAL PACKAGE_VERSION)
    set(PACKAGE_VERSION_EXACT TRUE)
  endif()
endif()
EOF
        ;;
esac

status "Installing dependencies"  
sudo apt install gcc-11 g++-11 git cmake build-essential curl libcgal-dev libboost-all-dev openssl libtbb-dev libgtest-dev libcereal-dev libnlopt-dev libqhull-dev libblosc-dev libopenexr-dev libopenvdb-dev libwxgtk3.0-gtk3-dev -y || error "Dependencies failed to install"
hash -r
status "Getting the source code"
cd ~
git clone https://github.com/prusa3d/PrusaSlicer.git
cd PrusaSlicer
# hard reset to remove any modifications made
git reset --hard
git pull
cd cmake/modules
echo "Patching the source code until fixed in master"
rm -rf FindTBB.cmake
wget https://raw.githubusercontent.com/ceres-solver/ceres-solver/master/cmake/FindTBB.cmake
cd ~/PrusaSlicer
mkdir -p build && cd build
echo "Running cmake"
rm -rf CMakeCache.txt
cmake .. -DSLIC3R_WX_STABLE=1 -DSLIC3R_GTK=3 -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11 || error "Cmake makefile generation failed"
memtotal=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
if [[ $memtotal < 7500000 ]]; then
    echo "Startig compilation with two threads only (due to ram limitations)"
    make -j2 || error "Make build failed"
else
    make -j$(nproc) || error "Make build failed"
fi
status "Now installing"
sudo make install || error "Make install failed"
status_green "Prusaslicer Installed Successfully"
echo "adding a .desktop file"
sudo sh -c "cat > /usr/local/share/applications/prusaslicer.desktop << _EOF_
[Desktop Entry]
Type=Application
Exec=prusa-slicer
Hidden=false
NoDisplay=false
Name=PrusaSlicer
Icon=/usr/local/resources/icons/PrusaSlicer.png
Categories=GTK;Graphics
_EOF_"
echo "Sending you back to the megascript"
