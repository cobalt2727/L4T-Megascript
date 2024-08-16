#!/bin/bash
#TODO: Fedora support

if which godot3 > /dev/null 2>&1; then
	echo "Godot already exists!"
	sleep 2
else
	sudo apt install -y build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libglu-dev libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm clang xz-utils wget python3-pip
	pipx_install lastversion
 
	sudo sed -i '1s/.*/#! \/usr\/bin\/python3/' /usr/bin/scons

	mkdir /tmp/godot
	cd /tmp/godot
	lastversion extract godot -b 3

	echo "Building Godot, this may take a few hours..."
 	#TODO: do we really need to manually specify the arch?
	scons platform=x11 target=release_debug tools=yes use_llvm=yes CCFLAGS="-march=native" arch=arm64 -j$(nproc)

	sudo mkdir /usr/local/share/pixmaps
	sudo cp icon.svg /usr/local/share/pixmaps/godot.svg
	sudo cp bin/godot.x11.opt.tools.arm64.llvm /usr/local/bin/godot3
	touch /tmp/godot/godot3.desktop
	echo "[Desktop Entry]
Name=Godot Engine
GenericName=Libre game engine
Comment=Multi-platform 2D and 3D game engine with a feature-rich editor
Exec=godot3 -p
Icon=godot
Terminal=false
Type=Application
MimeType=application/x-godot-project;
Categories=Development;IDE;" > /tmp/godot/godot3.desktop
	sudo mkdir /usr/local/share/applications
	sudo cp /tmp/godot/godot3.desktop /usr/local/share/applications/godot3.desktop

	echo "Cleaning up..."
	rm -rf /tmp/godot

	echo "Godot successfully installed!"
fi
