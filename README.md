# nophenia-teleport-menu
A simple teleport menu for the [nophenia](nophenia.net) game that allows you to traverse between stages easily!

## Installation
1. Mod your game (easiest way is by installing the [multiplayer mod](https://github.com/BdEgh/nophenia-mp#installing))
2. Download the latest zip from the [releases page](https://github.com/wojtas3422/nophenia-teleport-menu/releases)
3. Drop the zip inside the ``mods`` folder at your modded games directory
4. Launch the game!

## Controls
Search field is always focused when you open the menu and is reset on teleport.
- ``F1`` - toggle the menu (can be rebound)
- ``Esc`` - close menu
- ``Enter`` - teleport to topmost result or teleport to selected stage
- ``Tab`` - move focus to stage list
- ``Up arrow and down arrow`` -  **When focusing stage list**, move up and down in the stage list

## Rebinding
You can rebind the open menu key via the config file.
- On Windows: navigate to ``%appdata%\nophenia_mp`` (or ``%appdata%\nophenia`` if you uninstalled the multiplayer mod) and edit the ``tp.cfg`` file.
- On Linux: navigate to ``~/.local/share/nophenia_mp`` (or ``~/.local/share/nophenia`` if you uninstalled the multiplayer mod) and edit the ``tp.cfg`` file.

Key "numbers" can be found [on the godot Key documentation](https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-key)