
-- first things game_interface does:
--  gPlatformStr = ScriptCB_GetPlatform()
--  gOnlineServiceStr = ScriptCB_GetConnectType()
--  gLangStr,gLangEnum = ScriptCB_GetLanguage()
--  ScriptCB_DoFile("globals") -- our 'patch' is called from here

-- last  thing game_interface does: 	ScriptCB_DoFile("ifs_mpgs_friends")

print("Patch ingame start")

-- added 'ingame_messages' table to keep track of errors befroe we re-direct 'print'
local ingame_messages ={}
local function addIngameMessage(str)
    table.insert(ingame_messages, str)
end

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


if IsFileExist == nil then
	print("patch_ingame: defining IsFileExist")
	IsFileExist = function(path)
		local testPath = "..\\..\\".. path
		return ScriptCB_IsFileExist(testPath)
	end
end

-- this will get the Fake console & Free Cam buttons to show
gFinalBuild = false

print("gFinalBuild: " .. tostring(gFinalBuild))

local function load_fs()
    ScriptCB_DoFile("zero_patch_fs")
end

local status, err = pcall(load_fs)
if not status then
    local msg = "Caught an error in load_fs: " .. err
    addIngameMessage(msg)
    print(msg)
else
    -- Successful execution
end

ScriptCB_DoFile("utility_functions2")

if(ScriptCB_IsFileExist("..\\..\\addon\\0\\patch_scripts\\v1.3patch_strings.lvl") == 1) then
    print("info: read in old 1.3 patch strings")
    ReadDataFile("..\\..\\addon\\0\\patch_scripts\\v1.3patch_strings.lvl")
end

-- trim "path\\to\\file.lvl" to "file"
function trimToFileName(filePath)
    -- Find the last directory separator
    local nameStart = 1
    local sepStart, sepEnd = string.find(filePath, "[/\\]", nameStart)
    while sepStart do
        nameStart = sepEnd + 1
        sepStart, sepEnd = string.find(filePath, "[/\\]", nameStart)
    end

    -- Extract the file name part
    local fileName = string.sub(filePath, nameStart)

    -- Attempt to remove the extension
    local dotPosition = string.find(fileName, ".[^.]*$")
    if dotPosition then
        fileName = string.sub(fileName, 1, dotPosition - 1)
    end

    return fileName
end

function Run_uop_UserScripts()
    local scriptName = ""
    local files = zero_patch_fs.getFiles("user_script_", {".lvl", ".script"})

    for i, value in ipairs(files) do
        if( ScriptCB_IsFileExist(value) == 1) then
            addIngameMessage("info: running " .. value)
            ReadDataFile(value)
            scriptName = trimToFileName(value)
            ScriptCB_DoFile(scriptName)
        end
    end
    print("Run_uop_UserScripts() End")
end
Run_uop_UserScripts()

-- filter debug messages to messages with 'info:', 'error' or 'warn' in them.
-- TODO: consider providing an override option where everything goes into the debug log? (when 'addon/0/debug.txt' exists?)
function zero_patch_is_worthy_for_debug(str)
    local test = string.lower(str)
    if (string.find(test, 'error') or string.find(test, 'warn') or string.find(test, 'info:') or
        string.find(test, 'debug')) then
        return true
    end
    return false
end

-- sets up 'ifs_ingame_log'
function SetupIngamelog()
    print("SetupIngamelog")
    ScriptCB_DoFile("ifs_ingame_log")
    local oldPrint = print
    print = function(...)
        if( ifs_ingame_log ~= nil and zero_patch_is_worthy_for_debug(arg[1])) then
            ifs_ingame_log:AddToList(arg[1])
        end
        oldPrint(unpack(arg))
    end

    if(ingame_messages~= nil and table.getn(ingame_messages) > 0) then
        for i, err in ipairs(ingame_messages) do
            print(err)
        end
        ingame_messages = nil
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
        if arg[2] == "ifs_pausemenu" then
            SetupIngamelog()
            print("IGK: adding debug log button to pauseMenu")
            print("Platform: ".. tostring( ScriptCB_GetPlatform() ))
            print("zero_patch patch_ingame gMissionName= ".. tostring(gMissionName))

            -- add new button without remaking the whole pause menu
            local newButton = { tag = "debugLog", string = "Debug Log", }
            local index = table.getn(ifspausemenu_vbutton_layout.buttonlist) -1
            table.insert(ifspausemenu_vbutton_layout.buttonlist, index, newButton)
            arg[1].CurButton = AddVerticalButtons(arg[1].buttons, ifspausemenu_vbutton_layout)
            local originalInputAccept = ifs_pausemenu_fnInput_Accept
            function ifs_pausemenu_fnInput_Accept(this)
                originalInputAccept(this)
                if this.CurButton == newButton.tag then
                    ifs_movietrans_PushScreen(ifs_ingame_log)
                end
            end
            -- not sure why, but the code below that hides the fakecamera button is crashing the steamdeck.
            -- disabling that for now.
            --print("info: GAME_VERSION: ".. GAME_VERSION)
            --if(GAME_VERSION == "SWBF2_CC") then
            --    -- Freecam is no-worky on BF CC; but don't hide it for 'OG' BF2
            --    local old_ifs_pausemenu_fnEnter = ifs_pausemenu_fnEnter
            --    ifs_pausemenu_fnEnter = function(this, bFwd, iInstance)
            --        old_ifs_pausemenu_fnEnter(this, bFwd, iInstance)
            --        this.buttons.freecam.hidden = true
            --        this.CurButton = ShowHideVerticalButtons(this.buttons, ifspausemenu_vbutton_layout)
            --        SetCurButton(this.CurButton, this)
            --    end
            --end
    
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
    elseif(arg[1] == "ifs_fakeconsole")then
        arg[1] = "ifs_fakeconsole_zero_patch"
    elseif(arg[1] == "ifs_opt_top")then
        SetupAddIfScreenCatching()
    end
    return old_ScriptCB_DoFile(unpack(arg))
end
