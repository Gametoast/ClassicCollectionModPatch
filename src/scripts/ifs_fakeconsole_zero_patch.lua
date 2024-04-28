-- ifs_fakeconsole.lua (zerted  PC v1.3 r129 patch )
-- verified decompile by cbadal
--
--  'ff_rebuildFakeConsoleList()' is defined in fakeconsole_functions.lua
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- AnthonyBF2, added to PC HAX on 02-03-2021

-- Multiplayer game name screen.

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function Fakeconsole_Listbox_CreateItem(layout)
    local insidewidth = layout.width - 20
    -- Make a coordinate system pegged to the top-left of where the cursor would go.
    local Temp =
        NewIFContainer {
        x = layout.x - 0.5 * insidewidth,
        y = layout.y + 2,
        bInertPos = 1,
        bHotspot = true,
		fHotspotH = layout.height,
		fHotspotW = layout.width,
    }
    local FontHeight = fakeconsole_listbox_layout.fontheight
    Temp.showstr =
        NewIFText {
        x = 10,
        y = FontHeight * -0.5,
        textw = insidewidth,
        texth = layout.height, -- layout.height
        halign = "left",
        valign = "vcenter",
        font = fakeconsole_listbox_layout.font,
        ColorR = 255,
        ColorG = 255,
        ColorB = 255,
        style = "normal",
        nocreatebackground = 1,
        inert_all = 1
    }
    Temp.run = nil
    Temp.info = nil

    return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function Fakeconsole_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
    if (Data) then
        -- Contents to show. Do so.
        if (gBlankListbox) then
            IFText_fnSetString(Dest.showstr, "") -- reduce glyphcache usage
        else
            IFText_fnSetString(Dest.showstr, Data.ShowStr)
        end

        IFObj_fnSetColor(Dest.showstr, iColorR, iColorG, iColorB)
        IFObj_fnSetAlpha(Dest.showstr, fAlpha)
    end

    IFObj_fnSetVis(Dest, Data) -- Show if there are contents
end

-- AnthonyBF2, 08-31-2020
-- Aspyr's new game doesn't seem to respect our per resolution script so we have no choice but to have one fixed window size
-- Cut per resolution script 3/17/2024
-- local screenWidth, screenHeight = ScriptCB_GetSafeScreenInfo --ScriptCB_GetScreenInfo()
-- -- begin 4x3 resolutions
-- if screenWidth == 640 and screenHeight == 480 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 25, -- 13
        -- font = "gamefont_small",
        -- width = 315, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 800 and screenHeight == 600 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 31, -- 13
        -- font = "gamefont_small",
        -- width = 350, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 960 and screenHeight == 720 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 38, -- 13
        -- font = "gamefont_small",
        -- width = 400, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1024 and screenHeight == 768 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 41, -- 13
        -- font = "gamefont_small",
        -- width = 475, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1280 and screenHeight == 960 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 51, -- 13
        -- font = "gamefont_small",
        -- width = 600, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1400 and screenHeight == 1050 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 57, -- 13
        -- font = "gamefont_small",
        -- width = 700, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1440 and screenHeight == 1080 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 58, -- 13
        -- font = "gamefont_small",
        -- width = 700, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1600 and screenHeight == 1200 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 65, -- 13
        -- font = "gamefont_small",
        -- width = 800, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1856 and screenHeight == 1392 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 76, -- 13
        -- font = "gamefont_small",
        -- width = 925, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1920 and screenHeight == 1440 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 80, -- 13
        -- font = "gamefont_small",
        -- width = 990, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 2048 and screenHeight == 1536 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 85, -- 13
        -- font = "gamefont_small",
        -- width = 1000, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 2560 and screenHeight == 1920 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 107, -- 13
        -- font = "gamefont_small",
        -- width = 1300, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 2880 and screenHeight == 2160 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 120, -- 13
        -- font = "gamefont_small",
        -- width = 1500, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- -- end 4x3 resolutions
-- -- begin 16x9 resolutions
-- elseif screenWidth == 960 and screenHeight == 540 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 28, -- 13
        -- font = "gamefont_small",
        -- width = 480, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1024 and screenHeight == 576 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 30, -- 13
        -- font = "gamefont_small",
        -- width = 500, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1152 and screenHeight == 648 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 34, -- 13
        -- font = "gamefont_small",
        -- width = 550, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1280 and screenHeight == 720 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 38, -- 13
        -- font = "gamefont_small",
        -- width = 640, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1366 and screenHeight == 768 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 40, -- 13
        -- font = "gamefont_small",
        -- width = 690, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1600 and screenHeight == 900 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 48, -- 13
        -- font = "gamefont_small",
        -- width = 825, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1920 and screenHeight == 1080 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 59, -- 13
        -- font = "gamefont_small",
        -- width = 975, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 2048 and screenHeight == 1152 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 62, -- 13
        -- font = "gamefont_small",
        -- width = 1050, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 2560 and screenHeight == 1440 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 78, -- 13
        -- font = "gamefont_small",
        -- width = 1350, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 3200 and screenHeight == 1800 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 100, -- 13
        -- font = "gamefont_small",
        -- width = 1725, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- -- begin 4K
-- elseif screenWidth == 3840 and screenHeight == 2160 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 500, -- 22
        -- ySpacing = 0,
        -- showcount = 120, -- 13
        -- font = "gamefont_small",
        -- width = 2050, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- -- end 16x9 resolutions
-- -- begin 16x10 resolutions
-- elseif screenWidth == 640 and screenHeight == 400 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 500, -- 22
        -- ySpacing = 0,
        -- showcount = 20, -- 13
        -- font = "gamefont_small",
        -- width = 310, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 960 and screenHeight == 600 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 500, -- 22
        -- ySpacing = 0,
        -- showcount = 31, -- 13
        -- font = "gamefont_small",
        -- width = 475, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1280 and screenHeight == 800 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 500, -- 22
        -- ySpacing = 0,
        -- showcount = 42, -- 13
        -- font = "gamefont_small",
        -- width = 630, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1440 and screenHeight == 900 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 500, -- 22
        -- ySpacing = 0,
        -- showcount = 48, -- 13
        -- font = "gamefont_small",
        -- width = 745, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1680 and screenHeight == 1050 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 500, -- 22
        -- ySpacing = 0,
        -- showcount = 55, -- 13
        -- font = "gamefont_small",
        -- width = 875, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 1920 and screenHeight == 1200 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 500, -- 22
        -- ySpacing = 0,
        -- showcount = 65, -- 13
        -- font = "gamefont_small",
        -- width = 1000, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- elseif screenWidth == 2560 and screenHeight == 1600 then
    -- fakeconsole_listbox_layout = {
        -- yHeight = 500, -- 22
        -- ySpacing = 0,
        -- showcount = 87, -- 13
        -- font = "gamefont_small",
        -- width = 1340, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- -- end 16x10 resolutions
-- -- unknown res, use 800x600
-- else
    -- fakeconsole_listbox_layout = {
        -- yHeight = 300, -- 22
        -- ySpacing = 0,
        -- showcount = 31, -- 13
        -- font = "gamefont_small",
        -- width = 400, -- 208
        -- x = 0,
        -- slider = 1,
        -- CreateFn = Fakeconsole_Listbox_CreateItem,
        -- PopulateFn = Fakeconsole_Listbox_PopulateItem
    -- }
-- end
fakeconsole_listbox_layout = {
    bCreateSlider = true,
    yHeight = 330, -- 22
    ySpacing  = 0,
    showcount = 22, -- 13
    font = "gamefont_small",
    width = 400, -- 208
    x = 0,
    slider = 1,
    CreateFn = Fakeconsole_Listbox_CreateItem,
    PopulateFn = Fakeconsole_Listbox_PopulateItem,
}

gConsoleCmdList = {}

ifs_fakeconsole =
    NewIFShellScreen {
    nologo = 1,
    bNohelptext_backPC = 1,
    bDimBackdrop = 1,
    Enter = function(this, bFwd)
        gConsoleCmdList = {}

        -- MUST do this after AddIFScreen! This is done here, and not in
        -- Enter to make the memory footprint more consistent.
        fakeconsole_listbox_layout.FirstShownIdx = 1
        fakeconsole_listbox_layout.SelectedIdx = 1
        fakeconsole_listbox_layout.CursorIdx = 1
        ScriptCB_SndPlaySound("shell_menu_enter")
        --ScriptCB_GetConsoleCmds() -- puts contents in gConsoleCmdList
        ff_rebuildFakeConsoleList()

        ListManager_fnFillContents(ifs_fakeconsole.listbox, gConsoleCmdList, fakeconsole_listbox_layout)
    end,
    Exit = function(this, bFwd)
        gBlankListbox = 1
        ListManager_fnFillContents(ifs_fakeconsole.listbox, gConsoleCmdList, fakeconsole_listbox_layout)
        gBlankListbox = nil
    end,
    -- Accept button bumps the page
    Input_Accept = function(this)
        if (gMouseListBoxSlider) then
            ListManager_fnScrollbarClick(gMouseListBoxSlider)
            return
        end
        if (gMouseListBox) then
            ScriptCB_SndPlaySound("shell_select_change")
            gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
            ListManager_fnFillContents(gMouseListBox, gMouseListBox.Contents, gMouseListBox.Layout)
        --			return
        end

        if (this.CurButton == "_back") then -- Make PC work better - NM 8/5/04
            this:Input_Back()
				-- AnthonyBF2 3/17/2024
				-- Asypr's game doesn't know how to unpause from console so we have to hand hold it
			ScriptCB_PopScreen()
			ScriptCB_Unpause()
            return
        end

        local Selection = gConsoleCmdList[fakeconsole_listbox_layout.SelectedIdx]
        ScriptCB_SndPlaySound("shell_menu_enter")

        local r2 = fakeconsole_listbox_layout.CursorIdx
        local r3 = fakeconsole_listbox_layout.FirstShownIdx
        local r4 = r2 - r3
        r4 = r4 + 1

        IFObj_fnSetColor(this.listbox[r4].showstr, 255, 0, 255)
        if (Selection.run) then
            print("ifs_fakeconsole: Is runnable:", Selection.ShowStr, Selection.run)
            ff_serverDidFCCmd()
            Selection.run()
            IFObj_fnSetColor(this.listbox[r4].showstr, 0, 255, 255)
        else
            ScriptCB_DoConsoleCmd(Selection.ShowStr)
        end
        --ScriptCB_PopScreen()
    end,
    Input_KeyDown = function(this, iKey)
        if (iKey == 27) then -- handle Escape
            if(ScriptCB_CheckProfanity == nil) then
                -- do not do this for Aspyr's game version
                this:Input_Back()
            end
				-- AnthonyBF2 3/17/2024
				-- Asypr's game doesn't know how to unpause from console so we have to hand hold it
			--ScriptCB_PopScreen()
			--ScriptCB_Unpause()
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
		]]
     --
    end,
    Update = function(this, fDt)
        -- Yes; I'm aware this code looks really ugly.
        -- But it is functionally the same as the luac -l listing
        --  -cbadal
        local r2 = gConsoleCmdList
        local r3 = fakeconsole_listbox_layout.SelectedIdx
        r2 = r2[r3]
        if (not r2) then
            return
        end
        r3 = this.lastDescribedCommand
        if (r3 == fakeconsole_listbox_layout.SelectedIdx) then
            return
        end
        r3 = fakeconsole_listbox_layout
        r3 = r3.SelectedIdx
        this.lastDescribedCommand = r3
        r3 = r2.ShowStr
        if (r3 == "") then
            r2.info = ""
        end
        r3 = r2.info
        if (not r3) then
            r3 = "Navigate console with arrow keys. Enter to run highlighted command. Esc to unpause."
        end

        IFText_fnSetString(this.description, r3, this.description.case)
    end,
    --Back button quits this screen
    Input_Back = function(this)
        ScriptCB_SndPlaySound("shell_menu_exit")
        ScriptCB_PopScreen()
				-- AnthonyBF2 3/17/2024
				-- Asypr's game doesn't know how to unpause from console so we have to hand hold it
			--ScriptCB_PopScreen()
		ScriptCB_Unpause()
    end,
    Input_GeneralUp = function(this)
        ListManager_fnNavUp(this.listbox, gConsoleCmdList, fakeconsole_listbox_layout)
    end,
    Input_GeneralDown = function(this)
        ListManager_fnNavDown(this.listbox, gConsoleCmdList, fakeconsole_listbox_layout)
    end,
    Input_LTrigger = function(this)
        ListManager_fnPageUp(this.listbox, gConsoleCmdList, fakeconsole_listbox_layout)
    end,
    Input_RTrigger = function(this)
        ListManager_fnPageDown(this.listbox, gConsoleCmdList, fakeconsole_listbox_layout)
    end,
    -- No L/R functionality possible on this screen (gotta have stubs
    -- here, or the base class will override)
    Input_GeneralLeft = function(this)
    end,
    Input_GeneralRight = function(this)
    end
}

function ifs_fakeconsole_fnBuildScreen(this)
    fakeconsole_listbox_layout.fontheight = ScriptCB_GetFontHeight(fakeconsole_listbox_layout.font)
    fakeconsole_listbox_layout.yHeight = fakeconsole_listbox_layout.fontheight

    this.listbox =
        NewButtonWindow {
        ZPos = 200,
        x = 0,
        y = 0,
        ScreenRelativeY = 0.5, -- center
        ScreenRelativeX = 0.275, -- middle of screen
        width = fakeconsole_listbox_layout.width + 35,
        height = fakeconsole_listbox_layout.showcount *
            (fakeconsole_listbox_layout.yHeight + fakeconsole_listbox_layout.ySpacing) + 30 -- 30
    }
    this.description =
        NewIFText {
        ZPos = 200,
        x = 0,
        y = 0,
        halign = "left",
        font = "gamefont_small",
        nocreatebackground = 1,
        ScreenRelativeY = 0.375, -- up and down location for the fake console description
        ScreenRelativeX = 0.585, -- side to side location for the fake console description
        width = 1000, --(this.listbox.width * 2 / 3) - 2,
        height = 500, --this.listbox.height,
		-- size of the description box
        textw = 250, --this.listbox.width * 2 / 3 - 2,
        texth =  300, --this.listbox.height,
        ColorR = 255,
        ColorG = 255,
        ColorB = 255,
        string = ""
    }
    ListManager_fnInitList(this.listbox, fakeconsole_listbox_layout)
end

-- Set up listbox

ifs_fakeconsole_fnBuildScreen(ifs_fakeconsole)
ifs_fakeconsole_fnBuildScreen = nil

AddIFScreen(ifs_fakeconsole, "ifs_fakeconsole")
ifs_fakeconsole = DoPostDelete(ifs_fakeconsole)
