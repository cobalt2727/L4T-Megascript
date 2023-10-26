if which godot3 > /dev/null 2>&1; then
	echo "Godot already exists!"
	sleep 2
else
	sudo apt-get install build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libglu-dev libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm clang xz-utils wget

	sudo sed -i '1s/.*/#! \/usr\/bin\/python3/' /usr/bin/scons

	mkdir /tmp/godot
	cd /tmp/godot
	wget https://github.com/godotengine/godot/releases/download/3.5.2-stable/godot-3.5.2-stable.tar.xz
	tar -xf godot-3.5.2-stable.tar.xz
	cd godot-3.5.2-stable

	echo "Building godot, this may take a few hours..."
	scons platform=x11 target=release_debug tools=yes use_llvm=yes CCFLAGS="-march=armv8-a+fp+simd" arch=arm64 -j4

	sudo cp icon.svg /usr/share/pixmaps/godot.svg
	sudo cp bin/godot.x11.opt.tools.arm64.llvm /usr/bin/godot3
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
	sudo cp /tmp/godot/godot3.desktop /usr/share/applications/godot3.desktop

	echo "Cleaning up..."
	rm -rf /tmp/godot

	echo "Godot successfully installed!"
fi
