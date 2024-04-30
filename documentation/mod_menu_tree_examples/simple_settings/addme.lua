
print("info: simple_settings\\addme.lua start")


if CreateOptionsSetting ~= nil then              -- Test to see if the mod menu tree functionality is present

	-- ==================================================================================
	-- simple options setting that just sets data on a lua table.
	local optionData =  {
		default = 9,                             -- > used when target_table[property_name] is nil
		target_table = zero_patch_data,          -- > the table we'll set the data on (for the 'zero_patch' this will be passed through to ingame)
		property_name = "my_iq",                 -- > saved to --> target_table.my_setting
		title = "My IQ",
		callback = nil,                          -- > no callback
		options = {0,10,50,80,100,110,130,150,180,900}
	}

	local menuSettingsItem = CreateOptionsSetting(optionData)
	AddModMenu(menuSettingsItem)


	-- ==================================================================================
	-- options setting that sets data on a lua table and utilizes a callback function .
	
	-- the callback function for when the setting is made
	local function momCallback(option_id)
		print("info: Your momn is: " .. tostring(option_id))
	end

	local optionData2 =  {
		default = "Mazda",
		target_table = zero_patch_data,          
		property_name = "car",            
		title = "Your car brand is",
		callback = momCallback,
		options = { 
				"Toyota", 
				"Honda",
				"Mazda", 
				"Chevy", 
				"Ford", 
				"Tesla",
				"Hyundai",
				"Volkswagen",
				"Some brand owned by a French company",
		}
	}
	local menuSettingsItem2 = CreateOptionsSetting(optionData2)
	AddModMenu(menuSettingsItem2)
else
	print("the function 'CreateOptionsSetting' for the mod_menu_tree' was not found, can't add settings.")
end


print("info: simple_settings\\addme.lua end")
