print("patch_shell start")


--[[
  for patching ifs_ shell menu screens, we'll want to 'Catch' when they are passed to 'AddIfScreen'.
  We can manipulate/adjust the screen structure at that time. Adding buttons, adjusting location...
  But after 'AddIfScreen' is called, messing with the screen will make it look all janky or
  it won't work at all.

  
  For replacing a screen we can override 'ScriptCB_PushScreen' and/or 'ScriptCB_SetIFScreen'.
  'ScriptCB_SetIFScreen' is used infrequently though.
  (Prefer to do this in the '0' addme though)
]]

if IsFileExist == nil then 
	print("patch_shell: defining IsFileExist")
	IsFileExist = function(path)
		local testPath = "..\\..\\".. path
		return ScriptCB_IsFileExist(testPath)
	end
end

ScriptCB_DoFile("zero_patch_fs")
print("patch_shell end")