#!/bin/bash

echo "Supermodel 3 (Sega Model 3 emulator) script started!"
#credits: https://www.supermodel3.com/BuildInstructionsWindows.html and a few creative liberties

#TODO: look at the following for RetroPie integration
###https://mechafatnick.co.uk/2021/06/13/becoming-a-super-model-adding-model-3-games-to-your-pi4/
###https://gbatemp.net/threads/supermodel-nx-segas-ardade-model-3-emulator-on-nintendo-switch-l4t-ubuntu.582130/
###get rid of that last echo after the above is completed

echo "Installing dependencies..."
sudo apt install -y build-essential libsdl2-2.0-0 libsdl2-dev libsdl2-net-dev subversion

svn checkout https://svn.code.sf.net/p/model3emu/code/trunk Supermodel3

cd Supermodel3
svn update

#wipe old build clutter
make -f Makefiles/Makefile.UNIX clean

#actually build
make -f Makefiles/Makefile.UNIX

echo "The emulator can be found at ~/Supermodel3/bin/supermodel - enjoy!"
