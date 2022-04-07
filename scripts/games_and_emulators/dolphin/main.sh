#!/bin/bash

clear -x
echo "Dolphin script successfully started!"
sleep 1

get_system

echo "Installing support for Wii U/Switch Nintendo Gamecube controller adapters..."
# previous line this massive case statement replaced: sudo apt install udev libudev1 libudev-dev -y || error "Failed to install dependencies!"
case "$__os_id" in
    Raspbian|Debian|LinuxMint|Linuxmint|Ubuntu|[Nn]eon|Pop|Zorin|[eE]lementary|[jJ]ing[Oo][sS])
        package_available libudev-dev #this will install on mainstream distros
        if [[ $? == "0" ]]; then
            sudo apt install -y libudev-dev udev || error "Failed to install udev development libraries!"
        fi
        package_available libeudev-dev #this is a udev replacement that works without systemd, you can't even install it on a regular Debian/Ubuntu spin
        if [[ $? == "0" ]]; then
            sudo apt install -y libeudev-dev eudev || error "Failed to install eudev development libraries!"
        fi
    ;;
    Fedora)
        sudo dnf install -y systemd-devel || error "Failed to install dependencies!"
    ;;
    *)
        echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install udev development libraries yourself...\\e[39m"
        sleep 5
    ;;
esac


sudo rm -f /etc/udev/rules.d/51-gcadapter.rules
sudo touch /etc/udev/rules.d/51-gcadapter.rules
echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules > /dev/null
sudo udevadm control --reload-rules
sudo systemctl restart udev.service
cd ~

echo "What would you like to do?"
echo -e "\e[36mNote that a FIRST-TIME install can take up to 40-60 minutes on a Switch.\e[0m"
echo -e "\e[1;31mConnect your Switch to a charger!\e[0m"
echo -e "\e[1;33mPlease close down ALL OTHER PROGRAMS while installing Dolphin to prevent crashes.\e[0m"
echo
echo
sleep 2
# ##echo "3...............Build other variants of Dolphin from source (Primehack, Project+, etc)"
# #echo "5...............Install Project+ (builds correctly, performance untested, PROBABLY SLOW)"

table=('Install Dolphin (use the updater on the main menu to update!)' "Run the RiiConnect24 Patcher")
description="What would you like to do?\
\nNote that a FIRST-TIME install of Dolphin can take up to 40-60 minutes on a Switch.\
\n\nConnecting your Switch to a charger is recommended.\
\n\nYour Choices of Install are:"
userinput_func "$description" "${table[@]}"


if [[ $output == 'Install Dolphin (use the updater on the main menu to update!)' ]]; then
    echo "Building from source with device-specific optimizations..."
    cd ~
    bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/install.sh)"|| exit $?
    bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/config.sh)" || exit $?
    
    elif [[ $output == "Run the RiiConnect24 Patcher" ]]; then
    case "$__os_id" in
        Raspbian|Debian|LinuxMint|Linuxmint|Ubuntu|[Nn]eon|Pop|Zorin|[eE]lementary|[jJ]ing[Oo][sS])
            sudo apt install -y xdelta3 || error "Failed to install dependencies!"
        ;;
        Fedora)
            sudo dnf install -y xdelta || error "Failed to install dependencies!"
        ;;
        *)
            echo -e "\\e[91mUnknown distro detected - this script should work, but please press Ctrl+C now and install the xdelta package yourself...\\e[39m"
            sleep 5
        ;;
    esac
    bash -c "$(curl -s https://raw.githubusercontent.com/RiiConnect24/RiiConnect24-Patcher/master/RiiConnect24Patcher.sh)"
    
    
    elif [[ $userInput == 3 ]]; then
    echo "not ready yet"
    sleep 3
    ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/primehack.sh)"
    
    elif [[ $userInput == 4 ]]; then
    echo "not ready yet"
    sleep 3
    ##bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/slippi.sh)"
    
    elif [[ $userInput == 5 ]]; then
    echo "Loading Project+ script..."
    sleep 3
    bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/projectplus.sh)" || exit $?
    
    elif [[ $userInput == 6 ]]; then
    echo "not ready yet"
    sleep 3
    bash -c "$(curl -s https://raw.githubusercontent.com/$repository_username/L4T-Megascript/$repository_branch/scripts/games_and_emulators/dolphin/kirbyairridehackpack.sh)" || exit $?
    
    
fi

echo "Sending you back to the main menu..."
sleep 3
