
-- first things game_interface does: 	
--  gPlatformStr = ScriptCB_GetPlatform()
--  gOnlineServiceStr = ScriptCB_GetConnectType()
--  gLangStr,gLangEnum = ScriptCB_GetLanguage()
--  ScriptCB_DoFile("globals") -- our 'patch' is called from here

-- last  thing game_interface does: 	ScriptCB_DoFile("ifs_mpgs_friends")

print("Patch ingame start")

if(printf == nil) then 
    function printf (...) print(string.format(unpack(arg))) end
end 

if( tprint == nil ) then 
    function getn(v)
        local v_type = type(v);
        if v_type == "table" then
            return table.getn(v);
        elseif v_type == "string" then
            return string.len(v);
        else
            return;
        end
    end

    function string.starts(str, Start)
        return string.sub(str, 1, getn(Start)) == Start;
    end

    function tprint(t, indent)
        if not indent then indent = 1, print(tostring(t) .. " {") end
        if t then
            for key,value in pairs(t) do
                if not string.starts(tostring(key), "__") then
                    local formatting = string.rep("    ", indent) .. tostring(key) .. "= ";
                    if value and type(value) == "table" then
                        print(formatting .. --[[tostring(value) ..]] " {")
                        tprint(value, indent+1);
                    else
                        if(type(value) == "string") then 
                            --print(formatting .."'" .. tostring(value) .."'" ..",")
                            printf("%s'%s',",formatting, tostring(value))
                        else 
                            print(formatting .. tostring(value) ..",")
                        end 
                    end
                end
            end
            print(string.rep("    ", indent - 1) .. "},")
        end
    end
end


-- this will get the Fake console & Free Cam buttons to show
gFinalBuild = false



print("gFinalBuild: " .. tostring(gFinalBuild))

ScriptCB_DoFile("utility_functions2")
--print("game_interface: Reading in custom strings")
--ReadDataFile("v1.3patch_strings.lvl") -- where to put, root of'0'?

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


-- only do the sound fix for the classic collection
-- remove this if Aspyr fixes addon functionality
if ScriptCB_IsFileExist("SIDE\\all1.lvl") == 1 then
    local function SetupAddonSoundFix()
        local checkFile = "addon2\\0\\patch_scripts\\soundFiles.lua"
        if(IsFileExist(checkFile) == 1 ) then
            addonSoundFiles = ""
            dofile(checkFile)
            -- the  addonSoundFiles string  should exist now
            local function splitStringByNewline(str)
                local t = {}
                local start = 1
                local splitStart, splitEnd = string.find(str, "\r?\n", start)
                while splitStart do
                    table.insert(t, string.sub(str, start, splitStart - 1))
                    start = splitEnd + 1
                    splitStart, splitEnd = string.find(str, "\r?\n", start)
                end
                table.insert(t, string.sub(str, start))
                return t
            end
            addonSoundFiles = string.gsub(addonSoundFiles, "/", "\\")
            local myList = splitStringByNewline(string.lower(addonSoundFiles))
    
            gAddonSoundFiles = { }
    
            for i, line in ipairs(myList) do
                local startPos, endPos = string.find(line, "addon2\\")
                if startPos then
                    -- Extract and print part of the line from "addon2\" to the end
                    local part = "..\\..\\" .. string.sub(line, startPos)
                    table.insert( gAddonSoundFiles, part)
                    print(part)
                end
            end
            addonSoundFiles = nil
        end
    end 
    SetupAddonSoundFix()
end


function uop_PatchFakeConsole()
    print("uop_PatchFakeConsole start")
    ifs_fakeconsole.Enter = function(this, bFwd)
        gConsoleCmdList = {}
        
        -- MUST do this after AddIFScreen! This is done here, and not in
        -- Enter to make the memory footprint more consistent.
        fakeconsole_listbox_layout.FirstShownIdx = 1
        fakeconsole_listbox_layout.SelectedIdx = 1
        fakeconsole_listbox_layout.CursorIdx = 1
        ScriptCB_SndPlaySound("shell_menu_enter")
        --ScriptCB_GetConsoleCmds() -- puts contents in gConsoleCmdList
        ff_rebuildFakeConsoleList()
    
        ListManager_fnFillContents(ifs_fakeconsole.listbox,gConsoleCmdList,fakeconsole_listbox_layout)
    end
    
    ifs_fakeconsole.Input_Accept = function(this)
        if(gMouseListBoxSlider) then
            ListManager_fnScrollbarClick(gMouseListBoxSlider)
            return
        end
        if(gMouseListBox) then
            ScriptCB_SndPlaySound("shell_select_change")
            gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
            ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
    --			return
        end
    
        if(this.CurButton == "_back") then -- Make PC work better - NM 8/5/04
            this:Input_Back()
            return
        end
    
        local Selection = gConsoleCmdList[fakeconsole_listbox_layout.SelectedIdx]
        ScriptCB_SndPlaySound("shell_menu_enter");
        
        local r2 = fakeconsole_listbox_layout.CursorIdx
        local r3 = fakeconsole_listbox_layout.FirstShownIdx
        local r4 = r2 - r3 
        r4 = r4 +1 
        
        IFObj_fnSetColor(this.listbox[r4].showstr, 255,0,255)
        if ( Selection.run ) then 
            print("ifs_fakeconsole: Is runnable:", Selection.ShowStr, Selection.run)
            ff_serverDidFCCmd()
            Selection.run()
            IFObj_fnSetColor(this.listbox[r4].showstr,0,255,255)
        else 
            ScriptCB_DoConsoleCmd(Selection.ShowStr)
        end 
        --ScriptCB_PopScreen()
    end
    
    ifs_fakeconsole.Input_KeyDown = function( this, iKey ) 
        if (iKey  == 27 ) then  -- handle Escape 
            --this:Input_Back() -- soft locks BF CC
        end 
        --[[
            Keys that are handled in the ifs scripts:
            8: Backspace 
            9:  Tab 
            10: Newline 
            13: Carriage Return 
            27: Esc 
            32: Space 
            43: * 
            44: , 
            45: - 
            61: = 
            95: _ (underscore) 
            -59: F1 
            -211: Delete 
        ]]--
    end
    
    ifs_fakeconsole.Update = function(this, fDt ) 
        -- Yes; I'm aware this code looks really ugly.
        -- But it is functionally the same as the luac -l listing 
        --  -cbadal 
        local r2 = gConsoleCmdList
        local r3 = fakeconsole_listbox_layout.SelectedIdx
        r2 = r2[r3]
        if ( not  r2 ) then 
            return 
        end 
        r3 = this.lastDescribedCommand
        if ( r3 == fakeconsole_listbox_layout.SelectedIdx ) then 
            return 
        end 
        r3 = fakeconsole_listbox_layout
        r3 = r3.SelectedIdx
        this.lastDescribedCommand = r3 
        r3 = r2.ShowStr 
        if ( r3 == "" ) then 
            r2.info = "" 
        end 
        r3 = r2.info 
        if ( not r3  ) then 
            r3 = "Note: No known description"
        end 
        
        IFText_fnSetString(this.description,r3, this.description.case) 
    end
    print("uop_PatchFakeConsole end")
end

-- sets up 'ifs_ingame_keys'
function SetupIngamelog()
    print("SetupIngamelog")
    ScriptCB_DoFile("ifs_ingame_keys")
    local oldPrint = print 
    print = function(...)
        if( ifs_ingame_keys ~= nil) then 
            ifs_ingame_keys:AddToList(arg[1])
        end
        oldPrint(unpack(arg))
    end
end

local function SetupAddIfScreenCatching()
    --[[
    for patching ifs_ menu screens, we'll want to 'Catch' when they are passed to 'AddIfScreen'.
    We can manipulate/adjust the screen structure at that time. Adding buttons, adjusting location...
    But after 'AddIfScreen' is called, messing with the screen will make it look all janky or
    it won't work at all.

    For replacing a screen we can override 'ScriptCB_PushScreen' and/or 'ScriptCB_SetIFScreen'.
    'ScriptCB_SetIFScreen' is used infrequently though.
    ]]
    print("Setup 'catch' point for ifs_fakeconsole")

    local old_AddIFScreen = AddIFScreen
    AddIFScreen = function(...)
        print("AddIFScreen: " .. arg[2])
        if( arg[2] == "ifs_fakeconsole") then 
            uop_PatchFakeConsole()
        elseif arg[2] == "ifs_pausemenu" then
            SetupIngamelog()
            print("IGK: adding debug log button to pauseMenu")

            -- add new button without remaking the whole pause menu
            local newButton = { tag = "debugLog", string = "Debug Log", }
            local index = table.getn(ifspausemenu_vbutton_layout.buttonlist) -1
            table.insert(ifspausemenu_vbutton_layout.buttonlist, index, newButton)
            arg[1].CurButton = AddVerticalButtons(arg[1].buttons, ifspausemenu_vbutton_layout)
            local originalInputAccept = ifs_pausemenu_fnInput_Accept
            function ifs_pausemenu_fnInput_Accept(this)
                originalInputAccept(this)
                if this.CurButton == newButton.tag then
                    ifs_movietrans_PushScreen(ifs_ingame_keys)
                end
            end
        end
        return old_AddIFScreen(unpack(arg))
    end
end

local function uop_do_files()
    ScriptCB_DoFile("fakeconsole_functions")
    ScriptCB_DoFile("popup_prompt")
end 

local old_ScriptCB_DoFile = ScriptCB_DoFile
ScriptCB_DoFile = function(...)
    print("ScriptCB_DoFile: " .. arg[1])
    if(arg[1] == "ifs_pausemenu") then 
        uop_do_files() -- do these before pause menu
    elseif(arg[1] == "ifs_opt_top")then
        SetupAddIfScreenCatching()
    end
    return old_ScriptCB_DoFile(unpack(arg))
end 


-- look through all possible 3-letter mod folders for a core.lvl file
-- remove this if Aspyr fixes addon functionality
function LoadModStrings()
    local chars = "0123456789abcdefghijklmnopqrstuvwxyz"
    local checkFile = ""
    local abb = ""
    local length = string.len(chars)
    print("looking for more strings...")
    for i = 1, length do
        for j = 1, length do
            for k = 1, length do
                abb = string.sub(chars, i, i) .. string.sub(chars, j, j) .. string.sub(chars, k, k)
                checkFile = string.format( "..\\..\\addon\\%s\\data\\_lvl_pc\\core.lvl",abb)
                if(ScriptCB_IsFileExist(checkFile) == 1) then 
                    print("ReadDataFile('" .. checkFile .. "')")
                    ReadDataFile(checkFile)
                end
            end
        end
    end
    

end
LoadModStrings()
