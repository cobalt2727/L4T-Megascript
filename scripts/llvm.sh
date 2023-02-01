#!/bin/bash

###WIP - don't run

if
	command -v apt >/dev/null
then
	sudo apt install -y curl lsb-release wget software-properties-common gnupg || error "Couldn't install dependencies!"
	LLVM_VERSION_STRING=$(curl -s https://apt.llvm.org/llvm.sh | grep "CURRENT_LLVM_STABLE=")
	STABLE_LLVM=${LLVM_VERSION_STRING#*=}
	echo "stable LLVM is $STABLE_LLVM" #this is really only needed to check what needs to be uninstalled, if anything
	LATEST_LLVM=$(($STABLE_LLVM + 1))
	echo "latest LLVM is $LATEST_LLVM"
	OLD_LLVM=$(($STABLE_LLVM - 1))
	echo "old LLVM is $OLD_LLVM"
	OLDER_LLVM=$(($STABLE_LLVM - 2))
	echo "older LLVM is $OLDER_LLVM"
	APT_LLVM=$(echo $(dpkg -s llvm | grep -i version) | sed 's/.*\://' | awk -F\. '{print $1}')
	echo "version of LLVM from apt is $APT_LLVM_VERSION"

	###EVENTS TO REMOVE OLD VERSIONS
	if [ $OLD_LLVM == $APT_LLVM ]; then
		echo 'the "old" version of LLVM is default for the system - DO NOT REMOVE'
	else
		echo "All clear to remove LLVM and Clang $OLD_LLVM"
		# NEED TO DO THIS
	fi
	if [ $OLDER_LLVM == $APT_LLVM ]; then
		echo 'the "older" version of LLVM is default for the system - DO NOT REMOVE'
	else
		echo "All clear to remove LLVM and Clang $OLDER_LLVM"
		# NEED TO DO THIS
	fi

	###EVENTS TO DETERMINE HOW TO INSTALL LLVM
	# check if /etc/apt/sources.list.d/kisak-ubuntu-kisak-mesa-*.list exists
	if compgen -G "/etc/apt/sources.list.d/kisak-ubuntu-kisak-*-*.list" >/dev/null; then
		echo "Kisak PPA found! Using that instead..."
		# if it does, do `apt show mesa-vulkan-drivers | grep libllvm` and somehow parse the number out of that
		# if it matches stable release, just install packages from there (REMOVE the llvm.org list if it exists!)
	else
		echo "We're in the clear - no Kisak PPA detected. No conflicts to worry about."
		echo "Installing from llvm.org..."
		curl https://apt.llvm.org/llvm.sh | sudo bash -s "all" || error "apt.llvm.org installer failed!"
	fi

	# check if APT_LLVM_VERSION == $STABLE_LLVM
	# if true, do nothing, just install packages (REMOVE the llvm.org list if it exists!)
elif
	command -v dnf >/dev/null
then
	################ PLACEHOLDER
	sudo dnf install -y clang llvm || error "Failed to install dependencies!"
else
	error_user "No available package manager found. Are you using a Ubuntu/Debian or Fedora based system?"
fi
