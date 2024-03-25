# Classic Collection Mod Patch

# Under Development

## Developers
Put this git repo under your BF2_ModTools Folder for the 'munge' to work.

Place the '0' folder in your addon2 folder.
Copy your commom.lvl file under the obviously named folder in the '0' folder and use the 'Apply_patch.bat' file
to create a common.lvl file for you to copy back over to your _lvl_common.
In the future we can make this automatic, but for now we keep it simple.


## Users
Don't use this yet, it's under development.

Enabling mods to run on the new Classic collection PC game
This is a developing effort to get the  PC Mod Maps from the older version of the games to work with the Classic Collection.

Releases will be in the 'Releases' portion of this repo.
As of the creation of this repo the game is new and we would expect updates.
With 2005 Star Wars Battlefront II PC, many mods relied on an unofficial patch for much functionality and some base game files were overwritten to accomplish this.


### Battlefront 1 modding notes
As of initial release (14 March 2024) the BF1 CC game seems to have switched from Lua 4.0 to using Lua 5.0.2. Unless the go back to Lua 4.0, it means that every BF1 mod will need to be re-done. :(

### Battlefront 2 (classic collection) modding notes
As of initial release and PC Patch #1, the only function call that is confirmed to correctly resolve the 'dc:' file prefix is 'ReadDataFile'

The following calls do not currently resolve 'dc:'
1. OpenAudioStream

The following calls have not been checked, but are assumed not to resolve 'dc:':
1. ScriptCB_OpenMovie
1. PlayAudioStream
1. PlayAudioStreamUsingProperties

The bottom line is that currently SWBF2 mods will not work 100% and unless these issues are addressed by Aspyr all mods utilizing the 'dc:' resolver (other than for 'ReadDataFile') will need to be re-worked to properly function on the Classic Collection.