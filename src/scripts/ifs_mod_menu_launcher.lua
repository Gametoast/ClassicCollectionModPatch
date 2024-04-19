
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

	--function AddModMenuItem({"ID", "display string", <action>, menu_table[optional sub menu table] })
	--      <action> == string -> launch a screen named 'name';
	--      <action> == function -> call the function name(id); 
	--      <action> == table -> push ui and show it
	-- menu_table - if nil, push to the initial menu list; otherwise push the item to 'menu_table'.
	function AddModMenuItem(id, display_string, name, menu_table )
		print(string.format("AddModMenuItem: Adding item { %s  %s  %s }", id, display_string, tostring(name)))
		local newItem = {id=  id, showstr=  display_string, action= name }
		if(menu_table ~= nil) then 
			table.insert( menu_table, newItem )
		else
			table.insert( ifs_mod_menu_launcher_listbox_contents, newItem )
		end
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
		menuStack ={}, -- should be a list of lists; used for menu nav
		titleList ={},
		currentMenu = nil,

		movieIntro      = nil,
		movieBackground = "shell_main",
		bg_texture      =  nil, --    "single_player_option",
		enterSound      = "",
		exitSound       = "",
		GetTitleString = function(this)
			local retVal = "mod launcher"
			local count = table.getn(this.titleList)
			if(count > 0) then
				retVal = this.titleList[count]
			end
			print("GetTitleString: " .. retVal)
			return retVal
		end,
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
		-- Push a list of items to show
		Push_List = function(this, the_list, the_title)
			table.insert(this.menuStack, the_list)
			table.insert(this.titleList, the_title or "MOD LAUNCHER")
			this.currentMenu = the_list
			print("mod_launcher.Push_List with item[1].id = " .. this.currentMenu[1].id )
			this.Populate_List(this)
		end,
		-- Remove the list of items last pushed.
		-- If there is a list of items to show left on the menu stack, show it;
		-- if there are no more lists of items to show, pop the screen
		Pop_List = function(this)
			print("mod_launcher.Pop_List")
			local count = table.getn(this.menuStack)
			if( count > 0) then
				table.remove(this.menuStack, count)
				table.remove(this.titleList, count)
			end
			count = table.getn(this.menuStack)
			if(count > 0) then
				this.currentMenu = this.menuStack[count]
				print("mod_launcher.Pop_List with item[1].id = " .. this.currentMenu[1].id )
				this.Populate_List(this)
			else
				this.currentMenu = nil
				print("mod_launcher.Pop_List no more to show, exiting...")
				ScriptCB_PopScreen()
			end
		end,
		Enter = function(this, bFwd)
			print("ifs_mod_menu_launcher.Enter" )
			gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
			this.Push_List(this,ifs_mod_menu_launcher_listbox_contents, "Mod Launcher")
			print("ifs_mod_menu_launcher.Enter this.listbox= " .. tostring(this.listbox) )
			--tprint(this.listbox)
		end,
		Populate_List = function(this)
			print("ifs_mod_menu_launcher.Populate_List: size = " .. tostring(table.getn(this.currentMenu)))
			--for _, item in this.currentMenu do -- debug print stuff
			--	print(string.format("id:'%s'  '%s' action: %s", item.id, item.showstr, tostring(item.action)))
			--end
			-- try to set the title text
			IFText_fnSetString(this.listbox.titleBarElement, this.GetTitleString(this))
			ifs_mod_menu_launcher_listbox_layout.FirstShownIdx = 1
			ifs_mod_menu_launcher_listbox_layout.SelectedIdx = 1
			ifs_mod_menu_launcher_listbox_layout.CursorIdx = 1
			ListManager_fnFillContents(this.listbox,this.currentMenu,ifs_mod_menu_launcher_listbox_layout)
		end,
		Input_Back = function(this)
			print("ifs_mod_menu_launcher.Back ", tostring(ScriptCB_IsScreenInStack("ifs_mod_menu_launcher") ) )
			this.Pop_List(this)
		end,

		Input_GeneralUp = function(this)
			-- Fix for 11032 - if we're headed to another screen already,
			-- ignore inputs - NM 8/20/05
			if(ifs_mod_menu_launcher.bNoInputs) then
				return
			end

			ListManager_fnNavUp(this.listbox,this.currentMenu,ifs_mod_menu_launcher_listbox_layout)
		end,

		Input_LTrigger = function(this)
			ListManager_fnPageUp(this.listbox,this.currentMenu,ifs_mod_menu_launcher_listbox_layout)
		end,

		Input_GeneralDown = function(this)
			-- Fix for 11032 - if we're headed to another screen already,
			-- ignore inputs - NM 8/20/05
			if(ifs_mod_menu_launcher.bNoInputs) then
				return
			end

			ListManager_fnNavDown(this.listbox,this.currentMenu,ifs_mod_menu_launcher_listbox_layout)
		end,

		Input_RTrigger = function(this)
			ListManager_fnPageDown(this.listbox,this.currentMenu,ifs_mod_menu_launcher_listbox_layout)
		end,

		-- Not possible on this screen
		Input_GeneralLeft = function(this)
		end,
		Input_GeneralRight = function(this)
		end,

		Input_Accept = function(this)
			print("ifs_mod_menu_launcher.Accept CurButton", tostring(this.CurButton) )

			if(gMouseListBox) then
				-- Mouse Support; works on normal BF2; CC changed mouse stuff
				print( string.format("ifs_mod_menu_launcher: Got Mouse click, update selected idx from %s to %s", 
						tostring(gMouseListBox.Layout.SelectedIdx) ,  tostring(gMouseListBox.Layout.CursorIdx) ) )
			
				-- set the selection 
				gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
			else 
				print("gMouseListBox == nil")
			end
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
				local Selection = this.currentMenu[ifs_mod_menu_launcher_listbox_layout.SelectedIdx]
				if(Selection.id ~= nil) then 
					print("ifs_mod_menu_launcher.Accept selected item.id: ".. tostring(Selection.id))
				end
				if (Selection.action ~= nil and type(Selection.action) == "string" ) then 
					print("ifs_mod_menu_launcher.Input_Accept: item type == string")
					ScriptCB_PushScreen(Selection.action)
				elseif(Selection.action ~= nil and type(Selection.action) == "function") then
					print("ifs_mod_menu_launcher.Input_Accept: item type == function")
					Selection.action(Selection.id) -- todo , test this
				elseif(Selection.action ~= nil and type(Selection.action) == "table") then
					print("ifs_mod_menu_launcher.Input_Accept: item type == table")
					-- new title should be 'Selection.showstr'
					this.Push_List(this,Selection.action, Selection.showstr)
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
print("Plumb in the mod menu launcher (hijack 'spacetraining' button )")
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
