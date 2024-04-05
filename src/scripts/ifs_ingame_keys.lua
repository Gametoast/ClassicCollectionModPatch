-- begin comment
--[[
 SWBF2 2005 Lua script
 created by MileHighGuy from Gametoast.com

 to see the entry point of the code, search for "ifs_ingame_keys = NewIFShellScreen"

 Singleplayer only for now.
 if you want to make it work in multiplayer,
 you at least have to change the events
 which push the screen in addInGameKeyScreen
 it might be possible

 TO INSTALL

paste this at the top of your mission script (above the other DoFile calls)
your mission script is like ABCc_con.lua

--BEGIN COPY/PASTE

local IGK_originalDoFile = ScriptCB_DoFile
ScriptCB_DoFile = function(filename)

    if(filename == "ifs_pausemenu") then
        print("DEBUG: IGK: loading filename ifs_ingame_keys")
        IGK_originalDoFile("ifs_ingame_keys")

        IGK_addButtonToPauseMenu()

        print("DEBUG: IGK: loading filename " .. tostring(filename))
        IGK_originalDoFile(filename)
        ScriptCB_DoFile = IGK_originalDoFile
        return
    else
        print("DEBUG: IGK: loading filename " .. tostring(filename))
        IGK_originalDoFile(filename)
    end
end

--END COPY/PASTE

paste this in your mission ScriptInit() function,
after it loads the ReadDataFile("ingame.lvl")

addInGameKeyScreen()

 also add ifs_ingame_keys to the mission.req

that's all!

--]] -- end comment

print("DEBUG: added ingame screen")

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ingamekeys_Listbox_CreateItem(layout)

    local insidewidth = layout.width - 20;
    -- Make a coordinate system pegged to the top-left of where the cursor would go.
    local Temp = NewIFContainer {
        x = layout.x - 0.5 * insidewidth, 
        y = layout.y + 2,
        bInertPos = 1,
    }
    local FontHeight = ingamekeys_listbox_layout.fontheight
    Temp.showstr = NewIFText{
        x = 10, 
        y = FontHeight * -0.5, 
        textw = insidewidth, 
        texth = layout.height,
        halign = "left", valign = "vcenter",
        font = ingamekeys_listbox_layout.font,
        ColorR= 255, ColorG = 255, ColorB = 255,
        style = "normal",
        nocreatebackground=1,
        inert_all = 1,
    }
    return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ingamekeys_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
    if(Data) then
        -- Contents to show. Do so.
        if(gBlankListbox) then
            IFText_fnSetString(Dest.showstr,"") -- reduce glyphcache usage
        else
            IFText_fnSetString(Dest.showstr,Data.ShowStr)
        end

        IFObj_fnSetColor(Dest.showstr, iColorR, iColorG, iColorB)
        IFObj_fnSetAlpha(Dest.showstr, fAlpha)
    end

    IFObj_fnSetVis(Dest,Data) -- Show if there are contents
end

ingamekeys_listbox_layout = {
    -- Height is calculated from yHeight, Spacing, showcount.
    yHeight = 22,
    ySpacing  = 0,
    showcount = 9,
    font = gListboxItemFont,

    width =  900,--320,
    x = 0,
    slider = 1,
    CreateFn = ingamekeys_Listbox_CreateItem,
    PopulateFn = ingamekeys_Listbox_PopulateItem,
}

-- the actual contents of the listbox we
-- display in the corner of the screen during gameplay
gInGameDebugList = {
    [1] = { ShowStr = "first entry" },
    [2] = { ShowStr = "time " .. tostring(ScriptCB_GetMissionTime())}
}


-- just tell if an alphanumeric key was pressed
local function isKey(pressedKeyEnum, neededKeyName)

    local success, pressedKeyName = pcall(function()
        return string.char(pressedKeyEnum)
    end)
    -- will not succeed for SHIFT, CTRL, ALT
    if success then
        neededKeyName = string.upper(neededKeyName)
        pressedKeyName = string.upper(pressedKeyName)
        --print("DEBUG: pressed key " .. tostring(pressedKeyName)
        --.. " needed key " .. tostring(neededKeyName))

        return neededKeyName == pressedKeyName
    else
        -- will return false for non-alphanumeric keys
        return false
        --could do this, but too lazy
        --local bShift, bCtrl = ScriptCB_GetKeyboardPCFlags()
    end
end

-- this is the "Entry Point" of the code
-- The IF screen that will create the list box
ifs_ingame_keys = NewIFShellScreen {
    version = 1.0,
    nologo = 1,
    bAcceptIsSelect = 0,
    movieIntro = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed
    bDimBackdrop = nil,
    bNohelptext_backPC = 1,

    -- if we access this from pause menu
    fromPauseMenu = nil,
    --called when the screen starts
    Enter = function(this, bFwd)
        print("entered ingame key screen ============")
        --remove cursor
        ScriptCB_EnableCursor(nil)

        -- did we come from the pause menu?
        this.fromPauseMenu = ScriptCB_IsScreenInStack("ifs_pausemenu")

        print("DEBUG SCREEN: fromPauseMenu " .. tostring(this.fromPauseMenu))

        -- just an example, add a new entry every time we enter the screen
        table.insert(gInGameDebugList, { ShowStr = "test" })

        -- focus always at latest entry
        local numEntries = table.getn(gInGameDebugList)
        numEntries = numEntries or 1

        ingamekeys_listbox_layout.FirstShownIdx = numEntries
        ingamekeys_listbox_layout.SelectedIdx = numEntries
        ingamekeys_listbox_layout.CursorIdx = numEntries

        ListManager_fnFillContents(ifs_ingame_keys.listbox,gInGameDebugList, ingamekeys_listbox_layout)

    end,

    --called when the screen closes
    Exit = function(this, bFwd)
        print("exited ingame keys screen ===========")
        ScriptCB_EnableCursor(true)

        gBlankListbox = 1
        ListManager_fnFillContents(ifs_ingame_keys.listbox,gInGameDebugList, ingamekeys_listbox_layout)
        gBlankListbox = nil
    end,

    --called continuously, every tick
    Update = function(this, fDt)
        ScriptCB_EnableCursor(nil)

        --update the contents as they change
        gInGameDebugList[2].ShowStr = "time " .. tostring(ScriptCB_GetMissionTime())

        ListManager_fnFillContents(ifs_ingame_keys.listbox,gInGameDebugList, ingamekeys_listbox_layout)
    end,

    --Back button quits this screen
    Input_Back = function(this)
        --TODO this doesn't seem to trigger on PC
        -- might be fine on console
        print("pressed back")
        if this.fromPauseMenu then
            -- go back to pause menu
            ScriptCB_SndPlaySound("shell_menu_exit");
            ScriptCB_PopScreen()
        end
    end,

    Input_GeneralUp = function(this)
        if this.fromPauseMenu then
            ListManager_fnNavUp(this.listbox, gInGameDebugList, ingamekeys_listbox_layout)

        end
    end,
    Input_GeneralDown = function(this)
        if this.fromPauseMenu then
            ListManager_fnNavDown(this.listbox, gInGameDebugList, ingamekeys_listbox_layout)

        end
    end,

    Input_LTrigger = function(this)
        if this.fromPauseMenu then
            ListManager_fnPageUp(this.listbox, gInGameDebugList, ingamekeys_listbox_layout)
        end
    end,
    Input_RTrigger = function(this)
        if this.fromPauseMenu then
            ListManager_fnPageDown(this.listbox, gInGameDebugList, ingamekeys_listbox_layout)
        end
    end,

    -- use this in the event listeners (example below)
    AddToList = function(this, newString)

        if gInGameDebugList then

            table.insert(gInGameDebugList, { ShowStr = newString })

            -- move cursor to newest event
            local numEntries = table.getn(gInGameDebugList)
            numEntries = numEntries or 1

            ingamekeys_listbox_layout.FirstShownIdx = numEntries
            ingamekeys_listbox_layout.SelectedIdx = numEntries
            ingamekeys_listbox_layout.CursorIdx = numEntries

            --will be repainted in the Update function
        end

    end
}

-- read PC keyboard inputs
if gPlatformStr == "PC" then
    ifs_ingame_keys.Input_KeyDown = function(this, iKey)

        if not ifs_ingame_keys.fromPauseMenu then
            --from in-game

            if isKey(iKey, "i") then
                --scroll up
                ListManager_fnNavUp(ifs_ingame_keys.listbox, gInGameDebugList, ingamekeys_listbox_layout)
            elseif isKey(iKey, "k") then
                --scroll down
                ListManager_fnNavDown(ifs_ingame_keys.listbox, gInGameDebugList, ingamekeys_listbox_layout)
            end

        elseif ifs_ingame_keys.fromPauseMenu then
            -- from pause menu

            if iKey == 27 then
                --pressed ESC, exit the screen
                -- go back to pause menu
                ScriptCB_SndPlaySound("shell_menu_exit");
                ScriptCB_PopScreen()
            end
        end

        --can add code for a selecting one of the items if you want to
    end
end

function ifs_ingamekeys_fnBuildScreen(this)
    ingamekeys_listbox_layout.fontheight = ScriptCB_GetFontHeight(ingamekeys_listbox_layout.font)
    ingamekeys_listbox_layout.yHeight = ingamekeys_listbox_layout.fontheight

    this.listbox = NewButtonWindow {
        ZPos = 200, x = 0, y = 0,
        --ScreenRelativeX = 0.9, -- mostly right
        --ScreenRelativeY = 0.45, -- upper part

        ScreenRelativeX = 0.5, -- mostly left?
        ScreenRelativeY = 0.45, -- upper part?

        width = ingamekeys_listbox_layout.width + 35,
        height = ingamekeys_listbox_layout.showcount * (ingamekeys_listbox_layout.yHeight + ingamekeys_listbox_layout.ySpacing) + 30,
    }
    ListManager_fnInitList(this.listbox, ingamekeys_listbox_layout)
end

ifs_ingamekeys_fnBuildScreen(ifs_ingame_keys)

AddIFScreen(ifs_ingame_keys, "ifs_ingame_keys")


-- the function that you call after ingame.lvl is loaded
-- place any new event listeners in this function
-- add new items to gInGameDebugList
-- use ifs_ingame_keys:AddToList("New Item")
function addInGameKeyScreen()

    local screenTimer = CreateTimer("screenTimer")
    --SetTimerValue(screenTimer, 0.1)

    -- if I just tried to push the screen with OnCharacterSpawn, then it exits right away
    -- start it after a small timer it stays open
    local myTimerResponse = OnTimerElapse(
            function(timer)
                --print("pushing screen after timer ===============")
                --ifs_ingame_keys.fromPauseMenu = nil
                ScriptCB_PushScreen("ifs_ingame_keys")
            end,
            screenTimer
    )

    --start timer when player spawns, then calls the elapse function
    local charSpawn = OnCharacterSpawn(function(character)
        if IsCharacterHuman(character)
        then
            --print("player spawned =============")
            SetTimerValue(screenTimer, 0.1)
            StartTimer(screenTimer)
        end
    end)

    -- EXAMPLE
    -- add a string to the listbox every time player attacks something
    local onHumanDamage = OnObjectDamage(function(object, damager)

        if GetCharacterUnit(damager) and IsCharacterHuman(damager) then

            ifs_ingame_keys:AddToList("player attacked something")

        end
    end)

end

-- Add the debug log to the end of the pause menu
function IGK_addButtonToPauseMenu()

    local IGK_originalAddIFScreen = AddIFScreen
    AddIFScreen = function(screenTable, screenName)

        print("IGK: AddIFScreen " .. tostring(screenTable) .. " " .. tostring(screenName))

        if screenName == "ifs_pausemenu" then
            print("IGK: overriding pauseMenu")

            -- add new button without remaking the whole pause menu
            local newButton = { tag = "debugLog", string = "Debug Log", }
            table.insert(ifspausemenu_vbutton_layout.buttonlist, newButton)
            screenTable.CurButton = AddVerticalButtons(screenTable.buttons, ifspausemenu_vbutton_layout)
            local originalInputAccept = ifs_pausemenu_fnInput_Accept
            function ifs_pausemenu_fnInput_Accept(this)
                originalInputAccept(this)

                if this.CurButton == newButton.tag then

                    ifs_movietrans_PushScreen(ifs_ingame_keys)
                end
            end

            IGK_originalAddIFScreen(screenTable, screenName)
        else
            IGK_originalAddIFScreen(screenTable, screenName)
        end
    end

end