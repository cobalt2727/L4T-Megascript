# L4T-Megascript
![Logo](https://raw.githubusercontent.com/Lang-Kasempo/L4T-Megascript/master/L4T%20Megascript-logo.png)
**We did the hard parts so you don't have to!**

A multipurpose script for updating and installing multiple programs and games like Dolphin, Moonlight, Minecraft, RetroArch (using RetroPie), SRB2, and more for Ubuntu Linux on the Nintendo Switch!

## What is this?

L4T-Megascript is an open source multipurpose script for installing and updating multiple softwares in L4T-Ubuntu, with the purpose of helping new users to install programs and games in only a few steps. We work so you can easily play. Pretty simple, right? This script was made for Ubuntu 18.04 Bionic Beaver for the Nintendo Switch. Credits to the Switchroot L4T Ubuntu team (https://switchroot.org/) for making this possible. This project still is in a pretty early stage

## Where can I start?
### Here is a guide of how you can install the OS:
https://gbatemp.net/threads/l4t-ubuntu-a-fully-featured-linux-on-your-switch.537301/
### After that, you can start the megascript using the following command (still in progress):
- sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install bash curl -y && bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/core.sh)"


### ...Or for a Graphical User Interface Installer (even more in progress):
- sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install bash curl zenity -y && bash -c "$(curl -s https://raw.githubusercontent.com/cobalt2727/L4T-Megascript/master/core_gui.sh)"


## Scripts
We currently have the following scripts: 

- Initial Setup: Installs the swapfile, joycon mouse, 2.0 GHz overclock, SDL2 etc
- Update: Update your programs downloaidng the latest updates from the repos
- Dolphin: Gamecube and Wii emulator, latest development version
- Moonlight-qt: stream games from your PC as long as it has an Nvidia GPU!
- CSE2-Tweaks: An enhanced version of Cave Story. 60 FPS, bugs fixes, other soundtracks support
- SRB2: A 3D open-source Sonic the Hedgehog fangame built using a modified version of Doom
- RetroPie - Powerful frontend for both emulators and native programs alike
- Celeste (Pico-8 Port): A tight platforming game which lead to the development of Celeste
- Flappy Bird: A game about a bird flying in between warp pipes
- SuperTux2: A 2D jump'n run sidescroller game in a style similar to the original Super Mario games
- SM64Port - A native port of the classic game for the N64 (requires a ROM)

 We are planning in adding more scripts and functions to the script in future updates.
## To do list:
- [ ] Finish the GUI
- [x] Add the Retropie Script
- [ ] Figure a way of making Citra work
- [ ] Figure a way of making Minecraft-Bedrock work
- [ ] Add the Minecraft Script
## Our Team
- Cobalt: Manager/Lead Dev
- Lugsole: Contributor/GUI Manager 
- Lang Kasempo: Contributor/Beta Tester/Did a lot of the standalone game scripts
- Gman: Contributor/Beta Tester/RetroPie script/Celeste native port
- Fafabis: Contributor/Helped in the script GUI
- Quacka: Beta Tester/Helped in testing Retropie script
## Do you have a question or want to give ideas?
You are lucky! We have a Discord Server: https://discord.gg/UYsUFCY
## Credits
- STJr: Creators and developers of SRB2
- Clownacy: Creator and developer of CSE2-Tweaks
- RetroPie: Creators and developers of Retropie
- dolphin-emu: Creators and developers of Dolphin
- moonlight-stream: Creators and developers of Moonlight-Qt
- lemon-sherbet: Creator and developer of the Celeste Classic Port
- Acry: Creator and developer of the Flappy Bird Port
- SuperTux: Creators and developers of SuperTux2
- n64decomp: Responsible of the SM64 Decompilation Proyect
- sm64pc: Adapted the SM64 Port to work with ARM64 devices (Like the Nintendo Switch)
