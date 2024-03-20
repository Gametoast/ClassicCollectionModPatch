
-- BAD_AL
-- ifs_mod_menu_launcher

if( ifs_mod_menu_launcher == nil ) then 
	print("running ifs_mod_menu_launcher")
	
	-- Helper function. Given a layout (x,y,width, height), returns a
	-- fully-built item.
	function ifs_mod_menu_launcher_listbox_CreateItem(layout)
		-- Make a coordinate system pegged to the top-left of where the cursor would go.
		local Temp = NewIFContainer { 
			x = layout.x - 0.5 * layout.width, y=layout.y - 10
		}

		Temp.NameStr = NewIFText{ 
			x = 10, y = 0, halign = "left", 
			font = ifs_mod_menu_launcher_listbox_layout.Font, 
			--textw = 220, 
			textw = ifs_mod_menu_launcher_listbox_layout.width - 20,
			nocreatebackground = 1, startdelay=math.random()*0.5, 
		}
		return Temp
	end

	-- Helper function. For a destination item (previously created w/
	-- CreateItem), fills it in with data, which may be nil (==blank it)
	function ifs_mod_menu_launcher_listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
		
		if(Data) then
			--print("ifs_mod_menu_launcher_listbox_PopulateItem Data:"); tprint(Data)
			-- Show this entry
			--IFText_fnSetUString(Dest.NameStr,Data.showstr)
			IFText_fnSetString(Dest.NameStr,Data.showstr)

			IFObj_fnSetColor(Dest.NameStr, iColorR, iColorG, iColorB)
			IFObj_fnSetAlpha(Dest.NameStr, fAlpha)
		else
			--print("ifs_mod_menu_launcher_listbox_PopulateItem empty item")
			-- Blank this entry
			IFText_fnSetString(Dest.NameStr,"")
		end

		IFObj_fnSetVis(Dest.NameStr, Data)
	end


	local ifs_mod_menu_launcher_listbox_contents = {
		--{id="fontTest", showstr= "Font Test", action="ifs_fonttest"},
		--{id="campaignList", showstr = "ifs.sp.campaign", action="ifs_sp_briefing"},
	}

	ifs_mod_menu_launcher_listbox_layout = {
		showcount = 8,
		yHeight = 34,
		ySpacing  = 0,
		--width = 260,
		width = 400,
	--	x = 0,
		slider = 1,
		CreateFn = ifs_mod_menu_launcher_listbox_CreateItem,
		PopulateFn = ifs_mod_menu_launcher_listbox_PopulateItem,
		Font = gListboxItemFont,
		fNumberWidth = 40, -- width, in pixels, for the XBox's file #
	}

	--function AddModMenuItem({"ID", "display string", "name" })
	-- string -> launch a screen named 'name'; function -> call the function name(id); table -> push ui and show it
	function AddModMenuItem(id, display_string, name )
		print(string.format("AddModMenuItem: Adding item { %s  %s  %s }", id, display_string, tostring(name)))
		local newItem = {id=  id, showstr=  display_string, action= name }
		table.insert( ifs_mod_menu_launcher_listbox_contents, newItem )
	end


	-- Sets the hilight on the listbox, create button given a hilight
	function ifs_mod_menu_launcher_SetHilight(this,aListIndex)
		if(gNoNewProfiles or aListIndex) then
			-- Deactivate 'create' button, if applicable.
			if(gCurHiliteButton) then
				IFButton_fnSelect(gCurHiliteButton,nil) -- Deactivate old button
				gCurHiliteButton = nil
				this.CurButton = nil
			end
		else
			-- Not in listindex. Focus is on the create buttons
			this.CurButton = "new"
			gCurHiliteButton = this.buttons[this.CurButton]
			IFButton_fnSelect(gCurHiliteButton,1) -- Activate button
		end

		IFObj_fnSetVis(this.Helptext_Accept,1)

		ifs_mod_menu_launcher_listbox_layout.SelectedIdx = aListIndex
		ifs_mod_menu_launcher_listbox_layout.CursorIdx = aListIndex
	end


	function ifs_mod_menu_launcher_fnListFullOk()
		local this = ifs_mod_menu_launcher
		ifs_mod_menu_launcher_fnSetPieceVis(this, 1)
	end


	-- Helper function: turns pieces on/off as requested
	function ifs_mod_menu_launcher_fnSetPieceVis(this,bNormalVis)
		IFObj_fnSetVis(this.listbox,bNormalVis)
		IFObj_fnSetVis(this.buttons,bNormalVis and (not gNoNewProfiles))

		IFObj_fnSetVis(this.Helptext_Accept,bNormalVis)
		IFObj_fnSetVis(this.Helptext_Back,bNormalVis )

		if(bNormalVis) then
			ifs_mod_menu_launcher_fnRegetListbox(this)
		end
	end

	ifs_mod_menu_launcher = NewIFShellScreen {
		bAcceptIsSelect = 1,

		buttons = NewIFContainer {
			ScreenRelativeX = 0.5, -- center
			ScreenRelativeY = 0.5, -- center
			y = 80,
		},

		movieIntro      = nil,
		movieBackground = "shell_main",
		bg_texture      =  nil, --    "single_player_option",
		enterSound      = "",
		exitSound       = "",

		Input_KeyDown = function (this, iKey)
			print("gInput_KeyDown: " .. iKey)
			if(iKey == 27 or iKey == 8 or iKey == 66) then
				this.Input_Back(this)
			elseif(iKey == 13 or iKey == 32) then
				this.Input_Accept(this)
			elseif(iKey == 33) then
				this.Input_LTrigger(this)
			elseif(iKey == 34) then
				this.Input_RTrigger(this)
			end
		end,
		Enter = function(this, bFwd)
			print("ifs_mod_menu_launcher.Enter" )
			gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

			this.Populate_List(this, ifs_mod_menu_launcher_listbox_contents)
			--local ListboxHeight = this.listbox.height * 0.5
			--IFObj_fnSetPos(this.buttons,this.listbox.width * -0.5 + 16, -(ListboxHeight + 30))
		end,
		Populate_List = function(this, the_table)
			ifs_mod_menu_launcher_listbox_layout.FirstShownIdx = 1
			ifs_mod_menu_launcher_listbox_layout.SelectedIdx = 1
			ifs_mod_menu_launcher_listbox_layout.CursorIdx = 1
			ListManager_fnFillContents(this.listbox,the_table,ifs_mod_menu_launcher_listbox_layout)
		end,
		Input_Back = function(this)
			print("ifs_mod_menu_launcher.Back ", tostring(ScriptCB_IsScreenInStack("ifs_mod_menu_launcher") ) )
			if (ScriptCB_IsScreenInStack("ifs_mod_menu_launcher") ) then 
				print("ifs_mod_menu_launcher: pop the screen ") 
				--ScriptCB_PopScreen("ifs_sp_campaign")
				ScriptCB_PopScreen("ifs_sp")
			else 
				print("ifs_mod_menu_launcher: do nothing ") 
			end 
		end,

		Input_GeneralUp = function(this)
			-- Fix for 11032 - if we're headed to another screen already,
			-- ignore inputs - NM 8/20/05
			if(ifs_mod_menu_launcher.bNoInputs) then
				return
			end

			-- In listbox.
			ListManager_fnNavUp(this.listbox,ifs_mod_menu_launcher_listbox_contents,ifs_mod_menu_launcher_listbox_layout)

		end,

		Input_LTrigger = function(this)
			ListManager_fnPageUp(this.listbox,ifs_mod_menu_launcher_listbox_contents,ifs_mod_menu_launcher_listbox_layout)
		end,

		Input_GeneralDown = function(this)
			-- Fix for 11032 - if we're headed to another screen already,
			-- ignore inputs - NM 8/20/05
			if(ifs_mod_menu_launcher.bNoInputs) then
				return
			end

			ListManager_fnNavDown(this.listbox,ifs_mod_menu_launcher_listbox_contents,ifs_mod_menu_launcher_listbox_layout)
		end,

		Input_RTrigger = function(this)
			ListManager_fnPageDown(this.listbox,ifs_mod_menu_launcher_listbox_contents,ifs_mod_menu_launcher_listbox_layout)
		end,

		-- Not possible on this screen
		Input_GeneralLeft = function(this)
		end,
		Input_GeneralRight = function(this)
		end,

		Input_Accept = function(this)
			print("ifs_mod_menu_launcher.Accept CurButton", tostring(this.CurButton) )
			if( this.CurButton == "_back" ) then
				-- If base class handled this work, then we're done
				if(gShellScreen_fnDefaultInputAccept(this)) then
					return
				end
			else
				-- Fix for 11032 - if we're headed to another screen already,
				-- ignore inputs - NM 8/20/05
				if(ifs_mod_menu_launcher.bNoInputs) then
					return
				end

				
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				-- jump to the load screen
				local Selection = ifs_mod_menu_launcher_listbox_contents[ifs_mod_menu_launcher_listbox_layout.SelectedIdx]
				if (Selection.action ~= nil and type(Selection.action) == "string" ) then 
					ScriptCB_PushScreen(Selection.action)
				elseif(Selection.action ~= nil and type(Selection.action) == "function") then
					Selection.action(Selection.id) -- todo , test this
				elseif(Selection.action ~= nil and type(Selection.action) == "table") then
					this.Populate_List(Selection.action)
				end
			end
		end,

		Input_Misc = function(this)
			-- Fix for 11032 - if we're headed to another screen already,
			-- ignore inputs - NM 8/20/05
			if(ifs_mod_menu_launcher.bNoInputs) then
				return
			end

		end,

		fSilentLoginTimer = 0,
		Update = function(this,fDt)
			-- Call base class functionality
			gIFShellScreenTemplate_fnUpdate(this, fDt)

		end,
	}

	function ifs_mod_menu_launcher_fnBuildScreen(this)

		ifs_mod_menu_launcher_listbox_layout.yHeight = ScriptCB_GetFontHeight(ifs_mod_menu_launcher_listbox_layout.Font) + gButtonHeightPad
		local ListboxHeight = ifs_mod_menu_launcher_listbox_layout.showcount * (ifs_mod_menu_launcher_listbox_layout.yHeight + ifs_mod_menu_launcher_listbox_layout.ySpacing) + 30
		this.listbox = NewButtonWindow { ZPos = 100, x=0, y = -40,
			ScreenRelativeX = 0.5, -- center
			ScreenRelativeY = 0.5, -- middle of screen
			width = ifs_mod_menu_launcher_listbox_layout.width + 35,
			height = ListboxHeight,
			titleText = "Mod Launcher"
		}

		ListManager_fnInitList(this.listbox,ifs_mod_menu_launcher_listbox_layout)
		this.buttons.y = ListboxHeight * 0.5 + gButtonGutter
	end

	ifs_mod_menu_launcher_fnBuildScreen(ifs_mod_menu_launcher)
	ifs_mod_menu_launcher_fnBuildScreen = nil
	AddIFScreen(ifs_mod_menu_launcher,"ifs_mod_menu_launcher")

end

local target_screen = ifs_sp 
if(gPlatformStr == "PC" and ScriptCB_CheckProfanity == nil ) then -- only Aspyr version has the check profanity function
	target_screen = ifs_sp_campaign 
end 
--- use 'ifs_sp_campaign' instead of 'ifs_sp' if targeting the non-BFCC PC versions 
----- Redefine the accept handler for 'ifs_sp'----
print("Plumb in the Console instant action screen (hijack 'spacetraining' button )")
-- take over the 'spacetraining' button
IFText_fnSetString(target_screen.buttons.spacetraining.label, "Mod Menu Launcher")  -- set new text on spacetraining button

-- handle spacetraining button press
target_screen.old_Input_Accept = target_screen.Input_Accept
        
target_screen.Input_Accept = function(this)
    print("ifs_sp.Input_Accept: ".. tostring(this.CurButton))
    if(this.CurButton == "spacetraining") then
        print("Push: ifs_mod_menu_launcher")
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        ScreenToPush = ifs_mod_menu_launcher
        ifs_movietrans_PushScreen(ScreenToPush)
    else
        target_screen.old_Input_Accept(this)
    end
end

--AddModMenuItem( "missionselect_console",  "ifs.instant.title", "ifs_missionselect_console")

-- Add the screens to launch here:
--AddModMenuItem( "campaignList",  "ifs.sp.campaign", "ifs_sp_briefing")

--function ActionFunc(theId)
--	print("ActionFunc:", tostring(theId))
--end
--AddModMenuItem("GetSome", "Action Func", ActionFunc)
