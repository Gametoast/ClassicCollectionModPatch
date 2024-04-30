

if( zero_patch_data ~= nil and zero_patch_data.override_path ~= nil) then 
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