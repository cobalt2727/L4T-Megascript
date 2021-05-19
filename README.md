# NOT READY YET - WE'RE STILL A WAYS TO GO BEFORE ANYTHING HERE IS CONSIDERED READY TO GO PUBLIC. USE AT YOUR OWN DEVICE'S RISK. BEAR IN MIND SOME OF THE SCRIPTS MAY SCREW UP YOUR INSTALLATION, ESPECIALLY IF YOU'RE NOT USING TEGRA HARDWARE.
## L4T-Megascript
![Logo](https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/L4T_Megascript-logo-transparent-effect.png)
**We did the hard parts so you don't have to!**

## What is this?

The L4T Megascript is an open source multipurpose script for easily installing and updating a diverse collection of programs in L4T Ubuntu, with the purpose of helping new users to install programs and games in just a few steps. Currently designed with 18.04 in mind, but almost everything should be ready for when L4T updates to 20.04. Credit to the Switchroot L4T Ubuntu team (https://switchroot.org/) for making this possible. This project still is in a pretty early stage, but it's more than usable already for most of what's included. Give it a try, and send us feedback!

## Install/run the script
### The script itself doesn't actually get installed, even though it does install a lot of other programs and features. It all runs directly off of this GitHub page so you don't have to worry about updating the script! Get started at the link below:
https://github.com/cobalt2727/L4T-Megascript/wiki/Initial-Setup

DISCLAIMER: in the interest of transparency and security we recommend reading through the source code yourself by checking recent commit history and/or downloading a local copy of the source code. NEVER RUN LINUX SCRIPTS YOU DON'T TRUST!

## Scripts
Some of our included program install scripts are below: 

- Initial Setup: Installs the joycon mouse, flapack fix, SDL2 etc
- Update: Update your programs (APT, Flatpak, dolphin emulator, maybe someday automatic source code builds)
- Dolphin: Gamecube and Wii emulator, latest development version
- Citra: 3DS emulator (THE SCRIPT WILL NOT WORK ON 18.04 and is hidden, WAIT FOR SWITCHROOT TO RELEASE A WORKING 20.04/20.10 IMAGE)
- Moonlight-qt: stream games from your PC as long as it has an Nvidia (with Gamestream) or AMD (with Sunshine) GPU!
- Minecraft Bedrock (Android Version) - Android Minecraft Bedrock Version. Ownership of the Android Version Required (controllers function but may cause Minecraft to crash on launch)
- MultiMC Minecraft Java - Mincraft Java Launcher, Instance, and Mod Manager
- Discord (Webcord) Webapp - Electron based discord webapp built on the discord browser version.
- SRB2: A 3D open-source Sonic the Hedgehog fangame built using a modified version of Doom
- SRB2Kart: A kart racing game using SRB2 as a base
- RetroPie: Powerful frontend for both emulators and native programs alike
- Celeste (Pico-8 Port): A tight platforming game which lead to the development of Celeste
- SM64Port: A native port of the classic game for the N64 (requires your own, **legally** dumped ROM)

 We are planning in adding more scripts and functions to the script in future updates.
 (Check the repo folders for scripts currently in progress but not yet available in the gui/cli)
## Planned features:
- Finish all the wiki pages 
- Add the Sodium/Lithium/Phosphor mods (for performance) to the Minecraft script - only thing stopping this from happening right now is figuring out how to automatically build from source **if and only if** it's somehow detected that the most recent build of the most isn't compatible with the current version of Minecraft
- _Possibly_ work on including the manually built scripts here into the updater?
- More to come!
## Our Team
- Cobalt: Manager/Lead Dev
- Lugsole: Contributor
- Lang Kasempo: Contributor
- theofficialgman: Contributor
- Fafabis: Contributor
- Azkali: Advice, part of Switchroot dev team
- Beta testers in the Discord that put up with Cobalt breaking things every other day


## Do you have a question or an idea about the project?
You're in luck - we've got a Discord server: [opening soon™!] <Br>
Also chekout the discussions tab, make a post there with your ideas!

## Credits
- STJr: Developers, SRB2
- Kart Krew: Developers, SRB2Kart
- RetroPie: Developers, RetroPie (who would've guessed?)
- dolphin-emu: Developers, Dolphin
- moonlight-stream: Creators and developers of Moonlight-QT
- lemon-sherbet: Developer, Celeste Classic port
- Acry: Developer, Flappy Bird port
- SuperTux: Developers, SuperTux2
- n64decomp: Responsible for the SM64 Decompilation Project
- sm64pc: Adapted the SM64 Port to work with ARM64 devices
- many more!
