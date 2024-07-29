-- user_script_snailtank_fix.lua
-- Description: Fixes issue where cis snailtank treads don't move.
--
local oldReadDataFile = ReadDataFile
local function LoadSnailtank()
	print("info: LoadSnailtank()")
	-- use the zero_fs to find the right file; 'cis_tread_tank.msh' file munged with the proper options
	local result = zero_patch_fs.getFiles("cis_tread_tank", {".lvl"})
	if( table.getn(result) > 0) then 
		ReadDataFile(result[1])
		print("info: run fix for 'cis_tread_tank' ")
	else
		print("info: Oopsie! 'cis_tread_tank.lvl' not found")
	end
end

ReadDataFile = function(...)
	if(string.upper(arg[1]) == "SIDE\\CIS.LVL") then
		local index = 2
		local length = table.getn(arg)
		while index < length do
			if( string.lower(arg[index]) == "cis_tread_snailtank") then
				LoadSnailtank()
				break
			end
			index = index + 1
		end
	end
	return oldReadDataFile(unpack(arg))
end