===== '0' patch for Battlefront 1 Classic Collection =====
1. Place this '0' folder inside the 'addon1' folder.
2. Run the 'initial_setup.bat' file
   (once 'initial_setup.bat' has been run, you can move it to the 'bin' folder to reduce clutter)
3. Copy the 'run_after_making_changes.bat' in the 'addon1' folder
4. Run the 'run_after_making_changes.bat' from the addon1 folder


Functionality Summary:
Localization fix; all BF1 mods will still need to be re-built to be used with Classic Collection
  (due in the Lua 4.0 -> Lua 5.0.2 change)

(initial_setup.bat)
* Backup original '_lvl_pc\loading.lvl' to _lvl_pc\ZZ_BACKUP\loading.lvl'
* Copy original '_lvl_pc\loading.lvl' to '0\base.loading.lvl'

(run_after_making_changes.bat)
* Gathers Strings found in in the different addons and merges them into the localization
   sections of "data1\_lvl_pc\loading.lvl"

