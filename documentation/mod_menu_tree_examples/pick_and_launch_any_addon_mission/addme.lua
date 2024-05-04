-- mod menu tree example that adds a menu allowing the user to launch any addon mission 
-- Does not localize the showstr for each mission, just uses mission name
-- Author BAD_AL 

print("pick_and_launch\\addme.lua start")

if( zero_patch_addon_mission_list ~= nil ) then
	print("pick_and_launch\\addme.lua add the menu stuff")

	local function LaunchTheMission(missionName)
		print('Function: LaunchTheMission() ' .. 'mission= ' .. missionName)
		ScriptCB_SetMissionNames({{Map = missionName, dnldable = nil, Side = 1, SideChar = nil, Team1 = 'team1', Team2 = 'team2'}}, false)
		ScriptCB_SetTeamNames(0,0)
		ScriptCB_EnterMission()
	end

	local launch_mission_list = {}
	local newEntry = nil
	for _,value in zero_patch_addon_mission_list do 
		-- entry needs to be 3 item list; string1, string2, <action>
		-- <action>:
		-- string   => try to launch a screen named <action>
		-- function => call a function called <action> with param <string1>
		-- list     => load a new list of stuff (sub menu)
		newEntry = {id=value, showstr=value, action=LaunchTheMission}
		table.insert(launch_mission_list, newEntry)
	end

	AddModMenuItem( "missions",  "Select addon mission to launch", launch_mission_list)
end
print("pick_and_launch\\addme.lua end")
