function RunUserScripts()
    local maxScripts = 100
    local i = nil
    
    for i = 0, maxScripts, 1 do
        
        if ScriptCB_IsFileExist(patchDir .. "user_script_" .. i .. ".lvl") == 0 then
            print("game_interface: No user_script_" .. i .. ".lvl")
        else
            print("game_interface: Found user_script_" .. i .. ".lvl")
            
            ReadDataFile(patchDir .. "user_script_" .. i .. ".lvl")
            ScriptCB_DoFile("user_script_" .. i)
        end
        
    end
end
RunUserScripts()

--[[
  for patching ifs_ menu screens, we'll want to 'Catch' when they are passed to 'AddIfScreen'.
  We can manipulate/adjust the screen structure at that time. Adding buttons, adjusting location...
  But after 'AddIfScreen' is called, messing with the screen will make it look all janky or
  it won't work at all.

  For replacing a screen we can override 'ScriptCB_PushScreen' and/or 'ScriptCB_SetIFScreen'.
  'ScriptCB_SetIFScreen' is used infrequently though.
]]