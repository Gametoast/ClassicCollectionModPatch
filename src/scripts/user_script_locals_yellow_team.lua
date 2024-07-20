--
-- LocalsYellowTeamScript by Rayman1103
-- Description: Makes the locals team have yellow CP and unit icons.
--

gLocalsYellowTeamScriptHasLocals = false
gLocalsYellowTeamScriptInPostLoad = false
gLocalsYellowTeamScriptLocalsTeams = {}
gLocalsYellowTeamScriptTeam = { [1] = {}, [2] = {} }

--attempt to take control of (or listen to the calls of) the ScriptPostLoad function
if ScriptPostLoad and not LocalsYellowTeamScript_ScriptPostLoad then
	--backup the current ScriptPostLoad function
	local LocalsYellowTeamScript_ScriptPostLoad = ScriptPostLoad

	--this is our new ScriptPostLoad function
	ScriptPostLoad = function(...)
		gLocalsYellowTeamScriptInPostLoad = true
		-- let the original function happen and catch the return value
		local LocalsYellowTeamScript_SPLreturn = {LocalsYellowTeamScript_ScriptPostLoad(unpack(arg))}
		
		SetTeamAsEnemy = LocalsYellowTeamScript_SetTeamAsEnemy
		SetTeamAsFriend = LocalsYellowTeamScript_SetTeamAsFriend
		SetTeamName = LocalsYellowTeamScript_SetTeamName
		
		if gLocalsYellowTeamScriptHasLocals then
			for i, team in pairs(gLocalsYellowTeamScriptLocalsTeams) do
				for u = 1, 2, 1 do
					if gLocalsYellowTeamScriptTeam[u][team] == "friend" then
						SetTeamAsFriend(u, team)
					else
						SetTeamAsEnemy(u, team)
					end
				end
			end
		end
		
		-- return the unmanipulated values
		return unpack(LocalsYellowTeamScript_SPLreturn)
	end
end

--attempt to take control of (or listen to the calls of) the SetTeamAsEnemy function
if SetTeamAsEnemy and not LocalsYellowTeamScript_SetTeamAsEnemy then
	--backup the current SetTeamAsEnemy function
	LocalsYellowTeamScript_SetTeamAsEnemy = SetTeamAsEnemy

	--this is our new SetTeamAsEnemy function
	SetTeamAsEnemy = function(teamPtr1, teamPtr2, ...)
		-- let the original function happen and catch the return value
		local LocalsYellowTeamScript_STAEreturn = {LocalsYellowTeamScript_SetTeamAsEnemy(teamPtr1, teamPtr2, unpack(arg))}
		
		if teamPtr1 < 3 and teamPtr2 > 2 then
			gLocalsYellowTeamScriptTeam[teamPtr1][teamPtr2] = "enemy"
			if not gLocalsYellowTeamScriptInPostLoad and GetTeamFactionId(teamPtr2) == 5 then
				SetTeamAsNeutral(teamPtr1, teamPtr2)
			end
		end
		
		-- return the unmanipulated values
		return unpack(LocalsYellowTeamScript_STAEreturn)
	end
end

--attempt to take control of (or listen to the calls of) the SetTeamAsFriend function
if SetTeamAsFriend and not LocalsYellowTeamScript_SetTeamAsFriend then
	--backup the current SetTeamAsFriend function
	LocalsYellowTeamScript_SetTeamAsFriend = SetTeamAsFriend

	--this is our new SetTeamAsFriend function
	SetTeamAsFriend = function(teamPtr1, teamPtr2, ...)
		-- let the original function happen and catch the return value
		local LocalsYellowTeamScript_STAEreturn = {LocalsYellowTeamScript_SetTeamAsFriend(teamPtr1, teamPtr2, unpack(arg))}
		
		if teamPtr1 < 3 and teamPtr2 > 2 then
			gLocalsYellowTeamScriptTeam[teamPtr1][teamPtr2] = "friend"
			if not gLocalsYellowTeamScriptInPostLoad and GetTeamFactionId(teamPtr2) == 5 then
				SetTeamAsNeutral(teamPtr1, teamPtr2)
			end
		end
		
		-- return the unmanipulated values
		return unpack(LocalsYellowTeamScript_STAEreturn)
	end
end

--attempt to take control of (or listen to the calls of) the SetTeamName function
if SetTeamName and not LocalsYellowTeamScript_SetTeamName then
	--backup the current SetTeamName function
	LocalsYellowTeamScript_SetTeamName = SetTeamName

	--this is our new SetTeamName function
	SetTeamName = function(teamPtr, teamName, ...)
		-- let the original function happen and catch the return value
		local LocalsYellowTeamScript_STNreturn = {LocalsYellowTeamScript_SetTeamName(teamPtr, teamName, unpack(arg))}
		
		if teamPtr > 2 and GetTeamFactionId(teamPtr) == 5 then
			gLocalsYellowTeamScriptHasLocals = true
			table.insert(gLocalsYellowTeamScriptLocalsTeams, teamPtr)
			SetTeamAsNeutral(1, teamPtr)
			SetTeamAsNeutral(2, teamPtr)
		end
		
		-- return the unmanipulated values
		return unpack(LocalsYellowTeamScript_STNreturn)
	end
end