### DISCLAIMER:
Some of the scripts shown here *may* screw up your installation if you're not using Tegra hardware. Most of them should be fine to use on other systems, but double-check the source code first.
In addition, keeping your Tegra system overclocked too often or rebuilding programs too often might shorten the lifespan of your system or the SD card.
<p align="center">
    <img src="https://github.com/cobalt2727/L4T-Megascript/raw/master/assets/L4T_Megascript-logo.svg" height=256 alt="L4T-Megascript Logo"
</p>

<p align="center">All-in-one installer and updater for popular programs on L4T Ubuntu with no prior knowledge of Linux needed
<p align="center">
  <a href="https://github.com/cobalt2727/L4T-Megascript/wiki">
    Scripts List</a>
  |
  <a href="https://discord.gg/abgW2AG87Z">
    Join the <img src="https://img.shields.io/discord/719014537277210704.svg?color=7289da&label=Discord%20server&logo=discord" alt="Join the Discord server"></a>
  |
  <a href="https://github.com/cobalt2727/L4T-Megascript/issues">
    Report an error</a>
  |
  <a href="https://github.com/cobalt2727/L4T-Megascript/discussions/categories/ideas">
    Submit a suggestion</a>
  |
  <a href="https://github.com/cobalt2727/L4T-Megascript/pulls">
    Submit a script</a>

## What is this?

The L4T Megascript is an open source multipurpose script for easily installing and updating a diverse collection of programs in L4T Ubuntu, with the purpose of helping new users to install programs and games in just a few steps. Currently designed with [Switchroot Ubuntu 24.04](https://wiki.switchroot.org/wiki/linux/l4t-ubuntu-noble-installation-guide) in mind, but almost everything should still run on 18.04 and up. Credit to the [Switchroot L4T Ubuntu team](https://switchroot.org/) for making this possible on Nintendo Switch devices, and, of course, Nvidia as well for L4T in general. We appreciate any and all feedback!

## Install/run the Megascript
The script itself doesn't actually get installed, even though it does install a lot of other programs and features. All it downloads to your device is a little text file and desktop icon that runs the script directly off of this GitHub repo so you don't have to worry about updating things on your end! [Click here to get started!](https://github.com/cobalt2727/L4T-Megascript/wiki/Initial-Setup)
<Br>

### DISCLAIMER: In the interest of transparency and security we recommend reading through the source code yourself by checking recent commit history and/or downloading a local copy of the [latest source code](https://github.com/cobalt2727/L4T-Megascript/archive/refs/heads/master.zip). *NEVER RUN SCRIPTS FROM THE INTERNET YOU DON'T TRUST!* (That being said, if you do try reading our source code and something doesn't make sense to you, feel free to check our [wiki](./wiki) or hop in the Discord server using the link below and ask about it - we're happy to help!)

## Planned features:
- Bring Fedora support to ALL scripts (this is currently a very long WIP, may require custom COPR repos with build flags for Tegra in some cases)
    - compile [ES-DE](https://gitlab.com/es-de/emulationstation-de/) (or just use an AppImage) as a cross-platform replacement for RetroPie (though we'd still use RetroPie's build scripts to generate the premade Tegra RetroArch cores)
    - alternatively, just use vanilla RetroArch and [make sure the online updater is disabled](https://wiki.archlinux.org/title/RetroArch#Enabling_the_%22Online_Updater%22) then auto download gman's cores instead
- Add a build script and default configurations for [Slippi](https://slippi.gg/) - currently not possible until they rebase on mainline Dolphin instead of Ishiiruka
- Add more apps!

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
- OpenMW: Developers, OpenMW
- many more!
