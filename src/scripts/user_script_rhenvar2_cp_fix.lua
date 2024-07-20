--
-- RhenVar2CPFix by Rayman1103
-- Description: Fixes issue where Command Posts 1 and 4 aren't counted as valid CPs for Rhen Var Citadel Conquest.
--

--attempt to take control of (or listen to the calls of) the ScriptPostLoad function
if ScriptPostLoad and not RhenVar2CPFix_ScriptPostLoad then
	--backup the current ScriptPostLoad function
	local RhenVar2CPFix_ScriptPostLoad = ScriptPostLoad

	--this is our new ScriptPostLoad function
	ScriptPostLoad = function(...)
		-- let the original function happen and catch the return value
		local RhenVar2CPFix_SPLreturn = {RhenVar2CPFix_ScriptPostLoad(unpack(arg))}
		
		--check if the map's Rhen Var Citadel and if the Conquest objective is defined
		if GetWorldFilename() == "rhenvar2" and ObjectiveConquest ~= nil then
			--if cp6 is undefined, add the missing CPs
			if cp6 == nil then
				cp6 = CommandPost:New{name = "CP1"}
				cp7 = CommandPost:New{name = "CP4"}
				conquest:AddCommandPost(cp6)
				conquest:AddCommandPost(cp7)
				conquest:Start()
			end
		end
		
		-- return the unmanipulated values
		return unpack(RhenVar2CPFix_SPLreturn)
	end
end