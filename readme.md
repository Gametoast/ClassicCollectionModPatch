# Classic Collection Mod Patch
Enabling mods to run on the new Classic collection PC game
This is a developing effort to get the  PC Mod Maps from the older version of the games to work with the Classic Collection.

As of the creation of this repo the game is new and we would expect updates.

With 2005 Star Wars Battlefront II PC, many mods relied on an unofficial patch for much functionality and some base game files were overwritten to accomplish this.

### Overall goals
 - mods working for the 2024 Classic Collection Battlefront


### Design goals
 - Don't change any game files delivered by the game developer.
 - If you must change a game file, change as few as possible; keep code in a state where if you remove the patch addon folder then the game behaves as though it is gone.

### Battlefront 1 modding notes
As of initial release (14 March 2024) the BF1 CC game seems to have switched from Lua 4.0 to using Lua 5.0.2. Unless the go back to Lua 4.0, it means that every BF1 mod will need to be re-done. :(

