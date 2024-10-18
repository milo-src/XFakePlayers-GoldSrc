
# XFakePlayers-GoldSrc

**Project Description:**
XFakePlayers-GoldSrc is a collection of reworked ZBots for games on the GoldSrc platform (such as Counter-Strike and Half-Life). The bots are integrated with Lua scripting, allowing for easy customization and editing, which makes it more versatile for developers and players.

## Features

1. **Easy Setup**:  
   Bots can be easily configured and customized through a client interface, providing maximum convenience for tweaking various parameters.

2. **Support for All GoldSrc Games**:  
   These bots are client-side and can be used in any game running on the GoldSrc engine.

3. **Advanced Navigation System**:  
   The navigation system is adapted from bots in Counter-Strike: Condition Zero, allowing seamless navigation across maps.

4. **Experimental Features**:  
   Includes flood functions, advanced AI tasks, and flexible Lua-based bot logic.

## Installation Guide

1. **Download the Project**:  
   Ensure you have the latest release of XFakePlayers. You can download the precompiled binaries (.exe and .dll) along with configuration files from the repository.

2. **Extract Files**:  
   Extract the files to the root directory of the game that runs on the GoldSrc engine.

3. **Configure Settings**:  
   Edit the following configuration files according to your needs:
   - `autoexec.cfg`: Contains initial startup commands.
   - `loop_commands.txt`: Custom looped bot actions.
   - `names.txt`: Bot names.
   - `servers.txt`: Server information for bots.

4. **Run the Bots**:  
   Launch the `XFakePlayers.exe` to start managing and customizing the bots.

## Configuration Files Overview

- **`autoexec.cfg`**: Contains game engine initialization commands.
- **`loop_commands.txt`**: Set commands for repeated bot actions.
- **`servers.txt`**: List of servers to be used by bots for connections.
- **`proxies.txt`**: Manage network proxy settings.
- **Lua Scripts**: Located in the `ai/` directory, these scripts control bot behavior, attack logic, movement, and protocol communication.

## Troubleshooting and FAQs

1. **Bots Not Responding**:  
   Ensure all configuration files are set up correctly, especially server IPs in `servers.txt`.

2. **Bot Movement Issues**:  
   Check that the waypoints for the current map are up-to-date. You can manually add waypoints or update them.

3. **AI Malfunction**:  
   Ensure Lua scripts are not conflicting. You may need to debug specific functions inside the Lua scripts if bot behavior is erratic.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
