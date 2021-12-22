# DISCLAIMER: USE AT YOUR OWN DEVICE'S RISK. BEAR IN MIND SOME OF THE SCRIPTS MAY SCREW UP YOUR INSTALLATION, ESPECIALLY IF YOU'RE NOT USING TEGRA HARDWARE. PLUS, WE MANUALLY COMPILE A FEW OF THE PROGRAMS INCLUDED HERE, SO IF YOU'RE REBUILDING PROGRAMS TOO OFTEN IT MAY SHORTEN THE LIFESPAN OF YOUR SD CARD.
## L4T-Megascript
![Logo](https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/L4T_Megascript-logo-transparent-effect.png)
**We did the hard parts so you don't have to!**

## What is this?

The L4T Megascript is an open source multipurpose script for easily installing and updating a diverse collection of programs in L4T Ubuntu, with the purpose of helping new users to install programs and games in just a few steps. Currently designed with 18.04 in mind, but almost everything should be ready for when L4T updates to 20.04. Credit to the Switchroot L4T Ubuntu team (https://switchroot.org/) for making this possible. This project still is in a pretty early stage, but it's more than usable already for most of what's included. Give it a try, and send us feedback!

## Install/run the script
### The script itself doesn't actually get installed, even though it does install a lot of other programs and features. It all runs directly off of this GitHub page so you don't have to worry about updating things on your end! Get started at the link below:
https://github.com/cobalt2727/L4T-Megascript/wiki/Initial-Setup

## DISCLAIMER: in the interest of transparency and security we recommend reading through the source code yourself by checking recent commit history and/or downloading a local copy of the source code. NEVER RUN SCRIPTS FROM THE INTERNET YOU DON'T TRUST! (That being said, if you do try reading our source code and something doesn't make sense to you, feel free to hop in the Discord server using the link below and ask about it - we're happy to help!)

## All scripts
Check the [Wiki page for Scripts](https://github.com/cobalt2727/L4T-Megascript/wiki) for the most updated information!
## Planned features:
- Finish all the wiki pages (and ideally, migrate them over in the long run to https://squidfunk.github.io/mkdocs-material/ like RetroPie's [really cool documentation](https://retropie.org.uk/docs/))
- ~~Automate adding performance mods to the Minecraft Java script for a MASSIVE, consistent framerate boost~~ <Br>
Done: Make sure to click the "Install Fabric" button within the Minecraft instance, otherwise the mods won't be loaded
- ~~Figure out a good process to compile [Xemu](https://github.com/mborgerson/xemu), possibly use the PPA as a fallback~~ <Br>
Kind of done: we've made a [script for it](https://github.com/cobalt2727/L4T-Megascript/blob/master/scripts/games_and_emulators/xemu.sh), but it doesn't automatically set up desktop files for the installation, so we need to do that ourselves at some point
- Updated Kodi packages at some point, maybe - it's definitely _possible_ when compiled manually, it's just a question of how easy is it to get everything we need working properly. The annoying part is there's already a PPA out there for 18.04, but it doesn't support ARM devices...
- More to come!
## Our Team
- Cobalt: Manager/Lead Dev
- theofficialgman: Contributor, UI designer
- Lugsole: Contributor
- Azkali: Advice/part of Switchroot dev team
- all the users that put up with Cobalt breaking things every other week or so


## Need some help or want to contribute?
You're in luck - we've got a Discord server: [![Discord invite](https://discord.com/assets/ff41b628a47ef3141164bfedb04fb220.png)](https://discord.gg/abgW2AG87Z "Discord server invite link") <Br>
[Click to join](https://discord.gg/abgW2AG87Z) <Br>

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
