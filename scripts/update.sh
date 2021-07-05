#!/bin/bash


clear -x
echo "Updater script successfully started!"

description="Do you want to remove unused programs (if any) and attempt to fix broken programs?\
\n(Keyboard required to confirm when it checks later, but any menus like this have mouse/touch support. If you don't have a keyboard set up, just choose no.)"
table=("yes" "no")
userinput_func "$description" "${table[@]}"
AptFixUserInput="$output"



############UPDATER SCANNERS - SEE BELOW FOR MANUAL UPDATERS###########
##add more of these later!

#tests if the Dolphin Emulator program exists, then asks to re-run the installer script if it's found, binding the user's response to DolphinUserInput
#reset the variable first to be safe...
DolphinUserInput="no"
if test -f /usr/local/bin/dolphin-emu; then
        description="Do you want to update Dolphin? (May take 5 to 40 minutes)"
        table=("yes" "no")
        userinput_func "$description" "${table[@]}"
	DolphinUserInput="$output"
fi

#Same as above, but for RetroPie, using the emulationstation binary as the test
RetroPieUserInput="No"
if test -f /usr/bin/emulationstation; then
        description="Do you want to update parts of RetroPie?\
		\nThe Helper Scripts should always but updated and only take a few seconds\
		\nUpdating the cores (Everything), could TAKE MULTIPLE HOURS"
        table=("Helper Scripts Only" "Yes (Everything)" "No")
        userinput_func "$description" "${table[@]}"
        RetroPieUserInput="$output"
fi

#######################################################################

echo "Running APT updates..."
sleep 1
sudo apt upgrade -y
#this is an apt package in the Switchroot repo, for documentation join their Discord https://discord.gg/9d66FYg and check https://discord.com/channels/521977609182117891/567232809475768320/858399411955433493
sudo apt install switch-multimedia -y

##this is outside all the other y/n prompt runs at the bottom since you obviously need functioning repositories to do anything else
if [[ $AptFixUserInput == "yes" ]]; then
	echo
	echo
	echo
	echo "Scanning for issues with APT packages..."
	echo
	echo "If you receive a yes/no prompt in the following steps,"
	echo "Make sure you carefully read over the"
	echo "packages to be changed before proceeding."
	echo "If not, don't worry about it."
	echo "Purging, cleaning, and autoremoving are NORMALLY"
	echo "fine, but double-check packages to be safe."
	sleep 5
	##maintenance (not passing with -y to prevent potentially breaking something for a user)
	sudo dpkg --configure -a
	sudo apt autoremove
	sudo apt --fix-broken install
	sudo apt autoclean
	sudo apt autopurge
	
	echo "Fixing flatpak issues (if any)..."
	sudo flatpak repair
	flatpak repair --user

else
	echo "Skipping apt fixes..."
fi


echo "Updating Flatpak packages (if you have any)..."
##two separate flatpak updaters to catch all programs regardless of whether the user installed them for the system or just the user
sudo flatpak update -y
flatpak update -y

#echo "Updating NPM (if you have it)..."
##commenting this out until i figure out a better way to replace it with an updater for all NodeJS packages
#sudo npm install -g npm

echo "Marking all AppImages under ~/Applications as executable..."
chmod +x ~/Applications/*.AppImage

#################MANUAL UPDATERS - SEE ABOVE FOR SCANNERS#################

if [[ $DolphinUserInput == "yes" ]]; then
	echo "Updating Dolphin..."
	echo -e "\e[33mTO FIX, RESET, AND/OR UPDATE CONFIGS (not game saves) YOU HAVE\e[0m"
	echo -e "\e[33mTO RE-RUN THE DOLPHIN SCRIPT FROM THE MENU\e[0m"
	sleep 5
	bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/install.sh)"
else
	echo "Skipping Dolphin updates..."
fi

if [[ $RetroPieUserInput == "Yes (Everything)" ]]; then
	echo "Updating RetroPie..."
	echo -e "\e[33mThis can take a VERY long time - possibly multiple hours.\e[0m"
	echo -e "\e[33mCharge your device & remember you can close this terminal or press\e[0m"
	echo -e "\e[33mCtrl+C at any time to stop the process.\e[0m"
	sleep 10
	curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/retropie_auto.sh | sudo -E bash -s "update_cores"
elif [[ $RetroPieUserInput == "Helper Scripts Only" ]]; then
	echo "Updating RetroPie Helper Scripts Only..."
	curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/retropie_auto.sh | sudo -E bash -s "update_scripts"
else
	echo "Skipping RetroPie updates..."
fi



##########################################################################

cd ~
if test -f customupdate.sh; then
	echo "Looks like you've made a custom update file - running that..."
	chmod +x customupdate.sh
	./customupdate.sh
else
	echo -e "You can add your own commands to automatically run with this updater"
	echo -e "by creating a file in \e[34m/home/$USER/\e[0m (this is your default ~ folder) named \e[36mcustomupdate.sh\e[0m"
	sleep 4
fi

sleep 1

echo
echo "Done! Sending you back to the main menu..."
sleep 4
