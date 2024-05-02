
[comment]: <> (VS Code markdown preview -> Ctrl+k, v)
# Classic Collection Mod Patch

## Developers/modders
Put this git repo under your 'BF2_ModTools\\' Folder for the 'munge' to work.


## Compatibility
This patch is compatible with Battlefront Classic Collection (BF2) [Steamdeck, Switch, Windows] and the OG SWBF2 game from steam, GOG and DVD.

But please note that most mods released in the last 20 years have not been tested against the Battlefront Classic Collection and some may encounter issues that this patch cannot solve.

## Goals of Patch
1. Make it easy to install 'standard' and 1.3 uop based mods/addons to Battldfront Classic Collection (BF2)
2. Minimize the destruction/overwrite of game files.
3. Support as many features of the 1.3 uop as possible.
4. Be compatible with all versions of the (base) game. [XBOX, PS2 & PSP versions are untested with this patch, but should be compatible]

## Initial Patch Application (initial setup requires 'virgin' setup; i.e. ingame.lvl, shell.lvl, common.lvl should be the originals)
1. Place the '0' folder in your addon2 folder.
2. Copy your 'data2\\_lvl_common\\commom.lvl' file to the '0\\base_common.lvl_goes_in_here\\' folder 
3. Run the 'Apply_patch.bat' file to create a 'patched' common.lvl (saved to '0\\common.lvl')
4. Copy the '0\common.lvl' file back over to your Game's 'data2/_lvl_common/' folder
5. Copy the (platform specific) 'run_after_making_changes_xxx' script to the addon2 folder (different script flavors for Windows, Linux/steamdeck,  switch).

What this does-> replaces a file inside common.lvl that we can use as a hook into the game's runtime. 

#### Note:
If you remove the '0' folder, you should basically be running an un-patched game; becasue none of the runtime adjustments and additions that we perform will be done if that '0' folder is gone.

## Adding mods/addons & making file changes
1. Place the downloaded mod into the 'addon2' (or 'addon') folder
2. Run the 'run_after_making_changes_xxx' script ( windows, switch & linux/steamdeck supported)
3. Note: Some mods have 'custom_gc' or 'user_script' files that go along with them. Put these in the mod folder that they belong to. If a mod has some scripts that should not be run, create a 'disabled' folder for that mod and place them inside that 'disabled' folder. Files inside a 'disabled' folder will be ignored.

#### What the 'run_after_making_changes_xxx' script does:
1. Renames the '_lvl_pc' folders to '_lvl_common' inside the addon folders (the Game seems to be able to better reference the dlc files that way)
2. Creates a file that is read in at runtime that acts as a 'fake file system' (this gives the system the ability to easily find mod scripts and allows for better naming of scripts too).

The 'Switch' specific script also re-names all the files and folders under 'addon2/' to be lower case.

## Steamdeck users
Q: Do I need to 'chmod +x' the 'run_after_making_changes_linux.sh' script?

A: Yes, once you copy it to your 'addon2' folder you'll need to do a
```chmod +x run_after_making_changes_linux.sh```
before you can run it. Once you've done that, it should run by double-clicking or by calling it through the terminal.

Q: Do I need to run the Apply_Patch script on a Windows machine?

A: Yes, it would be too complicated to make sure the user had the right runtime stuff for it to work on Steamdeck. But it's certainly possible that it could be made to run on the steamdeck through Bottles or Wine (or maybe Mono too) + script edits.

## Is this different than the 1.3 UOP?
Yes. We do try to make it feature compatible with the 1.3 UOP. But not all features are possible, 'Freecam' is not supported in BF CC, so we're out of luck there.
But if you are seeing some 1.3 UOP features not present or not working then please file a bug on the GitHub repo.

## Releases
Releases will be in the 'Releases' portion of this repo.
As of the creation of this repo the game is new and we would expect updates.
With 2005 Star Wars Battlefront II PC, many mods relied on an unofficial patch for much functionality and some base game files were overwritten to accomplish this.

### Battlefront 1 modding notes
As of initial release (14 March 2024) the BF1 CC game seems to have switched from Lua 4.0 to using Lua 5.0.2. Unless the go back to Lua 4.0, it means that every BF1 mod will need to be re-built. :(

### Battlefront 2 (classic collection) modder notes
 * BF2 CC does seem kinda broken with regard to the 'dc:' file prefix, but 'ReadDataFile' and 'OpenAudioStream' do work from an addon's '_lvl_common' folder.
 * The 'dc:' file prefix does work with 'ReadDataFile' under the mod's '_lvl_pc' folder too.
 * With regards to ScriptCB_IsFileExist and 'ReadDataFile' and the other functions that reference files, we will re-direct if we detect 'addon\\' or '\\_lvl_pc\\' in the path being referenced.

The following calls have not yet been checked with the 'dc:' prefix:
1. ScriptCB_OpenMovie
1. PlayAudioStream
1. PlayAudioStreamUsingProperties


### Zero Patch development Team
- BAD-AL
- MileHighGuy (milehighguy-dev)
- S1thK3nny 
- marth8880
- iamastupid/imashaymin
- AnthonyBF2
- BK2-modder

### Zero Patch Test Team
- Burumaru
- lui
