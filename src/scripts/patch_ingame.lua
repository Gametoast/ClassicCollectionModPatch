
-- first things game_interface does: 	
--  gPlatformStr = ScriptCB_GetPlatform()
--  gOnlineServiceStr = ScriptCB_GetConnectType()
--  gLangStr,gLangEnum = ScriptCB_GetLanguage()
--  ScriptCB_DoFile("globals") -- our 'patch' is called from here

-- last  thing game_interface does: 	ScriptCB_DoFile("ifs_mpgs_friends")

print("Patch ingame start")

-- this will get the Fake console & Free Cam buttons to show
gFinalBuild = false

print("gFinalBuild: " .. tostring(gFinalBuild))

function RunUserScripts()
    local maxScripts = 100
    local i = nil
    local patchDir = "..\\..\\addon\\0\\"
    print("RunUserScripts() Start")
    for i = 0, maxScripts, 1 do
        
        if ScriptCB_IsFileExist(patchDir .. "user_script_" .. i .. ".lvl") ~= 0 then
            print("game_interface: Found user_script_" .. i .. ".lvl")
            
            ReadDataFile(patchDir .. "user_script_" .. i .. ".lvl")
            ScriptCB_DoFile("user_script_" .. i)
        end
        
    end
    print("RunUserScripts() End")
end
RunUserScripts()

ingame_messages = {}
function AddIngameMessage(str)
    table.insert( ingame_messages, str)
end

local old_print = print 
print = function(...)
    AddIngameMessage(arg[1])
    return old_print(unpack(arg))
end


--[[
  for patching ifs_ menu screens, we'll want to 'Catch' when they are passed to 'AddIfScreen'.
  We can manipulate/adjust the screen structure at that time. Adding buttons, adjusting location...
  But after 'AddIfScreen' is called, messing with the screen will make it look all janky or
  it won't work at all.

  For replacing a screen we can override 'ScriptCB_PushScreen' and/or 'ScriptCB_SetIFScreen'.
  'ScriptCB_SetIFScreen' is used infrequently though.
]]
--local old_AddIFScreen = AddIFScreen
--AddIFScreen = function(...)
--    print("AddIFScreen: " .. arg[2])
--    if( arg[1] == "target+screen") then 
--    end
--    return old_AddIFScreen(unpack(arg))
--end
