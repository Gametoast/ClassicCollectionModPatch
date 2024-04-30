What to know for zero Patch Mod development:

1. Fake file system
	+ Perhaps the most interesting aspect of the zero patch 2.0 is the addition of the 'fake file system' (addon folder only).
	+ API: 
		- zero_patch_fs.getFiles(pattern, ext_list)
	+ Example:
		- ```local files = zero_patch_fs.getFiles("custom_gc", {".lvl", ".script"}) -- gets all the .script and .lvl files that have 'custom_gc' names.```
	+ Note:
		- Files are sorted when returned.
		- Lua has a more limited pattern matching system than most programming languages, 
			check https://riptutorial.com/lua/example/20315/lua-pattern-matching for more details.

2.  custom_gc scripts
	+ Like the 1.3 uop custom_gc scripts are supported and run before the addmes are processed.
	+ Unlike the 1.3 uop these should be kept in the addon mod folder
	+ Valid names are:
		- ```custom_gc_<anything>.lvl```
		- ```custom_gc_<anything>.script```
	+ Be careful not to be too generic with your script names, as with BF2's scripting system script names must be unique.
		- If there are 2 scripts named 'custom_gc_xyz', BF2 will only execute the first one.
3. user_script scripts
	+ Like the 1.3 uop user_script scripts are supported and run at ingame time during game_interface execution 
		(when a mission calls --> ReadDataFile("ingame.lvl") )
	+ Unlike the 1.3 uop these should be kept in the addon mod folder
	+ Valid names are:
		- ```user_script_<anything>.lvl```
		- ```user_script_<anything>.script```

4. Data passed through to ingame from shell.
	+ Currently we are passing the 'zero_patch_data' table from shell --> ingame.
	+ This table can hold about 200 characters, so do not pack too much data onto it.
	
5. Mod Menu Tree
	+ The mod menu tree is intended to offer an easy way to get input from a user.
	+ What is the Mod Menu Tree?
		- It's a list
	+ What properties do the list items need to have?
		- Each item has an id, displayStr and action.
			+ id: string 
			+ displayStr:  can be a const string, localization string id or function that returns a string.
			+ action: can be a string, function or table
				- string   --> The mod menu tree will do a 'ScriptCB_PushScreen(id)' 
				- function --> The mod menu tree will call function(id)
				- table    --> The mod menu tree will load the contents of the table into the current display.
								Not just any table will work, Must be a list of valid menu tree items.
	+ What's with 'OptionsSettings'?
		- This is a special pattern that should make it easy to present the user with options.
		- Call the 'CreateOptionsSetting(mySettingsTable)' function with the appropriate table filled out and then add the result 
		  to the mod menu tree.
		- where 'mySettingsTable' should have a form like: 
		```LUA
		{
				default = 9,                             -- > used when target_table[property_name] is nil
				target_table = zero_patch_data,          -- > the table we'll set the data on
				property_name = "my_setting",            -- > saved to --> target_table.my_setting
				title = "My Setting",
				callback = nil,                          -- > Callback once the data is set
				options = {0,1,2,3,4,5,6,7,8,9}          -- > List of options to show
		 } 
		 ```
	+ When can I add items to the Mod Menu Tree?
		- In your addme; after the '0' addme has been processed the mod menu tree functions will be available.
6. Mod Menu Tree Examples:
	+ [launch_my_mission](https://github.com/Gametoast/ClassicCollectionModPatch/tree/master/documentation/mod_menu_tree_examples/launch_my_mission)
	+ [set_alternate_default_path](https://github.com/Gametoast/ClassicCollectionModPatch/tree/master/documentation/mod_menu_tree_examples/set_alternate_default_path)
	+ [simple_settings](https://github.com/Gametoast/ClassicCollectionModPatch/tree/master/documentation/mod_menu_tree_examples/simple_settings)
	
