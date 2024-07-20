--
-- HeroVOScript by Rayman1103
-- Description: Plays voicelines when Heroes enter the battlefield or have been defeated.
--

HeroVOScript = nil --Force garbage collection (just in case)

HeroVOScript =
{
	numTeams = 2,
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
	hasStarted = false,
}

function HeroVOScript:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function HeroVOScript:Start()
	if self.hasStarted then return end
	
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
	
	local initHeroVO = function(teamPtr)
		OnCharacterDeathTeam(
			function(character, killer)
				local charClass = GetCharacterClass(character)
				if charClass == self.heroClassIndex[teamPtr] then
					local usVO = self.heroVOList[GetTeamFactionId(teamPtr)].Us[self.heroClassName[teamPtr]]
					local themVO = self.heroVOList[GetTeamFactionId(self.otherTeam[teamPtr])].Them[self.heroClassName[teamPtr]]
					
					if usVO then
						BroadcastVoiceOver(usVO .. "exit", teamPtr)
					end
					if themVO then
						BroadcastVoiceOver(themVO .. "exit", self.otherTeam[teamPtr])
					end
				end
			end,
			teamPtr
		)
		
		OnCharacterSpawnTeam(
			function(character)
				local charClass = GetCharacterClass(character)
				local heroIndex = self.heroClassIndex[teamPtr]
				
				if charClass == heroIndex then
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
				end
			end,
			teamPtr
		)
	end
	
	for i = 1, self.numTeams do
		if self.heroClassName[i] then
			self.heroClassIndex[i] = (GetTeamClassCount(i) - 1)
			self.otherTeam[i] = (i == 2 and 1 or 2)
			initHeroVO(i)
		end
	end
	
	self.hasStarted = true
end

gHeroVOClasses = {}
gHeroVONumTeams = 0

--attempt to take control of (or listen to the calls of) the ScriptPostLoad function
if ScriptPostLoad and not HeroVOScript_ScriptPostLoad then
	--backup the current ScriptPostLoad function
	local HeroVOScript_ScriptPostLoad = ScriptPostLoad

	--this is our new ScriptPostLoad function
	ScriptPostLoad = function(...)
		-- let the original function happen and catch the return value
		local heroVOScript_SPLreturn = {HeroVOScript_ScriptPostLoad(unpack(arg))}
		
		if not IsCampaign() then
			local GameData = ScriptCB_GetNetGameDefaults()
			
			if GameData.bHeroesEnabled then
				if GameData.bHeroesEnabled then
					if gHeroVONumTeams > 0 then
						HeroVOScript:New{heroClassName = gHeroVOClasses, numTeams = 2,}:Start()
					end
				end
			end
		end
		
		-- return the unmanipulated values
		return unpack(heroVOScript_SPLreturn)
	end
end

--attempt to take control of (or listen to the calls of) the SetHeroClass function
if SetHeroClass and not HeroVOScript_SetHeroClass then
	--backup the current SetHeroClass function
	local HeroVOScript_SetHeroClass = SetHeroClass

	--this is our new SetHeroClass function
	SetHeroClass = function(teamPtr, heroClassName, ...)
		-- let the original function happen and catch the return value
		local heroVOScript_SHCreturn = {HeroVOScript_SetHeroClass(teamPtr, heroClassName, unpack(arg))}
		
		if heroClassName ~= "" then
			gHeroVOClasses[teamPtr] = heroClassName
			
			if teamPtr > gHeroVONumTeams then
				gHeroVONumTeams = teamPtr
			end
		end
		
		-- return the unmanipulated values
		return unpack(heroVOScript_SHCreturn)
	end
end