#!/bin/bash

rm -rf /tmp/fmt
mkdir /tmp/fmt
cd /tmp/fmt
lastversion extract https://github.com/fmtlib/fmt
mkdir build
cd build
# cmake ..
cmake -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE ..
sudo make install