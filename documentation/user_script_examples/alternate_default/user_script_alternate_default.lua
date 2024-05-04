-- user_script_alternate_default.lua 
-- place the files you'd like to use as  'alternate' default files under this folder.
-- author: BAD-AL 

-- Attempts to override the base game path.
-- Will check to see if there exists a file at the override file path location and if so, will read that file instead.
print("info: setup alternate default path from addon folder.")

-- we'll use the more traditional (OG BF2 ) style path here and let the zero patch take care of
-- re-directs for 'addon2' and '_lvl_common'
local base_path = "..\\..\\addon\\alternate_default\\data\\_lvl_pc\\"
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


local oldOpenAudioStream = OpenAudioStream
OpenAudioStream = function(...)
	local testPath = base_path .. arg[1]
	if(ScriptCB_IsFileExist(testPath) == 1 ) then 
		arg[1] = testPath
		print("info: alternate default path re-direct> " .. arg[1])
	end
	return oldOpenAudioStream(unpack(arg))
end

local oldAudioStreamAppendSegments = AudioStreamAppendSegments
AudioStreamAppendSegments = function(...)
	local testPath = base_path .. arg[1]
	if(ScriptCB_IsFileExist(testPath) == 1 ) then 
		arg[1] = testPath
		print("info: alternate default path re-direct> " .. arg[1])
	end
	return oldAudioStreamAppendSegments(unpack(arg))
end
