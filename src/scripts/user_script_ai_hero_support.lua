--
-- AIHeroScript by Rayman1103
--

AIHeroScript = nil --Force garbage collection (just in case)

AIHeroScript =
{
	gameMode = "",
	heroSpawnDelay = 5,
	heroRespawnTime = 30,
	heroHealth = 3000,
	numTeams = 2,
	heroDenyCPCapture = false,
	heroDisableVehicles = true,
	noVehicleHeroes =
	{
		rep_hero_yoda = true,
		cis_hero_grievous = true,
	},
	heroBroadcastVO = true,
	heroVOList =
	{
		[1] = -- Alliance
		{
			Us =
			{
				all_hero_luke_jedi = "all_hero_luke_",
				all_hero_hansolo_tat = "all_hero_solo_",
				all_hero_leia = "all_hero_leia_",
				all_hero_chewbacca = "all_hero_chewbacca_",
				all_hero_luke_pilot = "all_hero_luke_",
				all_hero_luke_storm = "all_hero_luke_",
				all_hero_luke_tat = "all_hero_luke_",
				all_hero_hansolo_storm = "all_hero_solo_",
				rep_hero_obiwan = "all_hero_obiwan_",
				rep_hero_obiwan_old = "all_hero_obiwan_",
				all_hero_obiwan = "all_hero_obiwan_",
			},
			Them =
			{
				imp_hero_darthvader = "all_hero_vader_",
				imp_hero_emperor = "all_hero_emperor_",
				imp_hero_bobafett = "all_hero_boba_",
				rep_hero_anakin = "all_hero_vader_",
				rep_hero_cloakedanakin = "all_hero_vader_",
			},
		},
		[2] = -- Empire
		{
			Us =
			{
				imp_hero_darthvader = "imp_hero_vader_",
				imp_hero_emperor = "imp_hero_emperor_",
				imp_hero_bobafett = "imp_hero_boba_",
				rep_hero_anakin = "imp_hero_vader_",
				rep_hero_cloakedanakin = "imp_hero_vader_",
			},
			Them =
			{
				all_hero_luke_jedi = "imp_hero_luke_",
				all_hero_hansolo_tat = "imp_hero_solo_",
				all_hero_leia = "imp_hero_leia_",
				all_hero_chewbacca = "imp_hero_chewbacca_",
				all_hero_luke_pilot = "imp_hero_luke_",
				all_hero_luke_storm = "imp_hero_luke_",
				all_hero_luke_tat = "imp_hero_luke_",
				all_hero_hansolo_storm = "imp_hero_solo_",
				rep_hero_obiwan = "imp_hero_obiwan_",
				rep_hero_obiwan_old = "imp_hero_obiwan_",
				all_hero_obiwan = "imp_hero_obiwan_",
			},
		},
		[3] = -- Republic
		{
			Us =
			{
				rep_hero_yoda = "rep_hero_yoda_",
				rep_hero_macewindu = "rep_hero_windu_",
				rep_hero_anakin = "rep_hero_anakin_",
				rep_hero_aalya = "rep_hero_aayla_",
				rep_hero_kiyadimundi = "rep_hero_mundi_",
				rep_hero_obiwan = "rep_hero_kenobi_",
			},
			Them =
			{
				cis_hero_grievous = "rep_hero_grievous_",
				cis_hero_darthmaul = "rep_hero_maul_",
				cis_hero_countdooku = "rep_hero_dooku_",
				cis_hero_jangofett = "rep_hero_jango_",
			},
		},
		[4] = -- CIS
		{
			Us =
			{
				cis_hero_grievous = "cis_hero_grievous_",
				cis_hero_darthmaul = "cis_hero_maul_",
				cis_hero_countdooku = "cis_hero_dooku_",
				cis_hero_jangofett = "cis_hero_jango_",
			},
			Them =
			{
				rep_hero_yoda = "cis_hero_yoda_",
				rep_hero_macewindu = "cis_hero_windu_",
				rep_hero_anakin = "cis_hero_anakin_",
				rep_hero_aalya = "cis_hero_aayla_",
				rep_hero_kiyadimundi = "cis_hero_mundi_",
				rep_hero_obiwan = "cis_hero_kenobi_",
			},
		},
	},
	otherTeam = {},
	heroClassName = {},
	heroClassIndex = {},
	recentAIHero = {},
	heroEntity = {},
	humanHero = {},
	infiniteReforceBound = 2000000000, --Bounding number used to identify infinite reinforcements
	AIHeroSpawnTimer = {},
	heroSkipSpawnVO = {},
	heroDisableSpawnVO = {},
	dontKillAI = {},
	onBotFirstSpawn = {},
	onHeroDeath = {},
	hasStarted = false,
}

function AIHeroScript:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function AIHeroScript:Start()
	if self.hasStarted then return end
	
	local incrementReinforcementsIfConquest = function(teamPtr)
		if string.lower(self.gameMode) == "conquest" then
			if GetReinforcementCount(teamPtr) < self.infiniteReforceBound then
				AddReinforcements(teamPtr, 1)
			end
		end
	end
	
	local getTeamName = function(teamPtr)
		local teamName = nil
		
		if GetTeamFactionId(teamPtr) == 1 then
			teamName = "all"
		elseif GetTeamFactionId(teamPtr) == 2 then
			teamName = "imp"
		elseif GetTeamFactionId(teamPtr) == 3 then
			teamName = "rep"
		elseif GetTeamFactionId(teamPtr) == 4 then
			teamName = "cis"
		end
		
		return teamName
	end
	
	local killAIHeroOnTeam = function(teamPtr)
		local characterIndex = self.heroEntity[teamPtr]
		local heroIndex = self.heroClassIndex[teamPtr]
		
		if not characterIndex then return end
		if GetCharacterClass(characterIndex) == heroIndex then
			local characterUnit = GetCharacterUnit(characterIndex)
			self.heroEntity[teamPtr] = nil
			if characterUnit then
				incrementReinforcementsIfConquest(teamPtr)
				KillObject(characterUnit)
			end
		end
	end
	
	local createRespawnCallbacks = function(teamPtr)
		self.onHeroDeath[teamPtr] = OnCharacterDeathTeam(
			function(character, killer)
				local charClass = GetCharacterClass(character)
				if charClass == self.heroClassIndex[teamPtr] then
					ReleaseCharacterDeath(self.onHeroDeath[teamPtr])
					self.onHeroDeath[teamPtr] = nil
					
					StopTimer(self.AIHeroSpawnTimer[teamPtr])
					if IsCharacterHuman(character) then
						self.humanHero[teamPtr] = false
					else
						if self.heroBroadcastVO and teamPtr < 3 and not self.humanHero[teamPtr] and self.heroRespawnTime > 0 then
							local usVO = self.heroVOList[GetTeamFactionId(teamPtr)].Us[self.heroClassName[teamPtr]]
							local themVO = self.heroVOList[GetTeamFactionId(self.otherTeam[teamPtr])].Them[self.heroClassName[teamPtr]]
							
							if usVO then
								BroadcastVoiceOver(usVO .. "exit", teamPtr)
							end
							if themVO then
								BroadcastVoiceOver(themVO .. "exit", self.otherTeam[teamPtr])
							end
						end
					end
					if not self.humanHero[teamPtr] and self.heroRespawnTime > -1 then
						SetTimerValue(self.AIHeroSpawnTimer[teamPtr], self.heroRespawnTime)
						StartTimer(self.AIHeroSpawnTimer[teamPtr])
					end
				end
			end,
			teamPtr
		)
	end
	
	local createBotHeroSpawnCallbacks = function(teamPtr)
		self.onBotFirstSpawn[teamPtr] = OnCharacterSpawnTeam(
			function(character)
				if IsCharacterHuman(character) or self.humanHero[teamPtr] then return end
				
				ReleaseCharacterSpawn(self.onBotFirstSpawn[teamPtr])
				self.onBotFirstSpawn[teamPtr] = nil
				
				local charUnit = GetCharacterUnit(character)
				local destination = GetEntityMatrix(charUnit)
				
				incrementReinforcementsIfConquest(teamPtr)
				SetEntityMatrix(charUnit, CreateMatrix(0, 0, 0, 0, 0, 0, -999, destination))
				KillObject(charUnit)
				
				local spawnedHero = nil
				
				SelectCharacterClass(character, self.heroClassName[teamPtr])
				SpawnCharacter(character, destination)
				spawnedHero = GetCharacterUnit(character)
				
				if spawnedHero then
					self.heroEntity[teamPtr] = character
					self.recentAIHero[character] = true
					SetProperty(spawnedHero, "MaxHealth", self.heroHealth)
					SetProperty(spawnedHero, "CurHealth", self.heroHealth)
					if self.heroDisableVehicles then
						SetClassProperty(self.heroClassName[teamPtr], "NoEnterVehicles", "1")
					end
					if self.heroDenyCPCapture then
						SetClassProperty(self.heroClassName[teamPtr], "CapturePosts", "0")
					end
					if self.heroBroadcastVO and teamPtr < 3 and not self.heroDisableSpawnVO[teamPtr] then
						if not self.heroSkipSpawnVO[teamPtr] then
							local usVO = self.heroVOList[GetTeamFactionId(teamPtr)].Us[self.heroClassName[teamPtr]]
							local themVO = self.heroVOList[GetTeamFactionId(self.otherTeam[teamPtr])].Them[self.heroClassName[teamPtr]]
							
							if usVO then
								BroadcastVoiceOver(usVO .. "enter", teamPtr)
							else
								if getTeamName(teamPtr) then
									BroadcastVoiceOver("team_bonus_leader_us_" .. getTeamName(teamPtr), teamPtr)
								end
							end
							if themVO then
								BroadcastVoiceOver(themVO .. "enter", self.otherTeam[teamPtr])
							else
								if getTeamName(self.otherTeam[teamPtr]) then
									BroadcastVoiceOver("team_bonus_leader_them_" .. getTeamName(self.otherTeam[teamPtr]), self.otherTeam[teamPtr])
								end
							end
							
							if self.heroRespawnTime == 0 then
								self.heroDisableSpawnVO[teamPtr] = true
							end
						else
							self.heroSkipSpawnVO[teamPtr] = false
						end
					end
				else
					self.dontKillAI[teamPtr] = true
					SetTimerValue(self.AIHeroSpawnTimer[teamPtr], 0)
					StartTimer(self.AIHeroSpawnTimer[teamPtr])
					return
				end
				
				if self.heroRespawnTime > -1 then
					createRespawnCallbacks(teamPtr)
				end
			end,
			teamPtr
		)
	end
	
	local createHumanSpawnAndBotCountProtectCallbacks = function(teamPtr)
		OnCharacterSpawnTeam(
			function(character)
				-- Bot Count Protect
				if not IsCharacterHuman(character) then
					if self.recentAIHero[character] then
						local charClass = GetCharacterClass(character)
						if charClass ~= self.heroClassIndex[teamPtr] then
							incrementReinforcementsIfConquest(teamPtr)
							
							local charUnit = GetCharacterUnit(character)
							SetEntityMatrix(charUnit, CreateMatrix(0, 0, 0, 0, 0, 0, -999, GetEntityMatrix(charUnit)))
							KillObject(charUnit)
							self.recentAIHero[character] = nil
						end
					end
				-- Human Hero Spawn
				else
					local charClass = GetCharacterClass(character)
					local heroIndex = self.heroClassIndex[teamPtr]
					
					if charClass == heroIndex then
						if self.onBotFirstSpawn[teamPtr] then
							ReleaseCharacterSpawn(self.onBotFirstSpawn[teamPtr])
							self.onBotFirstSpawn[teamPtr] = nil
						end
						
						StopTimer(self.AIHeroSpawnTimer[teamPtr])
						self.humanHero[teamPtr] = true
						killAIHeroOnTeam(teamPtr)
						if self.heroDisableVehicles and not self.noVehicleHeroes[self.heroClassName[teamPtr]] then
							SetClassProperty(self.heroClassName[teamPtr], "NoEnterVehicles", "0")
						end
						if self.heroDenyCPCapture then
							SetClassProperty(self.heroClassName[teamPtr], "CapturePosts", "1")
						end
						
						if self.heroRespawnTime > -1 then
							createRespawnCallbacks(teamPtr)
						end
					end
				end
			end,
			teamPtr
		)
	end
	
	local createTimerCallbacks = function(teamPtr)
		OnTimerElapse(
			function(timer)
				StopTimer(self.AIHeroSpawnTimer[teamPtr])
				
				if not self.humanHero[teamPtr] then
					createBotHeroSpawnCallbacks(teamPtr)
					
					if self.dontKillAI[teamPtr] then
						self.dontKillAI[teamPtr] = false
						return
					end
					
					for i = 0, (GetTeamSize(teamPtr) - 1 ) do
						local characterIndex = GetTeamMember(teamPtr, i)
						if characterIndex then
							if not IsCharacterHuman(characterIndex) then
								local charUnit = GetCharacterUnit(characterIndex)
								if charUnit then
									incrementReinforcementsIfConquest(teamPtr)
									
									SetEntityMatrix(charUnit, CreateMatrix(0, 0, 0, 0, 0, 0, -999, GetEntityMatrix(charUnit)))
									KillObject(charUnit)
									break
								end
							end
						end
					end
				end
			end,
			self.AIHeroSpawnTimer[teamPtr]
		)
	end
	
	for i = 1, self.numTeams do
		if self.heroClassName[i] then
			self.heroClassIndex[i] = (GetTeamClassCount(i) - 1)
			self.humanHero[i] = false
			self.AIHeroSpawnTimer[i] = CreateTimer("AIHeroTimer" .. tostring(i))
			self.onBotFirstSpawn[i] = nil
			self.onHeroDeath[i] = nil
			self.otherTeam[i] = (i == 2 and 1 or 2)
			self.dontKillAI[i] = false
			createTimerCallbacks(i)
			createHumanSpawnAndBotCountProtectCallbacks(i)
			if self.heroSpawnDelay > 0 then
				SetTimerValue(self.AIHeroSpawnTimer[i], self.heroSpawnDelay)
				StartTimer(self.AIHeroSpawnTimer[i])
			else
				if self.heroRespawnTime == 0 then
					self.heroDisableSpawnVO[i] = true
				else
					self.heroSkipSpawnVO[i] = true
				end
				createBotHeroSpawnCallbacks(i)
			end
		end
	end
	
	self.hasStarted = true
end

local AIHeroClasses = {}
local AIHeroNumTeams = 0

--attempt to take control of (or listen to the calls of) the ScriptPostLoad function
if ScriptPostLoad and not AIHeroScript_ScriptPostLoad then
	--backup the current ScriptPostLoad function
	AIHeroScript_ScriptPostLoad = ScriptPostLoad

	--this is our new ScriptPostLoad function
	ScriptPostLoad = function(...)
		-- let the original function happen and catch the return value
		local aiHeroScript_SPLreturn = {AIHeroScript_ScriptPostLoad(unpack(arg))}
		
		if not IsCampaign() and not AIHeroSupport then
			local GameData = ScriptCB_GetNetGameDefaults()
			
			if GameData.bHeroesEnabled then
				local HeroData = ScriptCB_GetNetHeroDefaults()
				local heroScriptMode = "unknown"
				local heroScriptSpawnDelay = 5
				local heroScriptRespawnTime = HeroData.iHeroRespawnVal
				
				if HeroData.iHeroUnlock == 5 then
					heroScriptSpawnDelay = HeroData.iHeroUnlockVal
				end
				
				if ObjectiveConquest then
					heroScriptMode = "conquest"
				elseif ObjectiveCTF or ObjectiveOneFlagCTF then
					heroScriptMode = "ctf"
				elseif ObjectiveTDM and TDM then
					if TDM.isUberMode then
						heroScriptMode = "xl"
					end
				end
				
				if AIHeroNumTeams > 0 then
					AIHeroScript:New{gameMode = heroScriptMode, heroClassName = AIHeroClasses, numTeams = AIHeroNumTeams,
										heroSpawnDelay = heroScriptSpawnDelay, heroRespawnTime = heroScriptRespawnTime,}:Start()
				end
			end
		end
		
		-- return the unmanipulated values
		return unpack(aiHeroScript_SPLreturn)
	end
end

--attempt to take control of (or listen to the calls of) the SetHeroClass function
if SetHeroClass and not AIHeroScript_SetHeroClass then
	--backup the current SetHeroClass function
	AIHeroScript_SetHeroClass = SetHeroClass

	--this is our new SetHeroClass function
	SetHeroClass = function(teamPtr, heroClassName, ...)
		-- let the original function happen and catch the return value
		local aiHeroScript_SHCreturn = {AIHeroScript_SetHeroClass(teamPtr, heroClassName, unpack(arg))}
		
		if heroClassName ~= "" then
			AIHeroClasses[teamPtr] = heroClassName
			
			if teamPtr > AIHeroNumTeams then
				AIHeroNumTeams = teamPtr
			end
		end
		
		-- return the unmanipulated values
		return unpack(aiHeroScript_SHCreturn)
	end
end