-- [RDH]Zerted, August 10, 2008
-- AnthonyBF2, September 11, 2022
__fakeconsole_functions__ = 1
ff_autoBalance = 0
ff_blindJumps = 0
ff_heroSPRules = 0
ff_heroSPScript = 0
ff_chooseSides = 0
ff_menuSounds = 1
ff_displayTeamPoints = 0
ff_aiSpawn1 = 1
ff_aiSpawn2 = 1
ff_cpCapture = 1
ff_lockVehicles = 0
ff_tumbleRecovery = 0
ff_immuneToMines = 0
ff_fleeLikeHeros = 0
ff_hangerWalkthrough = 0
ff_hangerShootThrough = 0
ff_addedJetPacks = 0
ff_awardEffectsOn = 1
ff_forceViewOn = 0
ff_removedPointLimits = 0
ff_allowVictory = 1
local FF_ServerName = "v1.3: "
local FF_Crashes_ServerName = "Crashes: "
OldMissionVictory = nil
function ff_AddCommand(show, description, command, now)
    if show == nil then
        print("fakeconsole_functions: AddCommand: Show is nil")
        return
    elseif description == nil then
        local name = string.gsub(show, " ", "")
        if name == "" then
            name = "blank"
        end
        description = "mods.fakeconsole.description." .. name
    end
    if now ~= nil then
        if not now() then
            print("fakeconsole_functions: AddCommand: Not adding command: ", show)
            return
        end
    end
    table.insert(gConsoleCmdList, {ShowStr = show, info = description, run = command})
end
function ff_DoCommand(name)
    if name == nil then
        return
    end
    if gConsoleCmdList == nil then
        ff_rebuildFakeConsoleList()
    end
    if gConsoleCmdList == nil then
        return
    end
    local i
    for i = 1, table.getn(gConsoleCmdList) do
        if gConsoleCmdList[i].ShowStr == name then
            if gConsoleCmdList[i].run == nil then
                print("ff_DoCommand(): The FakeConsole command has no function to run:", name or "[Nil]")
                return
            end
            ff_serverDidFCCmd()
            gConsoleCmdList[i].run()
            return
        end
    end
    print("ff_DoCommand(): Unable to find FakeConsole command:", name or "[Nil]")
end
function ff_AskUser(title, follow, this)
    Popup_Prompt.fnDone = function(value)
        IFObj_fnSetVis(this.listbox, 1)
        Popup_Prompt:fnActivate(nil)
        Popup_Prompt.fnDone = nil
        if follow then
            follow(value)
        end
    end
    IFObj_fnSetVis(this.listbox, nil)
    Popup_Prompt:fnActivate(1)
    gPopup_fnSetTitleStr(Popup_Prompt, title or "[No Title]")
end
function ff_changeAIDamageThreshold(value)
    if value == nil then
        return
    end
    local teams = {1, 2}
    local miniFun = function(player, unit, property, value, teams)
        if (unit == nil) or (value == nil) then
            return
        end
        SetAIDamageThreshold(unit, value)
    end
    uf_applyFunctionOnTeamUnits(miniFun, nil, value, teams)
end
function ff_CommandAddJetPacks()
    ff_addedJetPacks = 1
    local properties = {
        {name = "ControlSpeed", value = "jet 10.85 1.85 2.00"},
        {name = "JetJump", value = "8.0"},
        {name = "JetPush", value = "8.0"},
        {name = "JetAcceleration", value = "20.0"},
        {name = "JetEffect", value = ""},
        {name = "JetType", value = "hover"},
        {name = "JetFuelRechangeRate", value = "1"},
        {name = "JetFuelCost", value = "0.0"},
        {name = "JetFuelInitialCost", value = "0.0"},
        {name = "JetFuelMinBorder", value = "0.0"}
    }
    uf_changeClassProperties(uf_classes, properties)
end
function ff_CommandSuperJump()
    local properties = {
        {name = "JumpFowardSpeedFactor", value = "8"},
        {name = "JumpStrafeSpeedFactor", value = "7"}
    }
    uf_changeClassProperties(uf_classes, properties)
end
function ff_CommandRemoveAwardEffects()
    ff_awardEffectsOn = 0
    local properties = {
        {name = "BuffHealthEffect", value = ""},
        {name = "BuffOffenseEffect", value = ""},
        {name = "BuffDefenseEffect", value = ""}
    }
    uf_changeClassProperties(uf_classes, properties)
end
function ff_CommandExtremePoints()
    local Player_Stats_Points = {
        {point_gain = 5},
        {point_gain = 5},
        {point_gain = 5},
        {point_gain = 0},
        {point_gain = -10},
        {point_gain = 30},
        {point_gain = 20},
        {point_gain = 10},
        {point_gain = 10},
        {point_gain = 10},
        {point_gain = 10},
        {point_gain = 10},
        {point_gain = 95},
        {point_gain = -95},
        {point_gain = 80},
        {point_gain = 80},
        {point_gain = 50},
        {point_gain = -40},
        {point_gain = 50},
        {point_gain = 30},
        {point_gain = 50},
        {point_gain = 50},
        {point_gain = 20},
        {point_gain = 20},
        {point_gain = 20},
        {point_gain = 10},
        {point_gain = 10},
        {point_gain = 20},
        {point_gain = 50},
        {point_gain = 30},
        {point_gain = 30},
        {point_gain = -95},
        {point_gain = 95},
        {point_gain = 25},
        {point_gain = 25}
    }
    ScriptCB_SetPlayerStatsPoints(Player_Stats_Points)
end
function ff_CommandSuperHighFlying()
    SetMaxFlyHeight(2000)
    SetMaxPlayerFlyHeight(2000)
end
function ff_CommandCrazyEnduranceRegen()
    local properties = {
        {name = "EnergyRestore", value = "1986"},
        {name = "EnergyRestoreIdle", value = "1986"}
    }
    uf_changeClassProperties(uf_classes, properties)
end
function ff_CommandSlowHealthRegen()
    ff_healthRegen(20)
end
function ff_CommandDenyCPCapture()
    ff_cpCapture = 0
    local properties = {
        {name = "CapturePosts", value = "0"}
    }
    uf_changeClassProperties(uf_classes, properties)
end
function ff_CommandUnlimitedReinforcements()
    SetReinforcementCount(1, -1)
    SetReinforcementCount(2, -1)
end
function ff_CommandUnlimitedTeamPoints()
    SetTeamPoints(1, -1234567890)
    SetTeamPoints(2, -1234567890)
end
function ff_CommandNoAIUnitDamage()
    ff_changeAIDamageThreshold(1)
end
function ff_healthRegen(rate, aiOrHuman)
    uf_changeObjectProperty("AddHealth", rate, aiOrHuman)
end
function ff_serverDoesNotCrash()
    uf_removeFromServerName(FF_Crashes_ServerName)
end
function ff_serverDoesCrash()
    ff_serverDoesNotCrash()
    uf_addToServerName(FF_Crashes_ServerName)
end
function ff_serverClearFCCmd()
    uf_removeFromServerName(FF_ServerName)
end
function ff_serverDidFCCmd()
    ff_serverClearFCCmd()
    uf_addToServerName(FF_ServerName)
end
function ff_localizeCommand(command)
    if command == nil then
        return "error"
    end
    local name = string.gsub(command, " ", "")
    if name == "" then
        name = "blank"
    end
    return "mods.fakeconsole." .. name
end
function ff_CommandPreventVictory()
    if not MissionVictory then
        print("ff_CommandPreventVictory(): WARNING: Could not find MissionVictory()")
        return
    end
    ff_allowVictory = 0
    OldMissionVictory = MissionVictory
    OldMissionDefeat = MissionDefeat
    MissionVictory = function(teams)
        print("ff_CommandPreventVictory(): Captured a MissinVictory() call")
    end
    MissionDefeat = function(teams)
        print("ff_CommandPreventVictory(): Captured a MissionDefeat() call")
    end
end
function ff_CommandAllowVictory()
    if not OldMissionVictory then
        print("ff_CommandAllowVictory(): WARNING: Could not find OldMissionVictory()")
        return
    end
    MissionVictory = OldMissionVictory
    MissionDefeat = OldMissionDefeat
    OldMissionVictory = nil
    OldMissionDefeat = nil
    ff_allowVictory = 1
end
function ff_rebuildFakeConsoleList()
    gConsoleCmdList = {}
    ScriptCB_GetConsoleCmds()
    table.insert(gConsoleCmdList, {ShowStr = ""})
    if SupportsCustomFCCommands and AddFCCommands ~= nil then
        print("ff_rebuildFakeConsoleList(): Adding in modder's custom commands...")
        ff_AddCommand("[Custom Map Commands]", nil, nil, nil)
        AddFCCommands()
        ff_AddCommand("", nil, nil, nil)
        print("ff_rebuildFakeConsoleList(): Finished adding in modder's custom commands.")
    end
    ff_AddCommand("[Utilities]", "General commands that do various things.", nil, nil)
    ff_AddCommand(
        "Exit To Windows",
        "Quit the game immediately.",
        function()
            ScriptCB_CloseNetShell()
            ScriptCB_QuitToWindows()
        end,
        nil
    )
    ff_AddCommand(
        "Return To Pause Menu",
        "Return to the pause menu.",
        function()
            ScriptCB_SndPlaySound("shell_menu_exit")
            ScriptCB_PopScreen()
        end,
        nil
    )
    -- ff_AddCommand(
        -- "Code Console",
        -- "", -- no desc because I'm too lazy to adjust the location of the code box so it doesn't overlap
        -- function()
            -- local temp = function(value)
                -- if not value then
                    -- return
                -- end
                -- local userFunction = loadstring(value)
                -- local result = pcall(userFunction)
            -- end
            -- ff_AskUser(
                -- "Type some valid Lua code for SWBFII and press enter.",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Change Your Online Name",
        -- "This lets you change your multiplayer name. Must rejoin current session, do not use Gamespy login. Does not work on Steam or GOG.",
        -- function()
            -- local temp = function(value)
                -- if not value then
                    -- return
                -- end
                -- if value == "" then
                    -- return
                -- end
                -- ScriptCB_SetNetLoginName(ScriptCB_tounicode(value))
            -- end
            -- ff_AskUser(
                -- "Please type the name you want to appear as in multiplayer. To get No Name simply put nothing. This doesn't work on Steam or GOG. Rejoin required.",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Player Vote Kicking",
        -- "This lets you call a vote to boot against any player in the multiplayer session.",
        -- function()
            -- local temp = function(value)
                -- if not value then
                    -- return
                -- end
                -- if value == "" then
                    -- return
                -- end
                -- ScriptCB_VoteKick(value)
            -- end
            -- ff_AskUser(
                -- "Please type the exact name of the player you wish to call a vote against.",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Change Online Server Name",
        -- "This will change your multiplayer session name. Anyone already joined won't be able to see the changed name.",
        -- function()
            -- local temp = function(value)
                -- if not value then
                    -- return
                -- end
                -- if value == "" then
                    -- return
                -- end
                -- ScriptCB_SetGameName(value)
            -- end
            -- ff_AskUser("Please enter a new name for your online session.", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "Clear Crashes From Server Name",
        "Remove the 'crashes' prefix from the current online session name.",
        function()
            ff_serverDoesNotCrash()
        end,
        nil
    )
    ff_AddCommand(
        "Common Commands",
        "Add Jetpacks, Super Jump, Remove Award Effects, Extreme Points, Max Fly Height, Energy Regeneration, Health Regeneration.",
        function()
            ff_CommandAddJetPacks()
            ff_CommandSuperJump()
            ff_CommandRemoveAwardEffects()
            ff_CommandExtremePoints()
            ff_CommandSuperHighFlying()
            ff_CommandCrazyEnduranceRegen()
            ff_CommandSlowHealthRegen()
        end,
        nil
    )
    ff_AddCommand(
        "Unending Match",
        "Deny CP Capture, Unlimited Reinforcements, Unlimited Points, No AI Damage, Block Victory.",
        function()
            ff_CommandDenyCPCapture()
            ff_CommandUnlimitedReinforcements()
            ff_CommandUnlimitedTeamPoints()
            ff_CommandNoAIUnitDamage()
            ff_CommandPreventVictory()
        end,
        nil
    )

		ff_AddCommand( "Team 1 +50 Reinforcements", nil, function()
			AddReinforcements(1, 50)
		end, nil)

		ff_AddCommand( "Team 2 +50 Reinforcements", nil, function()
			AddReinforcements(2, 50)
		end, nil)

		ff_AddCommand( "Team 1 -50 Reinforcements", nil, function()
			AddReinforcements(1, -50)
		end, nil)

		ff_AddCommand( "Team 2 -50 Reinforcements", nil, function()
			AddReinforcements(2, -50)
		end, nil)

		ff_AddCommand( "Team 1 +50 Points", nil, function()
			AddTeamPoints(1, 50)
		end, nil)

		ff_AddCommand( "Team 2 +50 Points", nil, function()
			AddTeamPoints(2, 50)
		end, nil)

		ff_AddCommand( "Team 1 -50 Points", nil, function()
			AddTeamPoints(1, -50)
		end, nil)

		ff_AddCommand( "Team 2 -50 Points", nil, function()
			AddTeamPoints(2, -50)
		end, nil)

    ff_AddCommand(
        "Force Humans Onto Team 1",
        "All human players will be forced onto team 1.",
        function()
            ForceHumansOntoTeam1(1)
        end,
        nil
    )
    ff_AddCommand(
        "No Points For All Actions",
        "Humans and bots will not score points for any actions.",
        function()
            local Player_Stats_Points = {
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0},
                {point_gain = 0}
            }
            ScriptCB_SetPlayerStatsPoints(Player_Stats_Points)
        end,
        nil
    )
    ff_AddCommand(
        "Normal Points For All Actions",
        "Humans and bots will earn normal points for all actions.",
        function()
            local Player_Stats_Points = {
                {point_gain = 1},
                {point_gain = 2},
                {point_gain = 1},
                {point_gain = -1},
                {point_gain = -2},
                {point_gain = 3},
                {point_gain = 2},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 10},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 5},
                {point_gain = 5},
                {point_gain = 2},
                {point_gain = 2},
                {point_gain = 2},
                {point_gain = 1},
                {point_gain = 1},
                {point_gain = 2},
                {point_gain = 10},
                {point_gain = 2},
                {point_gain = 2},
                {point_gain = -12},
                {point_gain = 10},
                {point_gain = 2},
                {point_gain = 2}
            }
            ScriptCB_SetPlayerStatsPoints(Player_Stats_Points)
        end,
        nil
    )
    ff_AddCommand(
        "Extreme Points For All Actions",
        "Humans and bots will earn a lot of points for all actions.",
        function()
            ff_CommandExtremePoints()
        end,
        nil
    )
    ff_AddCommand(
        "Team Auto-Assign On",
        "Activate auto-assign teams.",
        function()
            ff_chooseSides = 0
            ScriptCB_SetCanSwitchSides(false)
        end,
        function()
            return ff_chooseSides == 1
        end
    )
    ff_AddCommand(
        "Team Auto-Assign Off",
        "Disable auto-assign teams.",
        function()
            ff_chooseSides = 1
            ScriptCB_SetCanSwitchSides(true)
        end,
        function()
            return ff_chooseSides ~= 1
        end
    )
    ff_AddCommand(
        "Kill All Living AI + Humans",
        "All humans and bots currently alive will be killed.",
        function()
            uf_killUnits({1}, true)
            uf_killUnits({2}, true)
            uf_killUnits({1}, false)
            uf_killUnits({2}, false)
        end,
        nil
    )
    ff_AddCommand(
        "Kill All Humans On Team 1",
        "Kill all human players on team 1.",
        function()
            uf_killUnits({1}, false)
        end,
        nil
    )
    ff_AddCommand(
        "Kill All Humans On Team 2",
        "Kill all human players on team 2.",
        function()
            uf_killUnits({2}, false)
        end,
        nil
    )
    -- ff_AddCommand(
        -- "Add Reinforcements Team 1",
        -- "Add reinforcements for team 1.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- AddReinforcementCount(1, rate)
            -- end
            -- ff_AskUser("Please enter more reinforcements for team 1", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Add Reinforcements Team 2",
        -- "Add reinforcements for team 2.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- AddReinforcementCount(2, rate)
            -- end
            -- ff_AskUser("Please enter more reinforcements for team 2", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Set Reinforcements Team 1",
        -- "Set the reinforcements for team 1.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- SetReinforcementCount(1, rate)
            -- end
            -- ff_AskUser("Please enter the new reinforcement count for team 1", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Set Reinforcements Team 2",
        -- "Set the reinforcements for team 2.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- SetReinforcementCount(2, rate)
            -- end
            -- ff_AskUser("Please enter the new reinforcement count for team 2", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Add Points Team 1",
        -- "Set points to be added to team 1.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- AddTeamPoints(1, rate)
            -- end
            -- ff_AskUser("Please enter points to add to team 1.", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Add Points Team 2",
        -- "Set points to be added to team 2.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- AddTeamPoints(2, rate)
            -- end
            -- ff_AskUser("Please enter points to add to team 2.", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Set Team Points 1",
        -- "Set the current points for team 1.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- SetTeamPoints(1, rate)
            -- end
            -- ff_AskUser("Please enter the new team points for team 1", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Set Team Points 2",
        -- "Set the current points for team 2.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- SetTeamPoints(2, rate)
            -- end
            -- ff_AskUser("Please enter the new team points for team 2", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Add Units On Team 1",
        -- "Add units per team for team 1.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- SetUnitCount(1, GetUnitCount(1) + rate)
            -- end
            -- ff_AskUser(
                -- "Please enter the amount of units to add to team 1 (negative numbers allowed)",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Add Units On Team 2",
        -- "Add units per team for team 2.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- SetUnitCount(2, GetUnitCount(2) + rate)
            -- end
            -- ff_AskUser(
                -- "Please enter the amount of units to add to team 1 (negative numbers allowed)",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "Victory For Team 1",
        "Instant victory for team 1.",
        function()
            MissionVictory(1)
        end,
        function()
            return ff_allowVictory == 1
        end
    )
    ff_AddCommand(
        "Victory For Team 2",
        "Instant victory for team 2.",
        function()
            MissionVictory(2)
        end,
        function()
            return ff_allowVictory == 1
        end
    )
    ff_AddCommand(
        "Victory For Teams 1 + 2",
        "Instant victory for team 1 and team 2.",
        function()
            MissionVictory({1, 2})
        end,
        function()
            return ff_allowVictory == 1
        end
    )
    ff_AddCommand(
        "Prevent Victory",
        "Prevent victory.",
        function()
            ff_CommandPreventVictory()
        end,
        function()
            return ff_allowVictory == 1
        end
    )
    ff_AddCommand(
        "Allow Victory",
        "Allow victory.",
        function()
            ff_CommandAllowVictory()
        end,
        function()
            return ff_allowVictory ~= 1
        end
    )
    ff_AddCommand(
        "Teams 1 + 2 to Team 1",
        "Move both teams onto team 1.",
        function()
            uf_moveToTeam({1, 2}, 1)
        end,
        nil
    )
    ff_AddCommand(
        "Teams 1 + 2 to Team 2",
        "Move both teams onto team 2.",
        function()
            uf_moveToTeam({1, 2}, 2)
        end,
        nil
    )
    ff_AddCommand(
        "Teams 1 + 2 to Team 3",
        "Move both teams onto team 2.",
        function()
            uf_moveToTeam({1, 2}, 3)
        end,
        nil
    )
    ff_AddCommand(
        "Friends Team 1<>2",
        "Team 1 and team 2 will be friends.",
        function()
            SetTeamAsFriend(1, 2)
            SetTeamAsFriend(2, 1)
        end,
        nil
    )
    ff_AddCommand(
        "Friends Team 1<>3, 2<>3",
        "Teams 1 + 3 will be friends and teams 2 + 3 will be friends.",
        function()
            SetTeamAsFriend(1, 3)
            SetTeamAsFriend(3, 1)
            SetTeamAsFriend(2, 3)
            SetTeamAsFriend(3, 2)
        end,
        nil
    )
    ff_AddCommand(
        "Friends Team 1<>1, 2<>2, 3<>3",
        "Teams 1, 2, ad 3 will be friends of themselves.",
        function()
            SetTeamAsFriend(1, 1)
            SetTeamAsFriend(2, 2)
            SetTeamAsFriend(3, 3)
        end,
        nil
    )
    ff_AddCommand(
        "Enemies Team 1<>2",
        "Team 1 and team 2 will be enemies.",
        function()
            SetTeamAsEnemy(1, 2)
            SetTeamAsEnemy(2, 1)
        end,
        nil
    )
    ff_AddCommand(
        "Enemies Team 1<>3, 2<>3",
        "Teams 1 + 3 will be enemies and teams 2 + 3 will be enemies.",
        function()
            SetTeamAsEnemy(1, 3)
            SetTeamAsEnemy(3, 1)
            SetTeamAsEnemy(2, 3)
            SetTeamAsEnemy(3, 2)
        end,
        nil
    )
    ff_AddCommand(
        "Enemies Team 1<>1, 2<>2, 3<>3",
        "Team 1, 2, and 3 will be enemies of themselves.",
        function()
            SetTeamAsEnemy(1, 1)
            SetTeamAsEnemy(2, 2)
            SetTeamAsEnemy(3, 3)
        end,
        nil
    )
    ff_AddCommand(
        "Print Map Camera Position",
        "Print camera position while using the debugger game version.",
        function()
            local x, y, z = GetMapCameraPosition()
            print("FakeConsole: Map Camera Position: X:", x)
            print("FakeConsole: Map Camera Position: Y:", y)
            print("FakeConsole: Map Camera Position: Z:", z)
        end,
        nil
    )
    ff_AddCommand(
        "Print Globals",
        "Print global data.",
        function()
            uf_print(_G, false, 0)
        end,
        nil
    )
    ff_AddCommand(
        "Print Globals Nested",
        "Print nester global data. The game will freeze for a moment.",
        function()
            uf_print(_G, true, 0)
        end,
        nil
    )
    ff_AddCommand(
        "Minimize Your Game",
        "This will shrink the running game so you can return to Windows, click the clone head icon to resume game.",
        function()
            ScriptCB_MinimizeWindow()
        end
    )
    ff_AddCommand(
        "Restart Mission",
        "This will restart the current match. if you are the host in multiplayer, anyone connected to your session will disconnect.",
        function()
            ScriptCB_RestartMission()
        end
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand(
        "[Your Screen Only]",
        "These only visually change for you. Other players online won't see these changes.",
        nil,
        nil
    )
    ff_AddCommand(
        "Heroes With Turret Icons",
        "This will give all hero classes the turret icon. Only you will see this.",
        function()
            SetClassProperty("all_hero_luke_jedi", "MapTexture", "turret_icon")
            SetClassProperty("all_hero_hansolo_tat", "MapTexture", "turret_icon")
            SetClassProperty("all_hero_leia", "MapTexture", "turret_icon")
            SetClassProperty("all_hero_chewbacca", "MapTexture", "turret_icon")
            SetClassProperty("imp_hero_darthvader", "MapTexture", "turret_icon")
            SetClassProperty("imp_hero_emperor", "MapTexture", "turret_icon")
            SetClassProperty("imp_hero_bobafett", "MapTexture", "turret_icon")
            SetClassProperty("rep_hero_yoda", "MapTexture", "turret_icon")
            SetClassProperty("rep_hero_macewindu", "MapTexture", "turret_icon")
            SetClassProperty("rep_hero_anakin", "MapTexture", "turret_icon")
            SetClassProperty("rep_hero_aalya", "MapTexture", "turret_icon")
            SetClassProperty("rep_hero_kiyadimundi", "MapTexture", "turret_icon")
            SetClassProperty("rep_hero_obiwan", "MapTexture", "turret_icon")
            SetClassProperty("cis_hero_grievous", "MapTexture", "turret_icon")
            SetClassProperty("cis_hero_darthmaul", "MapTexture", "turret_icon")
            SetClassProperty("cis_hero_countdooku", "MapTexture", "turret_icon")
            SetClassProperty("cis_hero_jangofett", "MapTexture", "turret_icon")
        end
    )
    ff_AddCommand(
        "Heroes With Normal Icons",
        "This will give all hero classes the standard triangle icon. Only you will see this.",
        function()
            SetClassProperty("all_hero_luke_jedi", "MapTexture", "troop_icon")
            SetClassProperty("all_hero_hansolo_tat", "MapTexture", "troop_icon")
            SetClassProperty("all_hero_leia", "MapTexture", "troop_icon")
            SetClassProperty("all_hero_chewbacca", "MapTexture", "troop_icon")
            SetClassProperty("imp_hero_darthvader", "MapTexture", "troop_icon")
            SetClassProperty("imp_hero_emperor", "MapTexture", "troop_icon")
            SetClassProperty("imp_hero_bobafett", "MapTexture", "troop_icon")
            SetClassProperty("rep_hero_yoda", "MapTexture", "troop_icon")
            SetClassProperty("rep_hero_macewindu", "MapTexture", "troop_icon")
            SetClassProperty("rep_hero_anakin", "MapTexture", "troop_icon")
            SetClassProperty("rep_hero_aalya", "MapTexture", "troop_icon")
            SetClassProperty("rep_hero_kiyadimundi", "MapTexture", "troop_icon")
            SetClassProperty("rep_hero_obiwan", "MapTexture", "troop_icon")
            SetClassProperty("cis_hero_grievous", "MapTexture", "troop_icon")
            SetClassProperty("cis_hero_darthmaul", "MapTexture", "troop_icon")
            SetClassProperty("cis_hero_countdooku", "MapTexture", "troop_icon")
            SetClassProperty("cis_hero_jangofett", "MapTexture", "troop_icon")
        end
    )
    -- ff_AddCommand(
        -- "Square Radar Texture",
        -- "This will dump the 'map_mask' texture from memory so the radar will be the full sqaure.",
        -- function()
            -- ScriptCB_RemoveTexture("map_mask")
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "Force 3rd Person View",
        "Force infantry into 3rd person view.",
        function()
            ff_forceViewOn = 1
            local properties = {
                {name = "ForceMode", value = 1}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_forceViewOn ~= 1
        end
    )
    ff_AddCommand(
        "Force No Views",
        "Do not force a specific view for infantry.",
        function()
            ff_forceViewOn = 0
            local properties = {
                {name = "ForceMode", value = 0}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_forceViewOn == 1
        end
    )
    -- ff_AddCommand(
        -- "Change Field Of View",
        -- "Change the field of view for 3rd person and 1st person.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "FirstPersonFOV", value = rate},
                    -- {name = "ThirdPersonFOV", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser("Please enter the new 'field of view' angle", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "Menu Sounds Off",
        "Disable menu sounds and click sounds.",
        function()
            ff_menuSounds = 0
            ScriptCB_SoundDisable()
        end,
        function()
            return ff_menuSounds == 1
        end
    )
    ff_AddCommand(
        "Menu Sounds On",
        "Enable menu sounds and click sounds.",
        function()
            ff_menuSounds = 1
            ScriptCB_SoundEnable()
        end,
        function()
            return ff_menuSounds ~= 1
        end
    )
    ff_AddCommand(
        "Normal Character Deaths",
        "Characters will not kneel when dead.",
        function()
            ff_fleeLikeHeros = 0
            local properties = {
                {name = "FleeLikeAHero", value = "0"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_fleeLikeHeros == 1
        end
    )
    ff_AddCommand(
        "Hero Character Deaths",
        "Characters will kneel when dead.",
        function()
            ff_fleeLikeHeros = 1
            local properties = {
                {name = "FleeLikeAHero", value = "1"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_fleeLikeHeros ~= 1
        end
    )
    ff_AddCommand(
        "Remove Point Limits",
        "Unlock all characters without earning points.",
        function()
            ff_removedPointLimiets = 1
            local properties = {
                {name = "PointsToUnlock", value = "0"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_removedPointLimits ~= 1
        end
    )
    ff_AddCommand(
        "Remove Award Effects",
        "Remove the red and blue glow + sounds from earned awards.",
        function()
            ff_CommandRemoveAwardEffects()
        end,
        function()
            return ff_awardEffectsOn == 1
        end
    )
    ff_AddCommand(
        "Restore Award Effects",
        "Restore the red and blue glow + sounds from earned awards.",
        function()
            ff_awardEffectsOn = 1
            local properties = {
                {name = "BuffHealthEffect", value = "com_sfx_buffed_regen"},
                {name = "BuffOffenseEffect", value = "com_sfx_buffed_offense"},
                {name = "BuffDefenseEffect", value = "com_sfx_buffed_defense"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_awardEffectsOn ~= 1
        end
    )
    ff_AddCommand(
        "Disable Small Minimap",
        "Turn off the small radar in the top right of the game HUD.",
        function()
            DisableSmallMapMiniMap()
        end,
        nil
    )
    ff_AddCommand(
        "Hide Team Points",
        "Hide team points from the HUD.",
        function()
            ff_displayTeamPoints = 0
            ShowTeamPoints(1, false)
            ShowTeamPoints(2, false)
        end,
        function()
            return ff_displayTeamPoints == 1
        end
    )
    ff_AddCommand(
        "Display Team Points",
        "Show team points in the HUD.",
        function()
            ff_displayTeamPoints = 1
            ShowTeamPoints(1, true)
            ShowTeamPoints(2, true)
        end,
        function()
            return ff_displayTeamPoints ~= 1
        end
    )
    -- ff_AddCommand(
        -- "Character Icon Scale",
        -- "Determine how big character icons will be on the radar. Respawn or switch class needed.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "MapScale", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser(
                -- "Enter a number to determine how big all character icons become on the radar. 0.0 would be no icons. Default is 1.4",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Small Radar Depth",
        -- "Determine the zoom distance in the small radar.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "MapViewMin", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser(
                -- "Enter a number to determine how much of the small radar you'll see. Default value is 0.",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[AI Commands]", "Various commands for manipulating AI bots.", nil, nil)
		ff_AddCommand( "Set Bots Per Team - 0", nil, function()
			ScriptCB_SetNumBots(0)
		end, nil)
		ff_AddCommand( "Set Bots Per Team - 8", nil, function()
			ScriptCB_SetNumBots(8)
		end, nil)
		ff_AddCommand( "Set Bots Per Team - 16", nil, function()
			ScriptCB_SetNumBots(16)
		end, nil)
		ff_AddCommand( "Set Bots Per Team - 32", nil, function()
			ScriptCB_SetNumBots(32)
		end, nil)
    ff_AddCommand(
        "Enemy AI Follow",
        "Enemy AI bots will follow the human player.",
        function()
            local team = GetCharacterTeam(0)
            team = uf_GetOtherTeam(team)
            if team == nil then
                return
            end
            AddAIGoal(team, "follow", 100, 0)
        end,
        function()
            return not ScriptCB_InNetGame()
        end
    )
    ff_AddCommand(
        "Friendly AI Follow",
        "Team AI bots will follow the human player.",
        function()
            local team = GetCharacterTeam(0)
            AddAIGoal(team, "follow", 100, 0)
        end,
        function()
            return not ScriptCB_InNetGame()
        end
    )
    ff_AddCommand(
        "Enemy AI Teleport",
        "Enemy AI bots will teleport to the human player.",
        function()
            local toPlayer = GetCharacterUnit(0)
            local team = GetCharacterTeam(0)
            if toPlayer == nil then
                return
            end
            team = uf_GetOtherTeam(team)
            if team == nil then
                return
            end
            local miniFun = function(player, unit, toPlayer, value)
                if (unit == nil) or (toPlayer == nil) then
                    return
                end
                local to = GetEntityMatrix(toPlayer)
                SetEntityMatrix(unit, to)
            end
            uf_applyFunctionOnTeamUnits(miniFun, toPlayer, value, {team})
        end,
        function()
            return not ScriptCB_InNetGame()
        end
    )
    ff_AddCommand(
        "Friendly AI Teleport",
        "Team AI bots will teleport to the human player.",
        function()
            local toPlayer = GetCharacterUnit(0)
            local team = GetCharacterTeam(0)
            if toPlayer == nil then
                return
            end
            local miniFun = function(player, unit, toPlayer, value)
                if (unit == nil) or (toPlayer == nil) then
                    return
                end
                local to = GetEntityMatrix(toPlayer)
                SetEntityMatrix(unit, to)
            end
            uf_applyFunctionOnTeamUnits(miniFun, toPlayer, value, {team})
        end,
        function()
            return not ScriptCB_InNetGame()
        end
    )
    -- ff_AddCommand(
        -- "Health Regen For AI",
        -- "Determine health regeneration for AI bots.",
        -- function()
            -- local temp = function(value)
                -- if not value then
                    -- return
                -- end
                -- ff_healthRegen(value, "ai")
            -- end
            -- ff_AskUser(
                -- "Please enter a health regeneration rate (health units per second).  Negative rates cause damage",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "AI Damage Threshold",
        -- "Determine damage percent AI bots can give to human players.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- ff_changeAIDamageThreshold(rate)
            -- end
            -- ff_AskUser("Please enter the AI damage threshold (range from 0 to 1, default is 0)", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "Disallow AI Spawn Team 1",
        "Block AI bots from spawning on team 1.",
        function()
            ff_aiSpawn1 = 0
            AllowAISpawn(1, false)
        end,
        function()
            return ff_aiSpawn1 == 1
        end
    )
    ff_AddCommand(
        "Allow AI Spawn Team 1",
        "Allow AI bots to spawn on team 1.",
        function()
            ff_aiSpawn1 = 1
            AllowAISpawn(1, true)
        end,
        function()
            return ff_aiSpawn1 ~= 1
        end
    )
    ff_AddCommand(
        "Disallow AI Spawn Team 2",
        "Block AI bots from spawning on team 2.",
        function()
            ff_aiSpawn2 = 0
            AllowAISpawn(2, false)
        end,
        function()
            return ff_aiSpawn2 == 1
        end
    )
    ff_AddCommand(
        "Allow AI Spawn Team 2",
        "Allow AI bots to spawn on team 2.",
        function()
            ff_aiSpawn2 = 1
            AllowAISpawn(2, true)
        end,
        function()
            return ff_aiSpawn2 ~= 1
        end
    )
    ff_AddCommand(
        "AI Goals Clear",
        "Clear AI goals. Bots may stop spawning.",
        function()
            ClearAIGoals(1)
            ClearAIGoals(2)
        end,
        nil
    )
    ff_AddCommand(
        "AI Goals Conquest",
        "AI bots will seek to capture command posts.",
        function()
            AddAIGoal(1, "conquest", 1000)
            AddAIGoal(2, "conquest", 1000)
        end,
        nil
    )
    ff_AddCommand(
        "AI Goals Deathmatch",
        "AI bots will focus on killing enemies.",
        function()
            AddAIGoal(1, "deathmatch", 1000)
            AddAIGoal(2, "deathmatch", 1000)
        end,
        nil
    )
    ff_AddCommand(
        "Kill All AI Bots Team 1",
        "Kill all living AI bots on team 1.",
        function()
            uf_killUnits({1}, true)
        end,
        nil
    )
    ff_AddCommand(
        "Kill All AI Bots Team 2",
        "Kill all living AI bots on team 2.",
        function()
            uf_killUnits({2}, true)
        end,
        nil
    )
    -- ff_AddCommand(
        -- "Number Of Bots Per Team",
        -- "Determine number of bots per team allowed to spawn.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- ScriptCB_SetNumBots(rate)
            -- end
            -- ff_AskUser("Please enter the max amount of bots allowed ingame", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "AI AutoBalance Off",
        "Disable AI Auto-Balance.",
        function()
            ff_autoBalance = 0
            DisableAIAutoBalance()
        end,
        function()
            return ff_autoBalance == 1
        end
    )
    ff_AddCommand(
        "AI AutoBalance On",
        "Enable AI Auto-Balance.",
        function()
            ff_autoBalance = 1
            EnableAIAutoBalance()
        end,
        function()
            return ff_autoBalance ~= 1
        end
    )
    ff_AddCommand(
        "AI BlindJetJumps Off",
        "Disallow AI jet troopers to fly randomly.",
        function()
            ff_blindJumps = 0
            SetAllowBlindJetJumps(0)
        end,
        function()
            return ff_blindJumps == 1
        end
    )
    ff_AddCommand(
        "AI BlindJetJumps On",
        "Allow AI jet troopers to fly randomly.",
        function()
            ff_blindJumps = 1
            SetAllowBlindJetJumps(1)
        end,
        function()
            return ff_blindJumps ~= 1
        end
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[Physics Commands]", "Various commands that determine physics of characters.", nil, nil)
		ff_AddCommand( "Super Jump", nil, function()
			ff_serverDoesCrash()
			local properties = {
			    { name = "JumpHeight", 		value = "15.0" },
			    { name = "JumpFowardSpeedFactor", value = "5" },
			}
			uf_changeClassProperties( uf_classes, properties )
		end, nil)

		ff_AddCommand( "Super Rolling", nil, function()
			ff_serverDoesCrash()
			local properties = {
			    { name = "RollSpeedFactor", 		value = "3.0" },
			}
			uf_changeClassProperties( uf_classes, properties )
		end, nil)


		ff_AddCommand( "Super Moving", nil, function()
			ff_serverDoesCrash()
			local properties = {
			    { name = "MaxSpeed", 		value = "15.0" },
			}
			uf_changeClassProperties( uf_classes, properties )
		end, nil)
		
		ff_AddCommand( "Super Energy", nil, function()
			ff_serverDoesCrash()
			local properties = {
			    { name = "EnergyBar", 		value = "1000.0" },
				{ name = "EnergyRestore", 		value = "500.0" },
			}
			uf_changeClassProperties( uf_classes, properties )
		end, nil)
    ff_AddCommand(
        "Disable Tumble Recovery",
        "Disable moving after getting pushed.",
        function()
            ff_tumbleRecovery = 0
            local properties = {
                {name = "RecoverFromTumble", value = "0"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_tumbleRecovery == 1
        end
    )
    ff_AddCommand(
        "Enable Tumble Recovery",
        "Enable moving after getting pushed.",
        function()
            ff_tumbleRecovery = 1
            local properties = {
                {name = "RecoverFromTumble", value = "1"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_tumbleRecovery ~= 1
        end
    )
    ff_AddCommand(
        "Add JetPacks To Characters",
        "Add jetpacks to all characters. There will be no visual effects.",
        function()
            ff_CommandAddJetPacks()
        end,
        function()
            return ff_addedJetPacks ~= 1
        end
    )
    ff_AddCommand(
        "Jedi Jumps For Characters",
        "Allow all characters to jump like jedi characters.",
        function()
            local properties = {
                {name = "ControlSpeed", value = "jet 2.0 1,25 1.25"},
                {name = "JetJump", value = "10.0"},
                {name = "JetPush", value = "0.0"},
                {name = "JetAcceleration", value = "10.0"},
                {name = "JetEffect", value = ""},
                {name = "JetFuelRechangeRate", value = "0.0"},
                {name = "JetFuelCost", value = "0.0"},
                {name = "JetFuelInitialCost", value = "0.0"},
                {name = "JetFuelMinBorder", value = "0.0"},
                {name = "JetShowHud", value = "0"},
                {name = "JetEnergyDrain", value = "40"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "Super Jump For Characters",
        "Enable high jumping for all characters.",
        function()
            ff_CommandSuperJump()
        end,
        nil
    )
    ff_AddCommand(
        "Normal Jump For Characters",
        "Enable normal jumping for all characters.",
        function()
            local properties = {
                {name = "JumpHeight", value = "1.78"},
                {name = "JumpFowardSpeedFactor", value = "1.3"},
                {name = "JumpStrafeSpeedFactor", value = "1.0"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "Low Character Speeds",
        "Low movement speeds for all characters.",
        function()
            local properties = {
                {name = "ControlSpeed", value = "stand 0.50 0.50 0.50"},
                {name = "ControlSpeed", value = "crouch 0.35 0.30 0.25"},
                {name = "ControlSpeed", value = "sprint 0.75 0.25 0.18"},
                {name = "ControlSpeed", value = "roll 0.01 0.01 0.18"},
                {name = "ControlSpeed", value = "tumble 0.00 0.00 0.05"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "Normal Character Speeds",
        "Normal movement speeds for all characters.",
        function()
            local properties = {
                {name = "ControlSpeed", value = "stand 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "crouch 0.70 0.60 0.50"},
                {name = "ControlSpeed", value = "sprint 1.50 0.50 0.35"},
                {name = "ControlSpeed", value = "roll 0.02 0.02 0.35"},
                {name = "ControlSpeed", value = "tumble 0.00 0.00 0.10"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "High Character Speeds",
        "Fast movement speeds for all characters.",
        function()
            local properties = {
                {name = "ControlSpeed", value = "stand 2.00 2.00 2.00"},
                {name = "ControlSpeed", value = "crouch 1.40 1.20 1.00"},
                {name = "ControlSpeed", value = "sprint 3.00 1.00 0.70"},
                {name = "ControlSpeed", value = "roll 0.04 0.04 0.70"},
                {name = "ControlSpeed", value = "tumble 0.00 0.00 0.20"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    -- ff_AddCommand(
        -- "Sprint Energy Usage",
        -- "Determine how much energy is used for sprinting for characters.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "EnergyDrainSprint", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser(
                -- "Please enter the amount of endurance to use while sprinting (energy units per second)",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "Full Control For Characters",
        "Full controls for all characters.",
        function()
            local properties = {
                {name = "ControlSpeed", value = "stand 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "crouch 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "prone 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "sprint 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "jet 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "roll 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "tumble 1.00 1.00 1.00"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "High Control For Characters",
        "High controls for all characters.",
        function()
            local properties = {
                {name = "ControlSpeed", value = "stand 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "crouch 1.25 1.25 1.25"},
                {name = "ControlSpeed", value = "prone 0.30 0.20 0.50"},
                {name = "ControlSpeed", value = "sprint 2.50 2.50 2.50"},
                {name = "ControlSpeed", value = "jet 1.75 1.75 1.75"},
                {name = "ControlSpeed", value = "roll 0.50 0.50 1.35"},
                {name = "ControlSpeed", value = "tumble 1.00 1.00 1.00"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "Normal Control For Characters",
        "Normal controls for all characters.",
        function()
            local properties = {
                {name = "ControlSpeed", value = "stand 1.00 1.00 1.00"},
                {name = "ControlSpeed", value = "crouch 0.70 0.60 1.00"},
                {name = "ControlSpeed", value = "prone 0.30 0.20 0.50"},
                {name = "ControlSpeed", value = "sprint 2.50 0.50 0.50"},
                {name = "ControlSpeed", value = "jet 1.50 1.25 1.25"},
                {name = "ControlSpeed", value = "roll 0.02 0.02 0.35"},
                {name = "ControlSpeed", value = "tumble 0.00 0.00 0.10"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "Poor Control For Characters",
        "Weak controls for all characters.",
        function()
            local properties = {
                {name = "ControlSpeed", value = "stand 0.50 0.50 0.50"},
                {name = "ControlSpeed", value = "crouch 0.35 0.30 0.50"},
                {name = "ControlSpeed", value = "prone 0.15 0.10 0.25"},
                {name = "ControlSpeed", value = "sprint 1.25 0.25 0.25"},
                {name = "ControlSpeed", value = "jet 0.75 0.62 0.62"},
                {name = "ControlSpeed", value = "roll 0.01 0.01 0.17"},
                {name = "ControlSpeed", value = "tumble 0.00 0.00 0.05"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    -- ff_AddCommand(
        -- "Health Regen Humans + Bots",
        -- "Determine health regeneration for all bots and humans.",
        -- function()
            -- local temp = function(value)
                -- if not value then
                    -- return
                -- end
                -- ff_healthRegen(value, nil)
            -- end
            -- ff_AskUser(
                -- "Please enter a health regeneration rate (health units per second).  Negative rates cause damage",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Health Regen For Humans",
        -- "Determine health regeneration for all humans.",
        -- function()
            -- local temp = function(value)
                -- if not value then
                    -- return
                -- end
                -- ff_healthRegen(value, "human")
            -- end
            -- ff_AskUser(
                -- "Please enter a health regeneration rate (health units per second).  Negative rates cause damage",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Endurance Regen For Characters",
        -- "Determine energy restore rate for all characters.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "EnergyRestore", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser("Please enter an endurance regeneration rate (energy units per second)", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Idle Endurance Regen For Characters",
        -- "Determine energy restore rate for all characters while not moving.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "EnergyRestoreIdle", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser(
                -- "Please enter an idle endurance regeneration rate (energy units per second)",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Fall Damage For Characters",
        -- "Determine amount of collision damage for all characters.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "CollisionScale", value = rate .. " " .. rate .. " " .. rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser("Please enter the fall damage's collision scale", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "No Jump For Characters",
        "Disable jumping for all characters.",
        function()
            ff_serverDoesCrash()
            local properties = {
                {name = "JumpHeight", value = "0"},
                {name = "JumpFowardSpeedFactor", value = "0"},
                {name = "JumpStrafeSpeedFactor", value = "0"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "High Jump For Characters",
        "High jumps for all characters.",
        function()
            ff_serverDoesCrash()
            local properties = {
                {name = "JumpHeight", value = "15.8"},
                {name = "JumpFowardSpeedFactor", value = "8"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        nil
    )
    ff_AddCommand(
        "Remove JetPacks From Characters",
        "Remove jetpack flying ability from all characters.",
        function()
            ff_serverDoesCrash()
            ff_addedJetPacks = 0
            local properties = {
                {name = "ControlSpeed", value = "jet 0.01 0.01 0.01"},
                {name = "JetJump", value = "0.1"},
                {name = "JetPush", value = "0"},
                {name = "JetAcceleration", value = "0"},
                {name = "JetType", value = "hover"},
                {name = "JetFuelRechangeRate", value = "0"},
                {name = "JetFuelCost", value = "50"},
                {name = "JetFuelInitialCost", value = "50"},
                {name = "JetFuelMinBorder", value = "50"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_addedJetPacks == 1
        end
    )
    -- ff_AddCommand(
        -- "Rolling Boost For Characters",
        -- "Determine rolling speed and boost for all characters.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "RollSpeedFactor", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser("Enter a number to change rolling distance and speed. Default is 1.5", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Collision Damage For Characters",
        -- "Determine damage for character collision.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "CollisionScale", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser(
                -- "Enter a number to change how much damage you'll take from falling and hitting things. 0.0 Sets no collision damage.",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Forward Moving Speed For Characters",
        -- "Determine forward movement speed for all characters.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- local properties = {
                    -- {name = "MaxSpeed", value = rate}
                -- }
                -- uf_changeClassProperties(uf_classes, properties)
            -- end
            -- ff_AskUser(
                -- "Enter a number for how fast you can move and run forward. Default is about 1.5",
                -- temp,
                -- ifs_fakeconsole
            -- )
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "Bodies Do Not Fade",
        "Dead bodies remain on the map, too many bodies prevents humans and AI bots from respawning.",
        function()
            OnObjectKill(
                function(object, killer)
                    DeactivateObject(object)
                end
            )
        end
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[Map Commands]", nil, nil, nil)
		ff_AddCommand( "Max Fly Height 0", nil, function()
			SetMaxFlyHeight(0)
			SetMaxPlayerFlyHeight(0)
		end, nil)

		ff_AddCommand( "Max Fly Height 5000", nil, function()
			SetMaxFlyHeight(5000)
			SetMaxPlayerFlyHeight(5000)
		end, nil)
    ff_AddCommand(
        "Deny CP Capture",
        "Block all characters from capturing command posts.",
        function()
            ff_CommandDenyCPCapture()
        end,
        function()
            return ff_cpCapture == 1
        end
    )
    ff_AddCommand(
        "Allow CP Capture",
        "Allow all characters to capture command posts.",
        function()
            ff_cpCapture = 1
            local properties = {
                {name = "CapturePosts", value = "1"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_cpCapture ~= 1
        end
    )
    ff_AddCommand(
        "Walkthrough Hanger Shields",
        "Hangar shields will not have character collision.",
        function()
            ff_hangerWalkthrough = 1
            local properties = {
                {name = "SoldierCollision", value = "CLEAR"}
            }
            local shields = {
                "all_cap_rebelcruiser_shield",
                "cis_fedcruiser_shield_blue",
                "rep_assultship_shield_red",
                "imp_cap_stardestroyer_shield",
                "pol1_prop_health_shield",
                "pol1_prop_hanger_shield",
                "pol1_prop_cavern_shield",
                "Pol_prop_shield"
            }
            uf_changeClassProperties(shields, properties)
        end,
        function()
            return ff_hangerWalkthrough ~= 1
        end
    )
    ff_AddCommand(
        "Hanger Shields Allow Fire",
        "Hangar shields will not have ordnance collision.",
        function()
            ff_hangerShootThrough = 1
            local properties = {
                {name = "OrdnanceCollision", value = "CLEAR"}
            }
            local shields = {
                "all_cap_rebelcruiser_shield",
                "cis_fedcruiser_shield_blue",
                "rep_assultship_shield_red",
                "imp_cap_stardestroyer_shield",
                "pol1_prop_health_shield",
                "pol1_prop_hanger_shield",
                "pol1_prop_cavern_shield",
                "Pol_prop_shield"
            }
            uf_changeClassProperties(shields, properties)
        end,
        function()
            return ff_hangerShootThrough ~= 1
        end
    )
    -- ff_AddCommand(
        -- "Map Fly Height Max",
        -- "Determine how high humans and bots can fly.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- SetMaxFlyHeight(rate)
                -- SetMaxPlayerFlyHeight(rate)
            -- end
            -- ff_AskUser("Please enter the hight of the map", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    -- ff_AddCommand(
        -- "Map Fly Height Min",
        -- "Determine how low humans and bots can fly.",
        -- function()
            -- local temp = function(rate)
                -- if not rate then
                    -- return
                -- end
                -- SetMinFlyHeight(rate)
                -- SetMinPlayerFlyHeight(rate)
            -- end
            -- ff_AskUser("Please enter the lowest 'level' of the map (negative values preferred)", temp, ifs_fakeconsole)
        -- end,
        -- nil
    -- )
    ff_AddCommand(
        "Lock All Doors",
        "This locks all the doors in Death Star, Kamino, Mustafar, Polis Massa, and Tantive.",
        function()
            SetProperty("tan4_prop_door5", "IsLocked", 1)
            SetProperty("tan4_prop_door4", "IsLocked", 1)
            SetProperty("tan4_prop_door1", "IsLocked", 1)
            SetProperty("rpodroom2", "IsLocked", 1)
            SetProperty("rpodroom1f", "IsLocked", 1)
            SetProperty("rpodroom1", "IsLocked", 1)
            SetProperty("lpodroom3", "IsLocked", 1)
            SetProperty("lpodroom2", "IsLocked", 1)
            SetProperty("lpodroom1", "IsLocked", 1)
            SetProperty("engine01", "IsLocked", 1)
            SetProperty("blasteng2", "IsLocked", 1)
            SetProperty("blasteng1", "IsLocked", 1)
            SetProperty("blastbar1", "IsLocked", 1)
            SetProperty("techroom1", "IsLocked", 1)
            SetProperty("techroom2", "IsLocked", 1)
            SetProperty("tan4_prop_door_minus_darkside", "IsLocked", 1)
            SetProperty("dea1_prop_door_blast", "IsLocked", 1)
            SetProperty("dea1_prop_door_blast0", "IsLocked", 1)
            SetProperty("dea1_bldg_falcon_hanger_doorside", "IsLocked", 1)
            SetProperty("dea1_prop_garbage_room_door", "IsLocked", 1)
            SetProperty("dea1_prop_door_blast1", "IsLocked", 1)
            SetProperty("dea1_prop_door_ajar", "IsLocked", 1)
            SetProperty("dr-leftmain", "IsLocked", 1)
            SetProperty("dea1_prop_door0", "IsLocked", 1)
            SetProperty("door1", "IsLocked", 1)
            SetProperty("door2", "IsLocked", 1)
            SetProperty("fdu-2", "IsLocked", 1)
            SetProperty("kam_bldg_podroom_door20", "IsLocked", 1)
            SetProperty("kam_bldg_podroom_door32", "IsLocked", 1)
            SetProperty("fdl-3", "IsLocked", 1)
            SetProperty("fdl-1", "IsLocked", 1)
            SetProperty("fdu-3", "IsLocked", 1)
            SetProperty("fdu-1", "IsLocked", 1)
            SetProperty("kam_bldg_podroom_door24", "IsLocked", 1)
            SetProperty("open", "IsLocked", 1)
            SetProperty("kam_bldg_podroom_door28", "IsLocked", 1)
            SetProperty("fdl-2", "IsLocked", 1)
            SetProperty("kam_bldg_podroom_door27", "IsLocked", 1)
            SetProperty("kam_bldg_blast_door3", "IsLocked", 1)
            SetProperty("kam_bldg_blast_door1", "IsLocked", 1)
            SetProperty("kam_bldg_blast_door", "IsLocked", 1)
            SetProperty("kam_bldg_blast_door2", "IsLocked", 1)
            SetProperty("door_cont_1", "IsLocked", 1)
            SetProperty("door_cont_3", "IsLocked", 1)
            SetProperty("door_cont_9", "IsLocked", 1)
            SetProperty("mus1_prop_door_garage5", "IsLocked", 1)
            SetProperty("mus1_prop_door_garage6", "IsLocked", 1)
            SetProperty("hangardoor", "IsLocked", 1)
            SetProperty("door_cont_4", "IsLocked", 1)
            SetProperty("win2", "IsLocked", 1)
            SetProperty("mus1_prop_door_garage7", "IsLocked", 1)
            SetProperty("door_cont_11", "IsLocked", 1)
            SetProperty("door_cont_7", "IsLocked", 1)
            SetProperty("door_cont_6", "IsLocked", 1)
            SetProperty("mus1_prop_door_garage3", "IsLocked", 1)
            SetProperty("mus1_prop_door_garage1", "IsLocked", 1)
            SetProperty("door_cont_2", "IsLocked", 1)
            SetProperty("d", "IsLocked", 1)
            SetProperty("drop", "IsLocked", 1)
            SetProperty("door_cont_8", "IsLocked", 1)
            SetProperty("window", "IsLocked", 1)
            SetProperty("mus1_prop_window7", "IsLocked", 1)
            SetProperty("mus1_prop_window8", "IsLocked", 1)
            SetProperty("mus1_bldg_hallway_window", "IsLocked", 1)
            SetProperty("airlock02", "IsLocked", 1)
            SetProperty("airlock01", "IsLocked", 1)
            SetProperty("pol1_prop_door6", "IsLocked", 1)
            SetProperty("pol1_prop_door2", "IsLocked", 1)
            SetProperty("pol1_prop_door4", "IsLocked", 1)
            SetProperty("pol1_prop_door5", "IsLocked", 1)
            SetProperty("pol1_prop_door3", "IsLocked", 1)
            SetProperty("pol1_prop_door1", "IsLocked", 1)
            SetProperty("pol1_prop_door7", "IsLocked", 1)
            SetProperty("pol1_prop_door", "IsLocked", 1)
        end
    )
    ff_AddCommand(
        "Unlock All Doors",
        "This unlocks all the doors in Death Star, Kamino, Mustafar, Polis Massa, and Tantive.",
        function()
            SetProperty("tan4_prop_door5", "IsLocked", 0)
            SetProperty("tan4_prop_door4", "IsLocked", 0)
            SetProperty("tan4_prop_door1", "IsLocked", 0)
            SetProperty("rpodroom2", "IsLocked", 0)
            SetProperty("rpodroom1f", "IsLocked", 0)
            SetProperty("rpodroom1", "IsLocked", 0)
            SetProperty("lpodroom3", "IsLocked", 0)
            SetProperty("lpodroom2", "IsLocked", 0)
            SetProperty("lpodroom1", "IsLocked", 0)
            SetProperty("engine01", "IsLocked", 0)
            SetProperty("blasteng2", "IsLocked", 0)
            SetProperty("blasteng1", "IsLocked", 0)
            SetProperty("blastbar1", "IsLocked", 0)
            SetProperty("techroom1", "IsLocked", 0)
            SetProperty("techroom2", "IsLocked", 0)
            SetProperty("tan4_prop_door_minus_darkside", "IsLocked", 0)
            SetProperty("dea1_prop_door_blast", "IsLocked", 0)
            SetProperty("dea1_prop_door_blast0", "IsLocked", 0)
            SetProperty("dea1_bldg_falcon_hanger_doorside", "IsLocked", 0)
            SetProperty("dea1_prop_garbage_room_door", "IsLocked", 0)
            SetProperty("dea1_prop_door_blast1", "IsLocked", 0)
            SetProperty("dea1_prop_door_ajar", "IsLocked", 0)
            SetProperty("dr-leftmain", "IsLocked", 0)
            SetProperty("dea1_prop_door0", "IsLocked", 0)
            SetProperty("door1", "IsLocked", 0)
            SetProperty("door2", "IsLocked", 0)
            SetProperty("fdu-2", "IsLocked", 0)
            SetProperty("kam_bldg_podroom_door20", "IsLocked", 0)
            SetProperty("kam_bldg_podroom_door32", "IsLocked", 0)
            SetProperty("fdl-3", "IsLocked", 0)
            SetProperty("fdl-1", "IsLocked", 0)
            SetProperty("fdu-3", "IsLocked", 0)
            SetProperty("fdu-1", "IsLocked", 0)
            SetProperty("kam_bldg_podroom_door24", "IsLocked", 0)
            SetProperty("open", "IsLocked", 0)
            SetProperty("kam_bldg_podroom_door28", "IsLocked", 0)
            SetProperty("fdl-2", "IsLocked", 0)
            SetProperty("kam_bldg_podroom_door27", "IsLocked", 0)
            SetProperty("kam_bldg_blast_door3", "IsLocked", 0)
            SetProperty("kam_bldg_blast_door1", "IsLocked", 0)
            SetProperty("kam_bldg_blast_door", "IsLocked", 0)
            SetProperty("kam_bldg_blast_door2", "IsLocked", 0)
            SetProperty("door_cont_1", "IsLocked", 0)
            SetProperty("door_cont_3", "IsLocked", 0)
            SetProperty("door_cont_9", "IsLocked", 0)
            SetProperty("mus1_prop_door_garage5", "IsLocked", 0)
            SetProperty("mus1_prop_door_garage6", "IsLocked", 0)
            SetProperty("hangardoor", "IsLocked", 0)
            SetProperty("door_cont_4", "IsLocked", 0)
            SetProperty("win2", "IsLocked", 0)
            SetProperty("mus1_prop_door_garage7", "IsLocked", 0)
            SetProperty("door_cont_11", "IsLocked", 0)
            SetProperty("door_cont_7", "IsLocked", 0)
            SetProperty("door_cont_6", "IsLocked", 0)
            SetProperty("mus1_prop_door_garage3", "IsLocked", 0)
            SetProperty("mus1_prop_door_garage1", "IsLocked", 0)
            SetProperty("door_cont_2", "IsLocked", 0)
            SetProperty("d", "IsLocked", 0)
            SetProperty("drop", "IsLocked", 0)
            SetProperty("door_cont_8", "IsLocked", 0)
            SetProperty("window", "IsLocked", 0)
            SetProperty("mus1_prop_window7", "IsLocked", 0)
            SetProperty("mus1_prop_window8", "IsLocked", 0)
            SetProperty("mus1_bldg_hallway_window", "IsLocked", 0)
            SetProperty("airlock02", "IsLocked", 0)
            SetProperty("airlock01", "IsLocked", 0)
            SetProperty("pol1_prop_door6", "IsLocked", 0)
            SetProperty("pol1_prop_door2", "IsLocked", 0)
            SetProperty("pol1_prop_door4", "IsLocked", 0)
            SetProperty("pol1_prop_door5", "IsLocked", 0)
            SetProperty("pol1_prop_door3", "IsLocked", 0)
            SetProperty("pol1_prop_door1", "IsLocked", 0)
            SetProperty("pol1_prop_door7", "IsLocked", 0)
            SetProperty("pol1_prop_door", "IsLocked", 0)
        end
    )
    ff_AddCommand(
        "Reset Carried Flags",
        "This will reset any flags being carried by any characters.",
        function()
            KillObject("flag")
            KillObject("flag1")
            KillObject("flag2")
        end
    )
    ff_AddCommand(
        "Rebuild Ammo Droids",
        "This will rebuild any broken ammo droids in the level, should also work in an exceptionally high amount of mod maps.",
        function()
            RespawnObject("com_item_weaponrecharge")
            RespawnObject("com_item_weaponrecharge1")
            RespawnObject("com_item_weaponrecharge2")
            RespawnObject("com_item_weaponrecharge3")
            RespawnObject("com_item_weaponrecharge4")
            RespawnObject("com_item_weaponrecharge5")
            RespawnObject("com_item_weaponrecharge6")
            RespawnObject("com_item_weaponrecharge7")
            RespawnObject("com_item_weaponrecharge8")
            RespawnObject("com_item_weaponrecharge9")
            RespawnObject("com_item_weaponrecharge10")
            RespawnObject("com_item_weaponrecharge11")
            RespawnObject("com_item_weaponrecharge12")
            RespawnObject("com_item_weaponrecharge13")
            RespawnObject("com_item_weaponrecharge14")
            RespawnObject("com_item_weaponrecharge15")
            RespawnObject("com_item_weaponrecharge16")
            RespawnObject("com_item_weaponrecharge17")
            RespawnObject("com_item_weaponrecharge18")
            RespawnObject("com_item_weaponrecharge19")
            RespawnObject("com_item_weaponrecharge20")
        end
    )
    ff_AddCommand(
        "Remove Death Regions",
        "Removes most spaces in default maps where you may die.",
        function()
            RemoveRegion("death")
            RemoveRegion("death1")
            RemoveRegion("death2")
            RemoveRegion("death3")
            RemoveRegion("death4")
            RemoveRegion("DeathRegion1")
            RemoveRegion("DeathRegion01")
            RemoveRegion("DeathRegion02")
            RemoveRegion("DeathRegion03")
            RemoveRegion("DeathRegion04")
            RemoveRegion("DeathRegion05")
            RemoveRegion("deathregion")
            RemoveRegion("deathregion")
            RemoveRegion("deathregion2")
            RemoveRegion("deathregion3")
            RemoveRegion("deathregion4")
            RemoveRegion("deathregion5")
            RemoveRegion("fall")
            RemoveRegion("deathregion")
            RemoveRegion("deathregion")
            RemoveRegion("deathregion2")
            RemoveRegion("deathregion")
            RemoveRegion("deathregion")
            RemoveRegion("death1")
            RemoveRegion("death2")
            RemoveRegion("death3")
            RemoveRegion("death4")
            RemoveRegion("death5")
            RemoveRegion("death6")
            RemoveRegion("death7")
            RemoveRegion("death8")
        end
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[Hero Commands]", "Various commands for manipulating hero classes.", nil, nil)
    ff_AddCommand(
        "Unlock Hero For Team 1",
        "unlock the hero for team 1.",
        function()
            UnlockHeroForTeam(1)
        end,
        nil
    )
    ff_AddCommand(
        "Unlock Hero For Team 2",
        "unlock the hero for team 2.",
        function()
            UnlockHeroForTeam(2)
        end,
        nil
    )
    ff_AddCommand(
        "Unlock Hero For Team 3",
        "unlock the hero for team 3.",
        function()
            UnlockHeroForTeam(3)
        end,
        nil
    )
    ff_AddCommand(
        "Heros SP Rules Off",
        "Singleplayer hero rules will be turned off.",
        function()
            ff_heroSPRules = 0
            DisableSPHeroRules()
        end,
        function()
            return ff_heroSPRules == 1
        end
    )
    ff_AddCommand(
        "Hero SP Rules On",
        "Singleplayer hero rules will be turned on.",
        function()
            ff_heroSPRules = 1
            EnableSPHeroRules()
        end,
        function()
            return ff_heroSPRules ~= 1
        end
    )
    ff_AddCommand(
        "Heros SP Scripted Off",
        "Singleplayer scripted heroes will be off.",
        function()
            ff_heroSPScript = 0
            DisableSPScriptedHeroes()
        end,
        function()
            return ff_heroSPScript == 1
        end
    )
    ff_AddCommand(
        "Heros SP Scripted On",
        "Singleplayer scripted heroes will be on.",
        function()
            ff_heroSPScript = 1
            EnableSPScriptedHeroes()
        end,
        function()
            return ff_heroSPScript ~= 1
        end
    )
    ff_AddCommand(
        "Heroes Spawn Dead",
        "This causes hero classes to spawn dead, currently living heroes must die again.",
        function()
            SetClassProperty("all_hero_luke_jedi", "MaxHealth", 0)
            SetClassProperty("imp_hero_darthvader", "MaxHealth", 0)
            SetClassProperty("imp_hero_emperor", "MaxHealth", 0)
            SetClassProperty("rep_hero_yoda", "MaxHealth", 0)
            SetClassProperty("rep_hero_macewindu", "MaxHealth", 0)
            SetClassProperty("rep_hero_anakin", "MaxHealth", 0)
            SetClassProperty("rep_hero_aalya", "MaxHealth", 0)
            SetClassProperty("rep_hero_kiyadimundi", "MaxHealth", 0)
            SetClassProperty("rep_hero_obiwan", "MaxHealth", 0)
            SetClassProperty("cis_hero_grievous", "MaxHealth", 0)
            SetClassProperty("cis_hero_darthmaul", "MaxHealth", 0)
            SetClassProperty("cis_hero_countdooku", "MaxHealth", 0)
            SetClassProperty("all_hero_luke_pilot", "MaxHealth", 0)
            SetClassProperty("rep_hero_cloakedanakin", "MaxHealth", 0)
            SetClassProperty("all_hero_hansolo_tat", "MaxHealth", 0)
            SetClassProperty("all_hero_chewbacca", "MaxHealth", 0)
            SetClassProperty("all_hero_leia", "MaxHealth", 0)
            SetClassProperty("cis_hero_jangofett", "MaxHealth", 0)
            SetClassProperty("imp_hero_bobafett", "MaxHealth", 0)
        end
    )
    ff_AddCommand(
        "Hero Music & VO",
        "Attemps to play specific hero music and enable hero voicing and comments.",
        function()
            ScriptCB_EnableHeroMusic(1)
            ScriptCB_EnableHeroVO(1)
        end
    )
    ff_AddCommand(
        "Force 3rd Person For Jedi",
        "Forced stock jedi class characters into third person view. Only you will see this.",
        function()
            SetClassProperty("all_hero_luke_jedi", "ForceMode", 0)
            SetClassProperty("imp_hero_darthvader", "ForceMode", 0)
            SetClassProperty("imp_hero_emperor", "ForceMode", 0)
            SetClassProperty("rep_hero_yoda", "ForceMode", 0)
            SetClassProperty("rep_hero_macewindu", "ForceMode", 0)
            SetClassProperty("rep_hero_anakin", "ForceMode", 0)
            SetClassProperty("rep_hero_aalya", "ForceMode", 0)
            SetClassProperty("rep_hero_kiyadimundi", "ForceMode", 0)
            SetClassProperty("rep_hero_obiwan", "ForceMode", 0)
            SetClassProperty("cis_hero_grievous", "ForceMode", 0)
            SetClassProperty("cis_hero_darthmaul", "ForceMode", 0)
            SetClassProperty("cis_hero_countdooku", "ForceMode", 0)
            SetClassProperty("all_hero_luke_pilot", "ForceMode", 0)
            SetClassProperty("rep_hero_cloakedanakin", "ForceMode", 0)
        end
    )
    ff_AddCommand(
        "Force 1st Person For Jedi",
        "Forced stock jedi class characters into first person view. Only you will see this.",
        function()
            SetClassProperty("all_hero_luke_jedi", "ForceMode", 2)
            SetClassProperty("imp_hero_emperor", "ForceMode", 2)
            SetClassProperty("imp_hero_darthvader", "ForceMode", 2)
            SetClassProperty("rep_hero_yoda", "ForceMode", 2)
            SetClassProperty("rep_hero_macewindu", "ForceMode", 2)
            SetClassProperty("rep_hero_anakin", "ForceMode", 2)
            SetClassProperty("rep_hero_aalya", "ForceMode", 2)
            SetClassProperty("rep_hero_kiyadimundi", "ForceMode", 2)
            SetClassProperty("rep_hero_obiwan", "ForceMode", 2)
            SetClassProperty("cis_hero_grievous", "ForceMode", 2)
            SetClassProperty("cis_hero_darthmaul", "ForceMode", 2)
            SetClassProperty("cis_hero_countdooku", "ForceMode", 2)
            SetClassProperty("all_hero_luke_pilot", "ForceMode", 2)
            SetClassProperty("rep_hero_cloakedanakin", "ForceMode", 2)
        end
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[Character Commands]", "Commands that will change how certain characters behave.", nil, nil)
    ff_AddCommand(
        "Buffed Wookiee Warrior",
        "Alliance Wookiee Warrior is faster with more health, health regen, and more roll, more jump, and energy.",
        function()
            SetClassProperty("all_inf_wookiee", "MaxSpeed", 10)
            SetClassProperty("all_inf_wookiee_snow", "MaxSpeed", 10)
            SetClassProperty("all_inf_wookiee", "MaxHealth", 1000)
            SetClassProperty("all_inf_wookiee_snow", "MaxHealth", 1000)
            SetClassProperty("all_inf_wookiee", "JumpHeight", 5)
            SetClassProperty("all_inf_wookiee_snow", "JumpHeight", 5)
            SetClassProperty("all_inf_wookiee", "RollSpeedFactor", 2.5)
            SetClassProperty("all_inf_wookiee_snow", "RollSpeedFactor", 2.5)
            SetClassProperty("all_inf_wookiee", "EnergyRestore", 999)
            SetClassProperty("all_inf_wookiee_snow", "EnergyRestore", 999)
            SetClassProperty("all_inf_wookiee", "AddHealth", 25)
            SetClassProperty("all_inf_wookiee_snow", "AddHealth", 25)
        end
    )
    ff_AddCommand(
        "Super Droideka",
        "The Droideka will have more health, health recharge, no collision damage, high jump, infinite energy, climb 90 degree angles, and bowl enemies in ball mode.",
        function()
            SetClassProperty("cis_inf_droideka", "MaxBallAngle", 90)
            SetClassProperty("cis_inf_droideka", "CollisionScale", "0.0 0.0 0.0")
            SetClassProperty("cis_inf_droideka", "BallJumpHeight", 8.0)
            SetClassProperty("cis_inf_droideka", "EnergyBar", 999999999)
            SetClassProperty("cis_inf_droideka", "EnergyRestore", 999)
            SetClassProperty("cis_inf_droideka", "BowlingPush", 100)
            SetClassProperty("cis_inf_droideka", "SprintTimeForBowling", 0.0)
            SetClassProperty("cis_inf_droideka", "MaxHealth", 1000)
            SetClassProperty("cis_inf_droideka", "AddHealth", 25.0)
        end
    )
    ff_AddCommand(
        "Dark Trooper Unlimited Jetpack",
        "This gives the Dark Trooper unlimited jetpack recharge.",
        function()
            SetClassProperty("imp_inf_dark_trooper", "JetFuelRechargeRate", 9.9)
        end
    )
    ff_AddCommand(
        "Jet Trooper Unlimited Jetpack",
        "This gives the Jet Trooper unlimited jetpack recharge.",
        function()
            SetClassProperty("rep_inf_ep2_jettrooper", "JetFuelRechargeRate", 9.9)
            SetClassProperty("rep_inf_ep2_jettrooper_rifleman", "JetFuelRechargeRate", 9.9)
            SetClassProperty("rep_inf_ep2_jettrooper_sniper", "JetFuelRechargeRate", 9.9)
            SetClassProperty("rep_inf_ep2_jettrooper_training", "JetFuelRechargeRate", 9.9)
            SetClassProperty("rep_inf_ep3_jettrooper", "JetFuelRechargeRate", 9.9)
        end
    )
    ff_AddCommand(
        "Bothan Spy Unlimited Energy",
        "This gives the Bothan Spy unlimited energy for constant stealth.",
        function()
            SetClassProperty("all_inf_officer", "EnergyBar", 999999999)
            SetClassProperty("all_inf_officer_jungle", "EnergyBar", 999999999)
            SetClassProperty("all_inf_officer_snow", "EnergyBar", 999999999)
        end
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[Weapon Commands]", "Commands that will manipulate certain weapons.", nil, nil)
    ff_AddCommand(
        "Not Immune To Mines",
        "All characters will be able to trigger mines.",
        function()
            ff_immuneToMines = 0
            local properties = {
                {name = "ImmuneToMines", value = "0"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_immuneToMines == 1
        end
    )
    ff_AddCommand(
        "Immune To Mines",
        "All characters will be immune to mines.",
        function()
            ff_immuneToMines = 1
            local properties = {
                {name = "ImmuneToMines", value = "1"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_immuneToMines ~= 1
        end
    )
    ff_AddCommand(
        "All Mines Are Hostile",
        "All placed land mines are hostile to teams 1 and 2 and the user.",
        function()
            OnObjectInit(
                function(object)
                    if GetEntityClass(object) == FindEntityClass("com_weap_inf_landmine") then
                        SetObjectTeam(object, 3)
                    end
                end
            )
        end
    )
    ff_AddCommand(
        "Destroy Mines Instantly",
        "This will destroy all land mines as soon as they are created.",
        function()
            OnObjectInit(
                function(object)
                    if GetEntityClass(object) == FindEntityClass("com_weap_inf_landmine") then
                        KillObject(object)
                    end
                end
            )
        end
    )
    ff_AddCommand(
        "All Detpacks Are Hostile",
        "All detpacks are hostile to teams 1 and 2 and the user.",
        function()
            OnObjectInit(
                function(object)
                    if
                        GetEntityClass(object) == FindEntityClass("cis_weap_inf_detpack_ord") or
                            GetEntityClass(object) == FindEntityClass("rep_weap_inf_detpack_ord") or
                            GetEntityClass(object) == FindEntityClass("imp_weap_inf_detpack_ord") or
                            GetEntityClass(object) == FindEntityClass("all_weap_inf_detpack_ord")
                     then
                        SetObjectTeam(object, 3)
                    end
                end
            )
        end
    )
    ff_AddCommand(
        "Destroy Detpacks Instantly",
        "All detpacks are destroyed as soon as they are created.",
        function()
            OnObjectInit(
                function(object)
                    if
                        GetEntityClass(object) == FindEntityClass("cis_weap_inf_detpack_ord") or
                            GetEntityClass(object) == FindEntityClass("rep_weap_inf_detpack_ord") or
                            GetEntityClass(object) == FindEntityClass("imp_weap_inf_detpack_ord") or
                            GetEntityClass(object) == FindEntityClass("all_weap_inf_detpack_ord")
                     then
                        KillObject(object)
                    end
                end
            )
        end
    )
    ff_AddCommand(
        "All Timebombs Are Hostile",
        "All Timebombs are hostile to teams 1 and 2 and the user.",
        function()
            OnObjectInit(
                function(object)
                    if
                        GetEntityClass(object) == FindEntityClass("cis_weap_inf_timebomb_ord") or
                            GetEntityClass(object) == FindEntityClass("rep_weap_inf_timebomb_ord") or
                            GetEntityClass(object) == FindEntityClass("imp_weap_inf_timebomb_ord") or
                            GetEntityClass(object) == FindEntityClass("all_weap_inf_timebomb_ord")
                     then
                        SetObjectTeam(object, 3)
                    end
                end
            )
        end
    )
    ff_AddCommand(
        "Destroy Timebombs Instantly",
        "All Timebombs are destroyed as soon as they are created.",
        function()
            OnObjectInit(
                function(object)
                    if
                        GetEntityClass(object) == FindEntityClass("cis_weap_inf_timebomb_ord") or
                            GetEntityClass(object) == FindEntityClass("rep_weap_inf_timebomb_ord") or
                            GetEntityClass(object) == FindEntityClass("imp_weap_inf_timebomb_ord") or
                            GetEntityClass(object) == FindEntityClass("all_weap_inf_timebomb_ord")
                     then
                        KillObject(object)
                    end
                end
            )
        end
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[Vehicle Commands]", "These commands will change how certain vehicles operate.", nil, nil)
    ff_AddCommand(
        "Unlock All Vehicles",
        "All characters to use vehicles.",
        function()
            ff_lockVehicles = 0
            local properties = {
                {name = "NoEnterVehicles", value = "0"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_lockVehicles == 1
        end
    )
    ff_AddCommand(
        "Lock All Vehicles",
        "All characters will be blocked from using vehicles.",
        function()
            ff_lockVehicles = 1
            local properties = {
                {name = "NoEnterVehicles", value = "1"}
            }
            uf_changeClassProperties(uf_classes, properties)
        end,
        function()
            return ff_lockVehicles ~= 1
        end
    )
    ff_AddCommand(
        "Vehicles Explode On Spawn",
        "This prevents default vehicles from spawning, current tanks must be destroyed again.",
        function()
            SetClassProperty("all_hover_combatspeeder", "MaxHealth", 0)
            SetClassProperty("all_walk_tauntaun", "MaxHealth", 0)
            SetClassProperty("imp_hover_fightertank", "MaxHealth", 0)
            SetClassProperty("imp_hover_speederbike", "MaxHealth", 0)
            SetClassProperty("imp_walk_atat", "MaxHealth", 0)
            SetClassProperty("imp_walk_atst_snow", "MaxHealth", 0)
            SetClassProperty("imp_walk_atst_jungle", "MaxHealth", 0)
            SetClassProperty("cis_hover_stap", "MaxHealth", 0)
            SetClassProperty("cis_hover_aat", "MaxHealth", 0)
            SetClassProperty("cis_tread_hailfire", "MaxHealth", 0)
            SetClassProperty("cis_tread_snailtank", "MaxHealth", 0)
            SetClassProperty("cis_walk_spider", "MaxHealth", 0)
            SetClassProperty("cis_walk_spiderkas", "MaxHealth", 0)
            SetClassProperty("rep_hover_barcspeeder", "MaxHealth", 0)
            SetClassProperty("rep_hover_fightertank", "MaxHealth", 0)
            SetClassProperty("rep_walk_atte", "MaxHealth", 0)
            SetClassProperty("rep_walk_oneman_atst", "MaxHealth", 0)
        end
    )
    ff_AddCommand(
        "All Vehicles Can Capture Posts",
        "This allows all default vehicles to capture command posts.",
        function()
            SetClassProperty("all_hover_combatspeeder", "CapturePosts", 1)
            SetClassProperty("all_walk_tauntaun", "CapturePosts", 1)
            SetClassProperty("imp_hover_fightertank", "CapturePosts", 1)
            SetClassProperty("imp_hover_speederbike", "CapturePosts", 1)
            SetClassProperty("imp_walk_atat", "CapturePosts", 1)
            SetClassProperty("imp_walk_atst_snow", "CapturePosts", 1)
            SetClassProperty("imp_walk_atst_jungle", "CapturePosts", 1)
            SetClassProperty("cis_hover_stap", "CapturePosts", 1)
            SetClassProperty("cis_hover_aat", "CapturePosts", 1)
            SetClassProperty("cis_tread_hailfire", "CapturePosts", 1)
            SetClassProperty("cis_tread_snailtank", "CapturePosts", 1)
            SetClassProperty("cis_walk_spider", "CapturePosts", 1)
            SetClassProperty("cis_walk_spiderkas", "CapturePosts", 1)
            SetClassProperty("rep_hover_barcspeeder", "CapturePosts", 1)
            SetClassProperty("rep_hover_fightertank", "CapturePosts", 1)
            SetClassProperty("rep_walk_atte", "CapturePosts", 1)
            SetClassProperty("rep_walk_oneman_atst", "CapturePosts", 1)
        end
    )
    ff_AddCommand(
        "Spawn Above Droid Gunship",
        "You will spawn above CIS gunship when you select it as a spawn point.",
        function()
            SetClassProperty("cis_fly_droidgunship", "SpawnPointCount", 6)
            SetClassProperty("cis_fly_droidgunship", "SpawnPointLocation", "1.0 7.0 0.0 5")
            SetClassProperty("cis_fly_droidgunship", "SpawnPointLocation", "1.0 7.0 0.0 5")
            SetClassProperty("cis_fly_droidgunship", "SpawnPointLocation", "1.0 7.0 0.0 5")
            SetClassProperty("cis_fly_droidgunship", "SpawnPointLocation", "1.0 7.0 0.0 5")
            SetClassProperty("cis_fly_droidgunship", "SpawnPointLocation", "1.0 7.0 0.0 5")
            SetClassProperty("cis_fly_droidgunship", "SpawnPointLocation", "1.0 7.0 0.0 5")
        end
    )
    ff_AddCommand(
        "Super Bikes",
        "Small light speeders have infinite energy, health regeneration, jump high, and capture posts allowed.",
        function()
			SetClassProperty("rep_hover_barcspeeder", "JumpTimeMin", "0.0")
			SetClassProperty("rep_hover_barcspeeder", "JumpTimeMax", "1.5")
			SetClassProperty("rep_hover_barcspeeder", "JumpForce", "50.0")
			SetClassProperty("rep_hover_barcspeeder", "JumpMinSpeedMult", "0.0")
			SetClassProperty("rep_hover_barcspeeder", "JumpEnergyPerSec", "0.0")
			SetClassProperty("rep_hover_barcspeeder", "EnergyBar", "999999999")
			SetClassProperty("rep_hover_barcspeeder", "CapturePosts", "1")
			SetClassProperty("rep_hover_barcspeeder", "AddHealth", "5")
			SetClassProperty("rep_hover_barcspeeder", "CollisionScale", "0.0 0.0 0.0")
			SetClassProperty("rep_hover_barcspeeder", "CollisionThreshold", "0")
			SetClassProperty("imp_hover_speederbike", "JumpTimeMin", "0.0")
			SetClassProperty("imp_hover_speederbike", "JumpTimeMax", "1.5")
			SetClassProperty("imp_hover_speederbike", "JumpForce", "50.0")
			SetClassProperty("imp_hover_speederbike", "JumpMinSpeedMult", "0.0")
			SetClassProperty("imp_hover_speederbike", "JumpEnergyPerSec", "0.0")
			SetClassProperty("imp_hover_speederbike", "EnergyBar", "999999999")
			SetClassProperty("imp_hover_speederbike", "CapturePosts", "1")
			SetClassProperty("imp_hover_speederbike", "AddHealth", "5")
			SetClassProperty("imp_hover_speederbike", "CollisionScale", "0.0 0.0 0.0")
			SetClassProperty("imp_hover_speederbike", "CollisionThreshold", "0")
			SetClassProperty("cis_hover_stap", "JumpTimeMin", "0.0")
			SetClassProperty("cis_hover_stap", "JumpTimeMax", "1.5")
			SetClassProperty("cis_hover_stap", "JumpForce", "50.0")
			SetClassProperty("cis_hover_stap", "JumpMinSpeedMult", "0.0")
			SetClassProperty("cis_hover_stap", "JumpEnergyPerSec", "0.0")
			SetClassProperty("cis_hover_stap", "EnergyBar", "999999999")
			SetClassProperty("cis_hover_stap", "CapturePosts", "1")
			SetClassProperty("cis_hover_stap", "AddHealth", "5")
			SetClassProperty("cis_hover_stap", "CollisionScale", "0.0 0.0 0.0")
			SetClassProperty("cis_hover_stap", "CollisionThreshold", "0")
        end
    )
    ff_AddCommand(
        "Super Tread Vehicles",
        "Allows the CIS snail tank and hailfire droid to float on water, climb better, more energy, capture posts and quick slicing.",
        function()
            SetClassProperty("cis_tread_snailtank", "FloatsOnWater", 1)
            SetClassProperty("cis_tread_hailfire", "FloatsOnWater", 1)
            SetClassProperty("cis_tread_snailtank", "Traction", 999)
            SetClassProperty("cis_tread_hailfire", "Traction", 999)
            SetClassProperty("cis_tread_snailtank", "CapturePosts", 1)
            SetClassProperty("cis_tread_hailfire", "CapturePosts", 1)
            SetClassProperty("cis_tread_snailtank", "EnergyBar", 999999999)
            SetClassProperty("cis_tread_hailfire", "EnergyBar", 999999999)
            SetClassProperty("cis_tread_snailtank", "EnergyAutoRestore", 999999999)
            SetClassProperty("cis_tread_hailfire", "EnergyAutoRestore", 999999999)
        end
    )
    ff_AddCommand(
        "Super AT-AT",
        "Makes the AT-AT very fast, capture posts allowed, health regeneration, and you can spawn inside of the body.",
        function()
            SetClassProperty("imp_walk_atat", "MaxSpeed", 10.0)
			SetClassProperty("imp_walk_atat", "AddHealth", 100.0)
            SetClassProperty("imp_walk_atat", "CapturePosts", 1)
            SetClassProperty("imp_walk_atat", "SpawnPointCount", 6)
            SetClassProperty("imp_walk_atat", "SpawnPointLocation", "1.0 15.0 0.0 5")
            SetClassProperty("imp_walk_atat", "SpawnPointLocation", "1.0 15.0 0.0 5")
            SetClassProperty("imp_walk_atat", "SpawnPointLocation", "1.0 15.0 0.0 5")
            SetClassProperty("imp_walk_atat", "SpawnPointLocation", "-1.0 15.0 0.0 355")
            SetClassProperty("imp_walk_atat", "SpawnPointLocation", "-1.0 15.0 0.0 355")
            SetClassProperty("imp_walk_atat", "SpawnPointLocation", "-1.0 15.0 0.0 355")
        end
    )
    ff_AddCommand(
        "Super AT-TE",
        "Makes the AT-TE very fast, capture posts allowed, health regeneration, and you can spawn on top of the vehicle.",
        function()
            SetClassProperty("rep_walk_atte", "MaxSpeed", 10.0)
			SetClassProperty("rep_walk_atte", "AddHealth", 100.0)
            SetClassProperty("rep_walk_atte", "CapturePosts", 1)
            SetClassProperty("rep_walk_atte", "SpawnPointCount", 6)
            SetClassProperty("rep_walk_atte", "SpawnPointLocation", "1.0 8.0 0.0 5")
            SetClassProperty("rep_walk_atte", "SpawnPointLocation", "1.0 8.0 0.0 5")
            SetClassProperty("rep_walk_atte", "SpawnPointLocation", "1.0 8.0 0.0 5")
            SetClassProperty("rep_walk_atte", "SpawnPointLocation", "-1.0 8.0 0.0 355")
            SetClassProperty("rep_walk_atte", "SpawnPointLocation", "-1.0 8.0 0.0 355")
            SetClassProperty("rep_walk_atte", "SpawnPointLocation", "-1.0 8.0 0.0 355")
        end
    )
    ff_AddCommand(
        "Upgrade Starfighters CW",
        "All star fighters have unlimited energy, can capture command posts and hover in place, and you can slice fast.",
        function()
            SetClassProperty("cis_fly_droidgunship", "TimeRequiredToEject", 0.1)
            SetClassProperty("cis_fly_greviousfighter", "TimeRequiredToEject", 0.1)
            SetClassProperty("cis_fly_tridroidfighter", "TimeRequiredToEject", 0.1)
            SetClassProperty("cis_fly_droidfighter_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("rep_fly_anakinstarfighter_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("rep_fly_arc170fighter_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("rep_fly_gunship_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("rep_fly_vwing", "TimeRequiredToEject", 0.1)
            SetClassProperty("cis_fly_droidgunship", "EnergyAutoRestore", 999999999)
            SetClassProperty("cis_fly_greviousfighter", "EnergyAutoRestore", 999999999)
            SetClassProperty("cis_fly_tridroidfighter", "EnergyAutoRestore", 999999999)
            SetClassProperty("cis_fly_droidfighter_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("rep_fly_anakinstarfighter_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("rep_fly_arc170fighter_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("rep_fly_gunship_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("rep_fly_vwing", "EnergyAutoRestore", 999999999)
            SetClassProperty("cis_fly_droidgunship", "CapturePosts", 1)
            SetClassProperty("cis_fly_greviousfighter", "CapturePosts", 1)
            SetClassProperty("cis_fly_tridroidfighter", "CapturePosts", 1)
            SetClassProperty("cis_fly_droidfighter_sc", "CapturePosts", 1)
            SetClassProperty("rep_fly_anakinstarfighter_sc", "CapturePosts", 1)
            SetClassProperty("rep_fly_arc170fighter_sc", "CapturePosts", 1)
            SetClassProperty("rep_fly_gunship_sc", "CapturePosts", 1)
            SetClassProperty("rep_fly_vwing", "CapturePosts", 1)
            SetClassProperty("cis_fly_droidgunship", "MinSpeed", 0)
            SetClassProperty("cis_fly_greviousfighter", "MinSpeed", 0)
            SetClassProperty("cis_fly_tridroidfighter", "MinSpeed", 0)
            SetClassProperty("cis_fly_droidfighter_sc", "MinSpeed", 0)
            SetClassProperty("rep_fly_anakinstarfighter_sc", "MinSpeed", 0)
            SetClassProperty("rep_fly_arc170fighter_sc", "MinSpeed", 0)
            SetClassProperty("rep_fly_gunship_sc", "MinSpeed", 0)
            SetClassProperty("rep_fly_vwing", "MinSpeed", 0)
            SetClassProperty("cis_fly_droidgunship", "EnergyBar", 999999999)
            SetClassProperty("cis_fly_greviousfighter", "EnergyBar", 999999999)
            SetClassProperty("cis_fly_tridroidfighter", "EnergyBar", 999999999)
            SetClassProperty("cis_fly_droidfighter_sc", "EnergyBar", 999999999)
            SetClassProperty("rep_fly_anakinstarfighter_sc", "EnergyBar", 999999999)
            SetClassProperty("rep_fly_arc170fighter_sc", "EnergyBar", 999999999)
            SetClassProperty("rep_fly_gunship_sc", "EnergyBar", 999999999)
            SetClassProperty("rep_fly_vwing", "EnergyBar", 999999999)
        end
    )
    ff_AddCommand(
        "Upgrade Starfighters GCW",
        "All star fighters have unlimited energy, can capture command posts and hover in place, and you can slice fast.",
        function()
            SetClassProperty("all_fly_awing", "TimeRequiredToEject", 0.1)
            SetClassProperty("all_fly_gunship_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("all_fly_snowspeeder", "TimeRequiredToEject", 0.1)
            SetClassProperty("all_fly_xwing_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("all_fly_ywing_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("imp_fly_tiebomber_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("imp_fly_tiefighter_sc", "TimeRequiredToEject", 0.1)
            SetClassProperty("imp_fly_tieinterceptor", "TimeRequiredToEject", 0.1)
            SetClassProperty("imp_fly_trooptrans", "TimeRequiredToEject", 0.1)
            SetClassProperty("all_fly_awing", "EnergyAutoRestore", 999999999)
            SetClassProperty("all_fly_gunship_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("all_fly_snowspeeder", "EnergyAutoRestore", 999999999)
            SetClassProperty("all_fly_xwing_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("all_fly_ywing_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("imp_fly_tiebomber_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("imp_fly_tiefighter_sc", "EnergyAutoRestore", 999999999)
            SetClassProperty("imp_fly_tieinterceptor", "EnergyAutoRestore", 999999999)
            SetClassProperty("imp_fly_trooptrans", "EnergyAutoRestore", 999999999)
            SetClassProperty("all_fly_awing", "CapturePosts", 1)
            SetClassProperty("all_fly_gunship_sc", "CapturePosts", 1)
            SetClassProperty("all_fly_snowspeeder", "CapturePosts", 1)
            SetClassProperty("all_fly_xwing_sc", "CapturePosts", 1)
            SetClassProperty("all_fly_ywing_sc", "CapturePosts", 1)
            SetClassProperty("imp_fly_tiebomber_sc", "CapturePosts", 1)
            SetClassProperty("imp_fly_tiefighter_sc", "CapturePosts", 1)
            SetClassProperty("imp_fly_tieinterceptor", "CapturePosts", 1)
            SetClassProperty("imp_fly_trooptrans", "CapturePosts", 1)
            SetClassProperty("all_fly_awing", "MinSpeed", 0)
            SetClassProperty("all_fly_gunship_sc", "MinSpeed", 0)
            SetClassProperty("all_fly_snowspeeder", "MinSpeed", 0)
            SetClassProperty("all_fly_xwing_sc", "MinSpeed", 0)
            SetClassProperty("all_fly_ywing_sc", "MinSpeed", 0)
            SetClassProperty("imp_fly_tiebomber_sc", "MinSpeed", 0)
            SetClassProperty("imp_fly_tiefighter_sc", "MinSpeed", 0)
            SetClassProperty("imp_fly_tieinterceptor", "MinSpeed", 0)
            SetClassProperty("imp_fly_trooptrans", "MinSpeed", 0)
            SetClassProperty("all_fly_awing", "EnergyBar", 999999999)
            SetClassProperty("all_fly_gunship_sc", "EnergyBar", 999999999)
            SetClassProperty("all_fly_snowspeeder", "EnergyBar", 999999999)
            SetClassProperty("all_fly_xwing_sc", "EnergyBar", 999999999)
            SetClassProperty("all_fly_ywing_sc", "EnergyBar", 999999999)
            SetClassProperty("imp_fly_tiebomber_sc", "EnergyBar", 999999999)
            SetClassProperty("imp_fly_tiefighter_sc", "EnergyBar", 999999999)
            SetClassProperty("imp_fly_tieinterceptor", "EnergyBar", 999999999)
            SetClassProperty("imp_fly_trooptrans", "EnergyBar", 999999999)
        end
    )
    ff_AddCommand(
        "Force 3rd Person For Vehicles",
        "Forces stock ground vehicles into third person view.",
        function()
            SetClassProperty("all_hover_combatspeeder", "ForceMode", 0)
            SetClassProperty("all_walk_tauntaun", "ForceMode", 0)
            SetClassProperty("imp_hover_fightertank", "ForceMode", 0)
            SetClassProperty("imp_hover_speederbike", "ForceMode", 0)
            SetClassProperty("imp_walk_atat", "ForceMode", 0)
            SetClassProperty("imp_walk_atst_snow", "ForceMode", 0)
            SetClassProperty("imp_walk_atst_jungle", "ForceMode", 0)
            SetClassProperty("cis_hover_stap", "ForceMode", 0)
            SetClassProperty("cis_hover_aat", "ForceMode", 0)
            SetClassProperty("cis_tread_hailfire", "ForceMode", 0)
            SetClassProperty("cis_tread_snailtank", "ForceMode", 0)
            SetClassProperty("cis_walk_spider", "ForceMode", 0)
            SetClassProperty("cis_walk_spiderkas", "ForceMode", 0)
            SetClassProperty("rep_hover_barcspeeder", "ForceMode", 0)
            SetClassProperty("rep_hover_fightertank", "ForceMode", 0)
            SetClassProperty("rep_walk_atte", "ForceMode", 0)
            SetClassProperty("rep_walk_oneman_atst", "ForceMode", 0)
        end
    )
    ff_AddCommand(
        "Force 1st Person For Vehicles",
        "Forces stock ground vehicles into first person view.",
        function()
            SetClassProperty("all_hover_combatspeeder", "ForceMode", 2)
            SetClassProperty("all_walk_tauntaun", "ForceMode", 2)
            SetClassProperty("imp_hover_fightertank", "ForceMode", 2)
            SetClassProperty("imp_hover_speederbike", "ForceMode", 2)
            SetClassProperty("imp_walk_atat", "ForceMode", 2)
            SetClassProperty("imp_walk_atst_snow", "ForceMode", 2)
            SetClassProperty("imp_walk_atst_jungle", "ForceMode", 2)
            SetClassProperty("cis_hover_stap", "ForceMode", 2)
            SetClassProperty("cis_hover_aat", "ForceMode", 2)
            SetClassProperty("cis_tread_hailfire", "ForceMode", 2)
            SetClassProperty("cis_tread_snailtank", "ForceMode", 2)
            SetClassProperty("cis_walk_spider", "ForceMode", 2)
            SetClassProperty("cis_walk_spiderkas", "ForceMode", 2)
            SetClassProperty("rep_hover_barcspeeder", "ForceMode", 2)
            SetClassProperty("rep_hover_fightertank", "ForceMode", 2)
            SetClassProperty("rep_walk_atte", "ForceMode", 2)
            SetClassProperty("rep_walk_oneman_atst", "ForceMode", 2)
        end
    )
    ff_AddCommand(
        "Super Walkers",
        "This will allow walker type vehicles to jump high, unlimited energy, capture posts, and health regeneration.",
        function()
            SetClassProperty("all_walk_tauntaun", "JumpHeight", 25)
            SetClassProperty("all_walk_tauntaun", "EnergyBar", 999999999)
            SetClassProperty("all_walk_tauntaun", "EnergyRestore", 999999999)
            SetClassProperty("all_walk_tauntaun", "CapturePosts", 1)
            SetClassProperty("cis_walk_spider", "JumpHeight", 25)
            SetClassProperty("cis_walk_spider", "EnergyBar", 999999999)
            SetClassProperty("cis_walk_spider", "EnergyRestore", 999999999)
            SetClassProperty("cis_walk_spider", "CapturePosts", 1)
            SetClassProperty("cis_walk_spiderkas", "JumpHeight", 25)
            SetClassProperty("cis_walk_spiderkas", "EnergyBar", 999999999)
            SetClassProperty("cis_walk_spiderkas", "EnergyRestore", 999999999)
            SetClassProperty("cis_walk_spiderkas", "CapturePosts", 1)
            SetClassProperty("imp_walk_atst", "JumpHeight", 25)
            SetClassProperty("imp_walk_atst", "EnergyBar", 999999999)
            SetClassProperty("imp_walk_atst", "EnergyRestore", 999999999)
            SetClassProperty("imp_walk_atst", "CapturePosts", 1)
            SetClassProperty("imp_walk_atst_jungle", "JumpHeight", 25)
            SetClassProperty("imp_walk_atst_jungle", "EnergyBar", 999999999)
            SetClassProperty("imp_walk_atst_jungle", "EnergyRestore", 999999999)
            SetClassProperty("imp_walk_atst_jungle", "CapturePosts", 1)
            SetClassProperty("imp_walk_atst_snow", "JumpHeight", 25)
            SetClassProperty("imp_walk_atst_snow", "EnergyBar", 999999999)
            SetClassProperty("imp_walk_atst_snow", "EnergyRestore", 999999999)
            SetClassProperty("imp_walk_atst_snow", "CapturePosts", 1)
            SetClassProperty("rep_walk_oneman_atst", "JumpHeight", 25)
            SetClassProperty("rep_walk_oneman_atst", "EnergyBar", 999999999)
            SetClassProperty("rep_walk_oneman_atst", "EnergyRestore", 999999999)
            SetClassProperty("rep_walk_oneman_atst", "CapturePosts", 1)
			SetClassProperty("all_walk_tauntaun", "AddHealth", "25")
			SetClassProperty("cis_walk_spider", "AddHealth", "25")
			SetClassProperty("cis_walk_spiderkas", "AddHealth", "25")
			SetClassProperty("imp_walk_atst", "AddHealth", "25")
			SetClassProperty("imp_walk_atst_jungle", "AddHealth", "25")
			SetClassProperty("imp_walk_atst_snow", "AddHealth", "25")
			SetClassProperty("rep_walk_oneman_atst", "AddHealth", "25")
        end
    )
    ff_AddCommand(
        "Super Tanks",
        "Hover class tanks will jump high, have unlimited energy, capture posts, and health regeneration.",
        function()
			SetClassProperty("all_hover_combatspeeder", "JumpTimeMin", "0.0")
			SetClassProperty("all_hover_combatspeeder", "JumpTimeMax", "1.5")
			SetClassProperty("all_hover_combatspeeder", "JumpForce", "50.0")
			SetClassProperty("all_hover_combatspeeder", "JumpMinSpeedMult", "0.0")
			SetClassProperty("all_hover_combatspeeder", "JumpEnergyPerSec", "0.0")
			SetClassProperty("all_hover_combatspeeder", "EnergyBar", "999999999")
			SetClassProperty("all_hover_combatspeeder", "CapturePosts", "1")
			SetClassProperty("cis_hover_aat", "JumpTimeMin", "0.0")
			SetClassProperty("cis_hover_aat", "JumpTimeMax", "1.5")
			SetClassProperty("cis_hover_aat", "JumpForce", "50.0")
			SetClassProperty("cis_hover_aat", "JumpMinSpeedMult", "0.0")
			SetClassProperty("cis_hover_aat", "JumpEnergyPerSec", "0.0")
			SetClassProperty("cis_hover_aat", "EnergyBar", "999999999")
			SetClassProperty("cis_hover_aat", "CapturePosts", "1")
			SetClassProperty("imp_hover_fightertank", "JumpTimeMin", "0.0")
			SetClassProperty("imp_hover_fightertank", "JumpTimeMax", "1.5")
			SetClassProperty("imp_hover_fightertank", "JumpForce", "50.0")
			SetClassProperty("imp_hover_fightertank", "JumpMinSpeedMult", "0.0")
			SetClassProperty("imp_hover_fightertank", "JumpEnergyPerSec", "0.0")
			SetClassProperty("imp_hover_fightertank", "EnergyBar", "999999999")
			SetClassProperty("imp_hover_fightertank", "CapturePosts", "1")
			SetClassProperty("rep_hover_fightertank", "JumpTimeMin", "0.0")
			SetClassProperty("rep_hover_fightertank", "JumpTimeMax", "1.5")
			SetClassProperty("rep_hover_fightertank", "JumpForce", "50.0")
			SetClassProperty("rep_hover_fightertank", "JumpMinSpeedMult", "0.0")
			SetClassProperty("rep_hover_fightertank", "JumpEnergyPerSec", "0.0")
			SetClassProperty("rep_hover_fightertank", "EnergyBar", "999999999")
			SetClassProperty("rep_hover_fightertank", "CapturePosts", "1")
			SetClassProperty("all_hover_combatspeeder", "CollisionScale", "0.0 0.0 0.0")
			SetClassProperty("cis_hover_aat", "CollisionScale", "0.0 0.0 0.0")
			SetClassProperty("imp_hover_fightertank", "CollisionScale", "0.0 0.0 0.0")
			SetClassProperty("rep_hover_fightertank", "CollisionScale", "0.0 0.0 0.0")
			SetClassProperty("all_hover_combatspeeder", "CollisionThreshold", "0")
			SetClassProperty("cis_hover_aat", "CollisionThreshold", "0")
			SetClassProperty("imp_hover_fightertank", "CollisionThreshold", "0")
			SetClassProperty("rep_hover_fightertank", "CollisionThreshold", "0")
			SetClassProperty("all_hover_combatspeeder", "AddHealth", "25")
			SetClassProperty("cis_hover_aat", "AddHealth", "25")
			SetClassProperty("imp_hover_fightertank", "AddHealth", "25")
			SetClassProperty("rep_hover_fightertank", "AddHealth", "25")
        end
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[Galactic Conquest Powerups]", "Turn on galactic conquest bonueses for team 1 or team 2.", nil, nil)
    ff_AddCommand(
        "Bonus Team 1 Enhanced Blasters",
        nil,
        function()
            ActivateBonus(1, "team_bonus_advanced_blasters")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 1 Bacta Tanks",
        nil,
        function()
            ActivateBonus(1, "team_bonus_bacta_tanks")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 1 Combat Shielding",
        nil,
        function()
            ActivateBonus(1, "team_bonus_combat_shielding")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 1 Energy Boost",
        nil,
        function()
            ActivateBonus(1, "team_bonus_energy_boost")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 1 Garrison",
        nil,
        function()
            ActivateBonus(1, "team_bonus_garrison")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 1 Leader",
        nil,
        function()
            ActivateBonus(1, "team_bonus_leader")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 1 Sabotage",
        nil,
        function()
            ActivateBonus(1, "team_bonus_sabotage")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Enhanced Blasters",
        nil,
        function()
            ActivateBonus(2, "team_bonus_advanced_blasters")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Bacta Tanks",
        nil,
        function()
            ActivateBonus(2, "team_bonus_bacta_tanks")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Combat Shielding",
        nil,
        function()
            ActivateBonus(2, "team_bonus_combat_shielding")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Energy Boost",
        nil,
        function()
            ActivateBonus(2, "team_bonus_energy_boost")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Garrison",
        nil,
        function()
            ActivateBonus(2, "team_bonus_garrison")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Leader",
        nil,
        function()
            ActivateBonus(2, "team_bonus_leader")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Sabotage",
        nil,
        function()
            ActivateBonus(2, "team_bonus_sabotage")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 1 Auto Turrets",
        nil,
        function()
            ff_serverDoesCrash()
            ActivateBonus(1, "team_bonus_autoturrets")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 1 Supplies",
        nil,
        function()
            ff_serverDoesCrash()
            ActivateBonus(2, "team_bonus_supplies")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Auto Turrets",
        nil,
        function()
            ff_serverDoesCrash()
            ActivateBonus(2, "team_bonus_autoturrets")
        end,
        nil
    )
    ff_AddCommand(
        "Bonus Team 2 Supplies",
        nil,
        function()
            ff_serverDoesCrash()
            ActivateBonus(2, "team_bonus_supplies")
        end,
        nil
    )
    ff_AddCommand("", nil, nil, nil)
    ff_AddCommand("[Current Level]", "These commands will manipulate certain items in different levels.", nil, nil)
    if __thisMapsCode__ == "cor" then
        ff_AddCommand(
            "Invincible Bookcases",
            "This makes all library bookcases invincible.",
            function()
                SetProperty("LibCase1", "MaxHealth", 999999999)
                SetProperty("LibCase2", "MaxHealth", 999999999)
                SetProperty("LibCase3", "MaxHealth", 999999999)
                SetProperty("LibCase4", "MaxHealth", 999999999)
                SetProperty("LibCase5", "MaxHealth", 999999999)
                SetProperty("LibCase6", "MaxHealth", 999999999)
                SetProperty("LibCase7", "MaxHealth", 999999999)
                SetProperty("LibCase8", "MaxHealth", 999999999)
                SetProperty("LibCase9", "MaxHealth", 999999999)
                SetProperty("LibCase10", "MaxHealth", 999999999)
                SetProperty("LibCase11", "MaxHealth", 999999999)
                SetProperty("LibCase12", "MaxHealth", 999999999)
                SetProperty("LibCase13", "MaxHealth", 999999999)
                SetProperty("LibCase14", "MaxHealth", 999999999)
            end
        )
        ff_AddCommand(
            "Kill Bookcases",
            "This destroys all the library bookcases.",
            function()
                KillObject("LibCase1")
                KillObject("LibCase2")
                KillObject("LibCase3")
                KillObject("LibCase4")
                KillObject("LibCase5")
                KillObject("LibCase6")
                KillObject("LibCase7")
                KillObject("LibCase8")
                KillObject("LibCase9")
                KillObject("LibCase10")
                KillObject("LibCase11")
                KillObject("LibCase12")
                KillObject("LibCase13")
                KillObject("LibCase14")
            end
        )
        ff_AddCommand(
            "Respawn Bookcases",
            "Rebuild any bookcases if they are broken.",
            function()
                RespawnObject("LibCase1")
                RespawnObject("LibCase2")
                RespawnObject("LibCase3")
                RespawnObject("LibCase4")
                RespawnObject("LibCase5")
                RespawnObject("LibCase6")
                RespawnObject("LibCase7")
                RespawnObject("LibCase8")
                RespawnObject("LibCase9")
                RespawnObject("LibCase10")
                RespawnObject("LibCase11")
                RespawnObject("LibCase12")
                RespawnObject("LibCase13")
                RespawnObject("LibCase14")
            end
        )
        ff_AddCommand(
            "All Bookcases Enemy",
            "The bookcases all have an enemy value to teams 1 and 2",
            function()
                SetProperty("LibCase1", "Team", 3)
                SetProperty("LibCase2", "Team", 3)
                SetProperty("LibCase3", "Team", 3)
                SetProperty("LibCase4", "Team", 3)
                SetProperty("LibCase5", "Team", 3)
                SetProperty("LibCase6", "Team", 3)
                SetProperty("LibCase7", "Team", 3)
                SetProperty("LibCase8", "Team", 3)
                SetProperty("LibCase9", "Team", 3)
                SetProperty("LibCase10", "Team", 3)
                SetProperty("LibCase11", "Team", 3)
                SetProperty("LibCase12", "Team", 3)
                SetProperty("LibCase13", "Team", 3)
                SetProperty("LibCase14", "Team", 3)
            end
        )
        ff_AddCommand(
            "Activate Hidden Turret",
            "This activates a hidden turret and marks it with a white arrow.",
            function()
                MapAddEntityMarker("tur_bldg_laser13", "hud_objective_icon_circle", 3.5, DEF, "WHITE", true)
                MapAddEntityMarker("tur_bldg_laser13", "hud_objective_icon_circle", 3.5, ATT, "WHITE", true)
                SetProperty("tur_bldg_laser13", "AddHealth", 5000)
            end
        )
    end
    if __thisMapsCode__ == "dag" then
        ff_AddCommand(
            "Kill Old Ship",
            "Destroy the ship in the middle of the swamp.",
            function()
                KillObject("dag1_prop_x-wing")
                KillObject("dag1_prop_destroyed_gunship")
            end
        )
        ff_AddCommand(
            "Respawn Old Ship",
            "Respawn the old gunship in the middle of the swamp.",
            function()
                RespawnObject("dag1_prop_x-wing")
                RespawnObject("dag1_prop_destroyed_gunship")
            end
        )
        ff_AddCommand(
            "Old Ship Allow Damage",
            "Allows you to attack the old ship.",
            function()
                SetProperty("dag1_prop_x-wing", "MaxHealth", 500)
                SetProperty("dag1_prop_destroyed_gunship", "MaxHealth", 500)
            end
        )
        ff_AddCommand(
            "Old Ship Team 3",
            "Sets the old ship in the mud as enemy to teams 1 and 2.",
            function()
                SetProperty("dag1_prop_x-wing", "Team", 3)
                SetProperty("dag1_prop_destroyed_gunship", "Team", 3)
            end
        )
        ff_AddCommand(
            "Old Ship Invincible",
            "Prevents the old ship in the mud from being destroyed.",
            function()
                SetProperty("dag1_prop_x-wing", "MaxHealth", 999999999)
                SetProperty("dag1_prop_destroyed_gunship", "MaxHealth", 999999999)
            end
        )
    end
    if __thisMapsCode__ == "dea" then
        ff_AddCommand(
            "Kill Grate",
            "Break the trash compactor door.",
            function()
                KillObject("grate01")
            end
        )
        ff_AddCommand(
            "Respawn Grate",
            "Respawn the trash compactor door.",
            function()
                RespawnObject("grate01")
            end
        )
        ff_AddCommand(
            "Invincible Grate",
            "Makes the trash room gate unbreakable.",
            function()
                SetProperty("grate01", "MaxHealth", 999999999)
            end
        )
        ff_AddCommand(
            "Grate Team 3",
            "Sets the trash room door to be of an enemy value.",
            function()
                SetProperty("grate01", "Team", 3)
            end
        )
        ff_AddCommand(
            "Break Bridges",
            "Make the bridges disconnect.",
            function()
                KillObject("Panel-Tak")
                KillObject("Panel-Chasm")
            end
        )
        ff_AddCommand(
            "Build Bridges",
            "Make the bridges connect.",
            function()
                RespawnObject("Panel-Tak")
                RespawnObject("Panel-Chasm")
            end
        )
    end
    if __thisMapsCode__ == "end" then
        ff_AddCommand(
            "Kill Control Panel",
            "Break the computer console in the bunker.",
            function()
                KillObject("panel")
            end
        )
        ff_AddCommand(
            "Respawn Control Panel",
            "Respawn the computer console in the bunker.",
            function()
                RespawnObject("panel")
            end
        )
    end
    if __thisMapsCode__ == "fel" then
    end
    if __thisMapsCode__ == "geo" then
    end
    if __thisMapsCode__ == "hot" then
        ff_AddCommand(
            "Kill Generator",
            "Destroys the shield generator.",
            function()
                KillObject("shield")
            end
        )
        ff_AddCommand(
            "Rebuild Genetator",
            "Repair the shield generator,",
            function()
                RespawnObject("shield")
            end
        )
        ff_AddCommand(
            "Unlock Generator",
            "Allows the shield generator to become capturable.",
            function()
                SetProperty("shield", "Radius", 30)
            end
        )
        ff_AddCommand(
            "Generator Neutral",
            "Sets the generator to neutral color so anyone can claim it.",
            function()
                SetProperty("shield", "Team", 0)
            end
        )
        ff_AddCommand(
            "Add Command Center Base",
            "Adds a command post between the hangar and the bunker, this base is not required to win the map.",
            function()
                RespawnObject("CP7")
            end
        )
        ff_AddCommand(
            "CTF - Kill Shuttles",
            "Destroy the 2 or 3 shuttles that belong to the rebels.",
            function()
                KillObject("ship")
                KillObject("ship2")
                KillObject("ship3")
            end
        )
        ff_AddCommand(
            "CTF - Respawn Shuttles",
            "Respawn the 2 or 3 shuttles that belong to the rebels.",
            function()
                RespawnObject("ship")
                RespawnObject("ship2")
                RespawnObject("ship3")
            end
        )
        ff_AddCommand(
            "CTF - Shuttles Breakable",
            "Allow the shuttles to be destroyed by the Empire.",
            function()
                SetProperty("ship", "MaxHealth", 1000)
                SetProperty("ship2", "MaxHealth", 1000)
                SetProperty("ship3", "MaxHealth", 1000)
            end
        )
        ff_AddCommand(
            "CTF - Kill Turrets",
            "Destroy all of the auto turrets in each hangar.",
            function()
                KillObject("tur_bldg_chaingun_tripod18")
                KillObject("tur_bldg_chaingun_tripod17")
                KillObject("tur_bldg_chaingun_tripod16")
                KillObject("tur_bldg_chaingun_tripod15")
                KillObject("gun1")
                KillObject("tur_bldg_chaingun_tripod9")
                KillObject("tur_bldg_chaingun_tripod8")
                KillObject("tur_bldg_chaingun_tripod6")
                KillObject("tur_bldg_chaingun_tripod5")
                KillObject("tur_bldg_chaingun_tripod4")
                KillObject("tur_bldg_chaingun_tripod3")
                KillObject("tur_bldg_chaingun_tripod2")
                KillObject("tur_bldg_chaingun_tripod10")
                KillObject("tur_bldg_chaingun_tripod1")
            end
        )
        ff_AddCommand(
            "CTF - Respawn Turrets",
            "Respawn all of the auto turrets in each hangar.",
            function()
                RespawnObject("tur_bldg_chaingun_tripod18")
                RespawnObject("tur_bldg_chaingun_tripod17")
                RespawnObject("tur_bldg_chaingun_tripod16")
                RespawnObject("tur_bldg_chaingun_tripod15")
                RespawnObject("gun1")
                RespawnObject("tur_bldg_chaingun_tripod9")
                RespawnObject("tur_bldg_chaingun_tripod8")
                RespawnObject("tur_bldg_chaingun_tripod6")
                RespawnObject("tur_bldg_chaingun_tripod5")
                RespawnObject("tur_bldg_chaingun_tripod4")
                RespawnObject("tur_bldg_chaingun_tripod3")
                RespawnObject("tur_bldg_chaingun_tripod2")
                RespawnObject("tur_bldg_chaingun_tripod10")
                RespawnObject("tur_bldg_chaingun_tripod1")
            end
        )
        ff_AddCommand(
            "CTF - Turrets Hostile",
            "All of the auto turrets attack both sides.",
            function()
                SetProperty("tur_bldg_chaingun_tripod18", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod17", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod16", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod15", "Team", 3)
                SetProperty("gun1", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod9", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod8", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod6", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod5", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod4", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod3", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod2", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod10", "Team", 3)
                SetProperty("tur_bldg_chaingun_tripod1", "Team", 3)
            end
        )
        ff_AddCommand(
            "CTF - Animate Shuttles",
            "This plays the shuttle take off animations.",
            function()
                PlayAnimation("takeoff")
                PlayAnimation("takeoff2")
            end
        )
        ff_AddCommand(
            "CTF - Console Hostile",
            "This sets the computer in the command hallway to be hostile.",
            function()
                SetProperty("Console", "Team", 3)
            end
        )
        ff_AddCommand(
            "CTF - Respawn Console",
            "Respawn the console in the command base if it has been broken.",
            function()
                RespawnObject("Console")
            end
        )
        ff_AddCommand(
            "CTF - Kill Console",
            "Kill the console in the command base.",
            function()
                KillObject("Console")
            end
        )
        ff_AddCommand(
            "CTF - Weaken Barricades",
            "This weakens the green barriers in the command hallway so you can access that space.",
            function()
                SetProperty("echo_shield1", "IsCollidable", 0)
                SetProperty("echo_shield2", "IsCollidable", 0)
            end
        )
        ff_AddCommand(
            "CTF - Add Bases",
            "Add command posts in the command center hallway and in the rebel hangar.",
            function()
                RespawnObject("CP7OBJ")
                RespawnObject("hangarcp")
            end
        )
    end
    if __thisMapsCode__ == "kam" then
        ff_AddCommand(
            "Kill Computers",
            "Break all the computer consoles in both buildings.",
            function()
                KillObject("comp1")
                KillObject("comp2")
                KillObject("comp3")
                KillObject("comp4")
                KillObject("comp5")
                KillObject("comp10")
                KillObject("comp20")
                KillObject("comp30")
                KillObject("comp40")
                KillObject("comp50")
            end
        )
        ff_AddCommand(
            "Respawn Computers",
            "Break all the computer consoles in both buildings.",
            function()
                RespawnObject("comp1")
                RespawnObject("comp2")
                RespawnObject("comp3")
                RespawnObject("comp4")
                RespawnObject("comp5")
                RespawnObject("comp10")
                RespawnObject("comp20")
                RespawnObject("comp30")
                RespawnObject("comp40")
                RespawnObject("comp50")
            end
        )
        ff_AddCommand(
            "Hostile Computers",
            "Set all the computers as hostile.",
            function()
                SetProperty("comp1", "Team", 3)
                SetProperty("comp2", "Team", 3)
                SetProperty("comp3", "Team", 3)
                SetProperty("comp4", "Team", 3)
                SetProperty("comp5", "Team", 3)
                SetProperty("comp10", "Team", 3)
                SetProperty("comp20", "Team", 3)
                SetProperty("comp30", "Team", 3)
                SetProperty("comp40", "Team", 3)
                SetProperty("comp50", "Team", 3)
            end
        )
        ff_AddCommand(
            "CTF - Add Middle Base",
            "Spawn a capturable command post in the middle of the map.",
            function()
                RespawnObject("CP4")
            end
        )
    end
    if __thisMapsCode__ == "kas" then
        ff_AddCommand(
            "Activate Hidden Turret",
            "Activates and shows a hidden beam turret with a white arrow.",
            function()
                MapAddEntityMarker("com_weap_gunturret10", "hud_objective_icon_circle", 3.5, DEF, "WHITE", true)
                MapAddEntityMarker("com_weap_gunturret10", "hud_objective_icon_circle", 3.5, ATT, "WHITE", true)
                SetProperty("com_weap_gunturret10", "AddHealth", 5000)
            end
        )
        ff_AddCommand(
            "Mark Hidden Droids",
            "Show 1 hidden ammo and 1 hidden medical droid with a white arrow.",
            function()
                MapAddEntityMarker("com_item_weaponrecharge0", "hud_objective_icon_circle", 3.5, DEF, "WHITE", true)
                MapAddEntityMarker("com_item_weaponrecharge0", "hud_objective_icon_circle", 3.5, ATT, "WHITE", true)
                MapAddEntityMarker("com_item_healthrecharge6", "hud_objective_icon_circle", 3.5, DEF, "WHITE", true)
                MapAddEntityMarker("com_item_healthrecharge6", "hud_objective_icon_circle", 3.5, ATT, "WHITE", true)
            end
        )
    end
    if __thisMapsCode__ == "mus" then
        ff_AddCommand(
            "Raise Bridge",
            "Rebuild control panel to raise the bridge.",
            function()
                RespawnObject("DingDong")
            end
        )
        ff_AddCommand(
            "Kill Bridge",
            "Lower the bridge.",
            function()
                KillObject("DingDong")
            end
        )
        ff_AddCommand(
            "Bridge Control Hostile",
            "Set hostile value for bridge control panel.",
            function()
                SetProperty("DingDong", "Team", 3)
            end
        )
        ff_AddCommand(
            "Bridge Control Invincible",
            "Make bridge control panel invincible.",
            function()
                SetProperty("DingDong", "MaxHealth", 999999999)
            end
        )
    end
    if __thisMapsCode__ == "myg" then
    end
    if __thisMapsCode__ == "nab" then
        ff_AddCommand(
            "Show Fire Works",
            "Mark the hidden fireworks with a white arrow.",
            function()
                MapAddEntityMarker("nab_prop_fireworks", "hud_objective_icon_circle", 3.5, DEF, "WHITE", true)
                MapAddEntityMarker("nab_prop_fireworks", "hud_objective_icon_circle", 3.5, ATT, "WHITE", true)
            end
        )
        ff_AddCommand(
            "Play Fire Works",
            "Play the fire works animation.",
            function()
                KillObject("nab_prop_fireworks")
            end
        )
        ff_AddCommand(
            "Reset Fire Works",
            "Reset fire works animation so you can play it again.",
            function()
                RespawnObject("nab_prop_fireworks")
            end
        )
        ff_AddCommand(
            "Show Hidden CP",
            "Marks a hidden command post under the map with a white arrow.",
            function()
                MapAddEntityMarker("GuardCP", "hud_objective_icon_circle", 3.5, DEF, "WHITE", true)
                MapAddEntityMarker("GuardCP", "hud_objective_icon_circle", 3.5, ATT, "WHITE", true)
            end
        )
        ff_AddCommand(
            "Hidden CP Capturable",
            "Make the hidden command post become capturable.",
            function()
                SetProperty("GuardCP", "Radius", 35)
            end
        )
    end
    if __thisMapsCode__ == "pol" then
        ff_AddCommand(
            "Hostile Shields",
            "The 3 shield barriers become hostile.",
            function()
                SetProperty("pol1_prop_cavern_shield", "Team", 3)
                SetProperty("pol1_prop_health_shield", "Team", 3)
                SetProperty("pol1_prop_hangar_shield", "Team", 3)
            end
        )
        ff_AddCommand(
            "Kill Shields",
            "Shut down the 3 shield barriers.",
            function()
                KillObject("pol1_prop_cavern_shield")
                KillObject("pol1_prop_health_shield")
                KillObject("pol1_prop_hangar_shield")
            end
        )
        ff_AddCommand(
            "Respawn Shields",
            "Respawn the 3 shield barriers.",
            function()
                RespawnObject("pol1_prop_cavern_shield")
                RespawnObject("pol1_prop_health_shield")
                RespawnObject("pol1_prop_hangar_shield")
            end
        )
    end
    if __thisMapsCode__ == "tan" then
        ff_AddCommand(
            "Blastdoor Hostile",
            "The blast door at the ship entrance is hostile.",
            function()
                SetProperty("blastdoor", "Team", 3)
            end
        )
        ff_AddCommand(
            "Add Blastdoor",
            "Spawn the blastdoor that leads into the ship.",
            function()
                RespawnObject("blastdoor")
            end
        )
        ff_AddCommand(
            "Blastdoor Breakable",
            "Allows the blast door to be broken from attacks.",
            function()
                SetProperty("blastdoor", "MaxHealth", 2500)
            end
        )
        ff_AddCommand(
            "Kill Blastdoor",
            "Destroy the entrance blast door.",
            function()
                KillObject("blastdoor")
            end
        )
        ff_AddCommand(
            "Invincible Blastdoor",
            "Entrance blastdoor is invincible.",
            function()
                SetProperty("blastdoor", "MaxHealth", 999999999)
            end
        )
        ff_AddCommand(
            "Hostile Turbine Console",
            "Set the engine control computer to be hostile.",
            function()
                SetProperty("turbineconsole", "Team", 3)
            end
        )
        ff_AddCommand(
            "Turbine Console Neutral",
            "Set the turbine console to be nuetral.",
            function()
                SetProperty("turbineconsole", "Team", 0)
            end
        )
        ff_AddCommand(
            "Invincible Turbine Console",
            "You cannot break the turbine console.",
            function()
                SetProperty("turbineconsole", "MaxHealth", 999999999)
            end
        )
        ff_AddCommand(
            "Respawn Turbine Console",
            "Respawn the engine control computer if it has been broken.",
            function()
                RespawnObject("turbineconsole")
            end
        )
        ff_AddCommand(
            "Kill Turbine Control",
            "Destroy turbine engine console.",
            function()
                KillObject("turbineconsole")
            end
        )
    end
    if __thisMapsCode__ == "tat" then
        ff_AddCommand(
            "Unlock Assault CPs(TAT2)",
            "This makes the command posts in Hero Assault become capturable.",
            function()
                SetProperty("eli_cp1", "Radius", 25)
                SetProperty("eli_cp2", "Radius", 25)
                SetProperty("eli_cp3", "Radius", 25)
                SetProperty("eli_cp6", "Radius", 25)
                SetProperty("eli_cp7", "Radius", 25)
                SetProperty("eli_cp8", "Radius", 25)
            end
        )
        ff_AddCommand(
            "Hero Gamorreans GCW(TAT3)",
            "Add the Gamorrean Guard as a playable hero in the GCW era.",
            function()
                SetHeroClass(ALL, "gam_inf_gamorreanguard")
                SetHeroClass(IMP, "gam_inf_gamorreanguard")
            end
        )
        ff_AddCommand(
            "Hero Gamorreans CW(TAT3)",
            "Add the Gamorrean Guard as a playable hero in the CW era.",
            function()
                SetHeroClass(CIS, "gam_inf_gamorreanguard")
                SetHeroClass(REP, "gam_inf_gamorreanguard")
            end
        )
    end
    if __thisMapsCode__ == "uta" then
    end
    if __thisMapsCode__ == "yav" then
    end
    if __thisMapsCode__ == "spa" then
    end
end