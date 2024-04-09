
[comment]: <> (VS Code markdown preview -> Ctrl+k, v)
# Classic Collection Mod Patch

## Users
It's under development, probably don't use it unless you're really curious or part of the development team.

## Developers
Put this git repo under your 'BF2_ModTools\\' Folder for the 'munge' to work.

## Initial Patch
1. Place the '0' folder in your addon2 folder.
2. Copy your 'data2\\_lvl_common\\commom.lvl' file to the '0\\base_common.lvl_goes_in_here\\' folder 
3. run the 'Apply_patch.bat' file to create a 'patched' common.lvl (saved to '0\\common.lvl')
4. Copy the '0\common.lvl' file back over to your Game's 'data2/_lvl_common/' folder
5. Copy the (platform specific) 'XXX_bf2_cc_fix' script to the addon2 folder (different script flavors for Windows, Linux/steamdeck,  switch).

What this does-> replaces a file inside common.lvl that we can use as a hook into the game's runtime. 

#### Note:
If you remove the '0' folder, you are basically running an un-modded game becasue none of the runtime adjustments and additions that we perform will be done if that '0' folder is gone.

## Adding mods/addons
1. Place the downloaded mod into the 'addon2' folder
2. Run the XX_BF2_CC_Fix script ( 'windows_BF2_CC_fix.bat' for windows, 'switch_bf2_cc_fix.bat' for switch, 'linux_bf2_cc_fix.sh' for steamdeck)

What the 'fix' script does -> renames the '_lvl_pc' folders to '_lvl_common' under the addon folders. The Game seems to be able to better reference the dlc files that way.

The 'Switch' specific script also re-names all the files and folders under 'addon2/' to be lower case.

## Steamdeck users
Q: Can I just run the 'windows_BF2_CC_fix.bat' and then copy my mods over to my steamdeck?

A: Yes, that should work too.

Q: Do I need to 'chmod +x' the 'linux_bf2_cc_fix.sh' script?

A: Yes, once you copy it to your 'addon2' folder you'll need to do a
```chmod +x linux_bf2_cc_fix.sh```
before you can run it. Once you've done that, it should run by double-clicking or by calling it through the terminal.

Q: Do I need to run the Apply_Patch script on a Windows machine?

A: Yes, it would be too complicated to make sure the user had the right runtime stuff for it to work on Steamdeck. But it's certainly possible that it could be made to run on the steamdeck.

## Is this different than the 1.3 UOP?
Yes. We do try to make it feature compatible with the 1.3 UOP though; so if you are seeing some 1.3 UOP features not working then please file a bug on the GitHub repo.

## Can this patch be used with the base Battlefront II game too?
Yes, that's a goal it should be compatible with the Base Battlefront II game (if for no other reasons, just for debugging); but don't expect it to work in addition to Remaster Mod (AnakinGT) or the old 1.3 UOP. But you wouldn't run the 'BF2_CC_fix' scripts for the 2005 game.


## Releases
Releases will be in the 'Releases' portion of this repo.
As of the creation of this repo the game is new and we would expect updates.
With 2005 Star Wars Battlefront II PC, many mods relied on an unofficial patch for much functionality and some base game files were overwritten to accomplish this.


### Battlefront 1 modding notes
As of initial release (14 March 2024) the BF1 CC game seems to have switched from Lua 4.0 to using Lua 5.0.2. Unless the go back to Lua 4.0, it means that every BF1 mod will need to be re-built. :(

### Battlefront 2 (classic collection) modding notes
 * BF2 CC does seem kinda broken with regard to the 'dc:' file prefix, but 'ReadDataFile' and 'OpenAudioStream' do work from an addon's '_lvl_common' folder.
 * The 'dc:' file prefix does work with 'ReadDataFile' under the mod's '_lvl_pc' folder too.
 * With regards to ScriptCB_IsFileExist and 'ReadDataFile' and the other functions that reference files, we will re-direct if we detect 'addon\\' or '\\_lvl_pc\\' in the path being referenced.

The following calls have not yet been checked with the 'dc:' prefix:
1. ScriptCB_OpenMovie
1. PlayAudioStream
1. PlayAudioStreamUsingProperties
