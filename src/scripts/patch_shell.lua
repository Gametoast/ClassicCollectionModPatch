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

-- if there are any user scripts saved
-- save them to mission setup table
-- then during game time, it will load them (in patch_ingame.lua)
if gUserScripts and table.getn(gUserScripts) > 0 then

    if ScriptCB_IsMissionSetupSaved() then
        local missionSetup = ScriptCB_LoadMissionSetup()
        missionSetup.userScripts = gUserScripts
        ScriptCB_SaveMissionSetup(missionSetup)
    else
        local missionSetup = {
            userScripts = gUserScripts
        }
        ScriptCB_SaveMissionSetup(missionSetup)
    end
end



print("patch_shell end")