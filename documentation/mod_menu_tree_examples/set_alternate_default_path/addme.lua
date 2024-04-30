
-- Settings option that works in conjunction with 'user_script_alternate_default_path.lua'
-- to do easy 'replacements' probably useful for 'sides' or 'world' replacements.

if( zero_patch_fs ~= nil and zero_patch_data ~= nil) then
	print("info: setting up 'Mod Folder Override Path'")
	
	local function getBaseFolder(filePath)
		local pattern = "\\([A-Za-z0-9_-]+)\\data\\"
		local s,e, retVal = string.find(filePath, pattern)
		return retVal
	end

	-- we'll try to get an idea about which mods are installed by getting all the 'nab2.lvl' files
	local files = zero_patch_fs.getFiles("nab2.lvl") --> "..\..\addon2\HF2\data\_lvl_common\dea\nab2.lvl"
	local options = { "nil",}
	local current = nil
	print("info: num cores:" .. table.getn(files))
	
	for k,v in files do 
		current = getBaseFolder(v)
		if( current ~= nil) then 
			print("info: current: " .. tostring(current))
			table.insert(options, current)
		end
	end
	print("debug processed the files")
	local optionData =  {
		default = "nil", 
		target_table = zero_patch_data,
		property_name = "override_path",
		title = "Mod Folder Override Path",
		callback = nil,
		options = options,
	}

	local menuSettingsItem = CreateOptionsSetting(optionData)
	AddModMenu(menuSettingsItem)
	print("info: 'Mod Folder Override Path' added to mod menu tree")
else
	print("info: can't setup 'Mod Folder Override Path'")
end
