-- 'user_script' companion to 'set_alternate_path' Mod Menu Tree Example
-- author: BAD-AL 

-- Attempts to override the base game path.
-- Will check to see if there exists a file at the override file path location and if so, will read that file instead.

if( zero_patch_data ~= nil and zero_patch_data.override_path ~= nil) then -- check for the setting before we attempt to do any of this stuff
	print("info: setup alternate default path from addon folder.")
	
	-- we'll use the more traditional (OG BF2 ) style path here and let the zero patch take care of
	-- re-directs for 'addon2' and '_lvl_common'
	local base_path = string.format("..\\..\\addon\\%s\\data\\_lvl_pc\\", zero_patch_data.override_path )
	print("base path check -> " .. base_path)
	local oldReadDataFile = ReadDataFile

	ReadDataFile = function(...)
		local testPath = base_path .. arg[1]
		if(ScriptCB_IsFileExist(testPath) == 1 ) then 
			arg[1] = testPath
			print("info: alternate default path re-direct> " .. arg[1])
		end
		return oldReadDataFile(unpack(arg))
	end
end