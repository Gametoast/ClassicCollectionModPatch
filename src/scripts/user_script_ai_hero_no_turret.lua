--
-- AIHeroScriptNoTurret by Rayman1103
-- Description: Prevents the AI Hero from entering turrets/vehicles.
--

AIHeroScriptNoTurret = nil --Force garbage collection (just in case)

AIHeroScriptNoTurret =
{
	numTeams = 2,
	noVehicleHeroes =
	{
		rep_hero_yoda = true,
		cis_hero_grievous = true,
	},
	heroClassName = {},
	heroClassIndex = {},
	hasStarted = false,
}

function AIHeroScriptNoTurret:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function AIHeroScriptNoTurret:Start()
	if self.hasStarted then return end
	
	local initAIHeroSupport = function(teamPtr)
		OnCharacterSpawnTeam(
			function(character)
				local charClass = GetCharacterClass(character)
				local heroIndex = self.heroClassIndex[teamPtr]
				
				if charClass == heroIndex then
					if IsCharacterHuman(character) then
						if not self.noVehicleHeroes[self.heroClassName[teamPtr]] then
							SetClassProperty(self.heroClassName[teamPtr], "NoEnterVehicles", "0")
						end
					else
						SetClassProperty(self.heroClassName[teamPtr], "NoEnterVehicles", "1")
					end
				end
			end,
			teamPtr
		)
	end
	
	for i = 1, self.numTeams do
		if self.heroClassName[i] then
			self.heroClassIndex[i] = (GetTeamClassCount(i) - 1)
			initAIHeroSupport(i)
		end
	end
	
	self.hasStarted = true
end

gAIHeroNoTurretClasses = {}
gAIHeroNoTurretNumTeams = 0

--attempt to take control of (or listen to the calls of) the ScriptPostLoad function
if ScriptPostLoad and not AIHeroScriptNoTurret_ScriptPostLoad then
	--backup the current ScriptPostLoad function
	local AIHeroScriptNoTurret_ScriptPostLoad = ScriptPostLoad

	--this is our new ScriptPostLoad function
	ScriptPostLoad = function(...)
		-- let the original function happen and catch the return value
		local AIHeroScriptNoTurret_SPLreturn = {AIHeroScriptNoTurret_ScriptPostLoad(unpack(arg))}
		
		if not IsCampaign() then
			local GameData = ScriptCB_GetNetGameDefaults()
			
			if GameData.bHeroesEnabled then
				if gAIHeroNoTurretNumTeams > 0 then
					AIHeroScriptNoTurret:New{heroClassName = gAIHeroNoTurretClasses, numTeams = 2,}:Start()
				end
			end
		end
		
		-- return the unmanipulated values
		return unpack(AIHeroScriptNoTurret_SPLreturn)
	end
end

--attempt to take control of (or listen to the calls of) the SetHeroClass function
if SetHeroClass and not AIHeroScriptNoTurret_SetHeroClass then
	--backup the current SetHeroClass function
	local AIHeroScriptNoTurret_SetHeroClass = SetHeroClass

	--this is our new SetHeroClass function
	SetHeroClass = function(teamPtr, heroClassName, ...)
		-- let the original function happen and catch the return value
		local AIHeroScriptNoTurret_SHCreturn = {AIHeroScriptNoTurret_SetHeroClass(teamPtr, heroClassName, unpack(arg))}
		
		if heroClassName ~= "" then
			gAIHeroNoTurretClasses[teamPtr] = heroClassName
			
			if teamPtr > gAIHeroNoTurretNumTeams then
				gAIHeroNoTurretNumTeams = teamPtr
			end
		end
		
		-- return the unmanipulated values
		return unpack(AIHeroScriptNoTurret_SHCreturn)
	end
end