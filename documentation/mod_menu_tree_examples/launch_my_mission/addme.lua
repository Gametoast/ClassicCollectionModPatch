-- Mod Menu Tree Example usage
-- author: BAD-AL 

if( AddModMenuItem ~= nil) then  -- check if ModMenuTree's 'AddModMenuItem' function is available

	if ( ScriptCB_IsFileExist("..\\..\\addon\\995\\data\\_lvl_pc\\mission.lvl") == 1) then  -- Check if 'The Clone Wars Revised' mod is available
		local function LaunchMyMission(missionName)
			print('Function: LaunchMyMission() ' .. 'mission= ' .. missionName)
			ScriptCB_SetMissionNames({{Map = missionName, dnldable = nil, Side = 1, SideChar = nil, Team1 = 'team1', Team2 = 'team2'}}, false)
			ScriptCB_SetTeamNames(0,0)
			ScriptCB_EnterMission()
		end

		local my_menu_options = {
			-- When the 'action' property is a function; that function will get called with the list item id on selected
			{id="tan1l_c4", showstr="Tantive IV TCWR c4", action=LaunchMyMission },
			{id="tan1l_con", showstr="Tantive IV TCWR", action=LaunchMyMission },
			{id="tan1l_ord66", showstr="Tantive IV TCWR Order66", action=LaunchMyMission },
			{id="uta1l_c3", showstr="Uta c3", action=LaunchMyMission },
			{id="uta1l_con", showstr="Uta con", action=LaunchMyMission },
			{id="uta1l_ord66", showstr="Uta order 66", action=LaunchMyMission },
			{id="yav1l_con", showstr="Yav TCWR", action=LaunchMyMission },
		}

		-- Add my options to the 'Mod Launcher' menu tree
		AddModMenuItem( "missions",  "Launch a TCWR mission", my_menu_options)
	else
		print("info: TCWR not detected, not adding menus for it.")
	end
end