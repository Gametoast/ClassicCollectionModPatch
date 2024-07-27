-- user_script_han_fix.lua
-- HanFix by bad_al_, Rayman1103
-- Description: Fixes issue where Han Solo crashes the game.
--

-- need to set 
-- MedalsTypeToLock = -1 in "all_weap_hero_hanpistol.odf"

local oldReadDataFile = ReadDataFile

local function LoadHanPistol()
	print("info: LoadHanPistol()")
	-- use the zero_fs to find the right file
	local result = zero_patch_fs.getFiles("all_weap_hero_hanpistol", {".lvl"})
	if( table.getn(result) > 0) then 
		ReadDataFile(result[1], "all_weap_hero_hanpistol")
		print("info: run fix for 'all_weap_hero_hanpistol' ")
	else
		print("info: Oopsie! 'all_weap_hero_hanpistol.lvl' not found ")
	end
end

ReadDataFile = function(...)
	if(string.upper(arg[1]) == "SIDE\\ALL1.LVL") then
		local index = 2
		local length = table.getn(arg)
		while index < length do
			if( string.lower(arg[index]) == "all_hero_hansolo_tat") then
				LoadHanPistol()
				break
			end
			index = index + 1
		end
	end	
	return oldReadDataFile(unpack(arg))
end
