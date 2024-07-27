
[comment]: <> (VS Code markdown preview -> Ctrl+k, v)
# Classic Collection Mod Patch

## GitHub repo
https://github.com/Gametoast/ClassicCollectionModPatch

## Videos
- [Windows install](https://youtu.be/fgMN85mlxiI)
- [Steamdeck install](https://youtu.be/3Cg_rfeJIZA)
- [Mod Developer guide](https://youtu.be/8G9ApaOUGpE)

## Compatibility
This patch is compatible with 
- Battlefront Classic Collection (BF2) [Steamdeck, Switch, Windows]
- Original Star Wars Battlefront II [steam, GOG, DVD]

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
If you remove the '0' folder, you should basically be running an un-patched game; becasue none of the 'zero patch' runtime adjustments/modification will be performed if that '0' folder is gone.

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

A: The .sh file will need to be 'executable'; this can be done with ```chmod +x run_after_making_changes_linux.sh```
 or by other means. Once it has been made 'executable' it should run by double-clicking or by calling it through the terminal.

Q: Do I need to run the Apply_Patch.bat script on a Windows machine?

A: No, it may be most easy to copy the common.lvl file over to windows to do the apply_patch.bat step, but it can also be accomnplished through 'Bottles' as the Steamdeck install video demonstrates.

## Is this different than the 1.3 UOP?
Yes. We do try to make it feature compatible with the 1.3 UOP. But not all features are possible, 'Freecam' is not supported in BF CC, so we're out of luck there.
But if you are seeing some 1.3 UOP features not present or not working then please file a bug on the [GitHub repo issues page](https://github.com/Gametoast/ClassicCollectionModPatch/issues).

## Releases
Releases will be in the ['Releases' portion of this repo](https://github.com/Gametoast/ClassicCollectionModPatch/releases).

### Battlefront 1 modding notes
As of initial release (14 March 2024) the BF1 CC game seems to have switched from Lua 4.0 to using Lua 5.0.2. Unless the go back to Lua 4.0, it means that every BF1 mod will need to be re-built. :(

### Battlefront 2 (classic collection) mod developer notes
 * 'ReadDataFile' and 'OpenAudioStream' do work with the 'dc:' file prefix from an addon's '_lvl_common' folder.
 * With regards to ScriptCB_IsFileExist and 'ReadDataFile' and the other functions that reference files, we will re-direct to the appropriate location if we detect 'addon\\' or '\\_lvl_pc\\' in the path being referenced.

### Building the 'zero patch'
Put/clone this git repo under your 'BF2_ModTools\\' Folder for the 'munge' to work.


The following calls have not yet been checked with the 'dc:' prefix:
1. ScriptCB_OpenMovie
2. PlayAudioStream
3. PlayAudioStreamUsingProperties


### Zero Patch development Team
- BAD-AL
- MileHighGuy (milehighguy-dev)
- S1thK3nny 
- marth8880
- iamastupid/imashaymin
- AnthonyBF2
- BK2-modder
- Rayman1103

### Zero Patch Test Team
- Burumaru
- lui

### Legacy Contributors
- Pandemic
- GTAnakin
- Zerted



# July 26 2024 Release notes (Release 2.1)

- Intended for use with Aspyr Update 3 (20 June 2024)

Mod compatibility Game Settings
For increased compatibility with mods make the following changes to your video settings 

Options > Video Settings > (X) Custom Options:
- Lighting Quality - Low
- Lignt Bloom      - Off

|Added fixes for:|      |    |
|----------------|------|----|
|  | Aspyr broke mod localization (this fix is imperfect, but usually works).        | user_script_loc_fix.script |
|  | Aspyr broke in-game-music for most mods.                                        | user_script_cc_music_fix.script |
|  | Command Posts 1 and 4 aren't counted as valid CPs for Rhen Var Citadel Conquest.| user_script_rhenvar2_cp_fix.script |
|  | Command Posts 1 and 4 aren't counted as valid CPs for Rhen Var Citadel Conquest.| user_script_rhenvar2_cp_fix.script |
|  | Adjust to Aspyr making AI heroes work in-game.                                  | removed 'user_script_ai_hero_support.script' |



|Added features:|   |   |
|---------------|---|---|
|  |  Option to keep Aspyr instant action screen (0\shell-options\use_0_patch_instant_action_screen.txt)|  |
|  |  Windows users now have option to use batch file to copy over common.script for the patch.|  |
|  |  Locals get yellow command posts. user_script_locals_yellow_team.script|  |
|  |  Keep heroes out of turrets. user_script_ai_hero_no_turret.script|  |
|  |  Play hero voices when entering/exiting the Battlefield. user_script_hero_vo.script|  |
|  |  Fake Console - Made specific commands only appear depending on if a controller was used to open the Fake Console menu or mouse & keyboard.| |
|  |  Fake Console - All team specific commands will now display the team name in brackets.| |
|  |  Fake Console - Added support to automatically check the number of teams when building the command list.| |
|  |  Fake Console - Updated the "Reset Carried Flags" command to automatically set the flag names instead of using manually set names.| |
|  |  Fake Console - Added various Command Post related commands if playing Conquest mode.| |
|  |  Fake Console - Added Kit Fisto and Assajj Ventress to the list of Hero commands.| |
|  |  Fake Console - Minor spelling errors were fixed in a few commands.| |

# July 27 2024 Release notes (Release 2.2)
|Added fixes for:|      |     |
|----------------|------|-----|
| | Aspyr broke Han Solo| user_script_han_fix.script + all_weap_hero_hanpistol.lvl |
