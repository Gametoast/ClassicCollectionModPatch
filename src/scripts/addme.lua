---@diagnostic disable: deprecated
-- STAR WARS BATTLEFRONT CLASSIC COLLECTION - Old Mod Patcher
-- Greetings from Kenny

local __scriptName__ = "[zero_patch: addme.script]: "

print("zero_patch: Start 0/addme.script")


if(printf == nil) then
    function printf (...) print(string.format(unpack(arg))) end
end

if( tprint == nil ) then
    function getn(v)
        local v_type = type(v);
        if v_type == "table" then
            return table.getn(v);
        elseif v_type == "string" then
            return string.len(v);
        else
            return;
        end
    end

    if string.starts == nil then
        function string.starts(str, Start)
            return string.sub(str, 1, string.len(Start)) == Start;
        end
    end

    function tprint(t, indent)
        if not indent then indent = 1, print(tostring(t) .. " {") end
        if t then
            for key,value in pairs(t) do
                if not string.starts(tostring(key), "__") then
                    local formatting = string.rep("    ", indent) .. tostring(key) .. "= ";
                    if value and type(value) == "table" then
                        print(formatting .. --[[tostring(value) ..]] " {")
                        tprint(value, indent+1);
                    else
                        if(type(value) == "string") then
                            --print(formatting .."'" .. tostring(value) .."'" ..",")
                            printf("%s'%s',",formatting, tostring(value))
                        else
                            print(formatting .. tostring(value) ..",")
                        end
                    end
                end
            end
            print(string.rep("    ", indent - 1) .. "},")
        end
    end
end

---

-- functionality to add strings
if( modStringTable == nil ) then
	modStringTable = {} -- table to hold custom strings

	-- function to add custom strings
	function addModString(stringId, content)
		modStringTable[stringId] = ScriptCB_tounicode(content)
	end

	if oldScriptCB_getlocalizestr == nil then
		-- Overwrite 'ScriptCB_getlocalizestr()' to first check for the strings we added
		print("redefine: ScriptCB_getlocalizestr() ")

		oldScriptCB_getlocalizestr = ScriptCB_getlocalizestr
		ScriptCB_getlocalizestr = function (...)
			local stringId = " "
			if( table.getn(arg) > 0 ) then
				stringId = arg[1]
			end
			if( modStringTable[stringId] ~= nil) then -- first check 'our' strings
				retVal = modStringTable[stringId]
			else
				retVal = oldScriptCB_getlocalizestr( unpack(arg) )
			end
			return retVal
		end
	end
end
-- Force 'IFText_fnSetString' to use strings from our 'modStringTable' too
if ( oldIFText_fnSetString == nil )then
    oldIFText_fnSetString = IFText_fnSetString
    IFText_fnSetString = function(...)
        if( table.getn(arg) > 1 and modStringTable[arg[2]] ~= nil ) then
            arg[2] = modStringTable[arg[2]]
            IFText_fnSetUString(unpack(arg))
            return
        end
        oldIFText_fnSetString(unpack(arg))
    end
end

addModString("ifs.console.action","Instant Action (alt)")
--
----- ADD uop eras & modes--------------------------------------------------------------------------------------
print("zero_patch: Add UOP Eras and Game Modes: Start")
uopMapEras = {
    { Team2Name= 'common.sides.cis.name', key= 'era_c', icon2= 'rep_icon', subst= 'c', showstr= 'common.era.cw', icon1= 'cis_icon', Team1Name= 'common.sides.rep.name', },
    { Team2Name= 'common.sides.imp.name', key= 'era_g', icon2= 'all_icon', subst= 'g', showstr= 'common.era.gcw', icon1= 'imp_icon', Team1Name= 'common.sides.all.name', },
    { Team2Name= 'common.sides.k.name', key= 'era_k', icon2= 'kotor_icon', subst= 'k', showstr= 'common.era.k', icon1= 'k_icon', Team1Name= 'common.sides.k.name', },
    { Team2Name= 'common.sides.n.name', key= 'era_n', icon2= 'newrep_icon', subst= 'n', showstr= 'common.era.n', icon1= 'n_icon', Team1Name= 'common.sides.n.name', },
    { Team2Name= 'common.sides.y.name', key= 'era_y', icon2= 'yuz_icon', subst= 'y', showstr= 'common.era.y', icon1= 'y_icon', Team1Name= 'common.sides.y.name', },
    { Team2Name= 'common.sides.a.name', key= 'era_a', icon2= 'bfx_cw_icon', subst= 'a', showstr= 'common.era.a', icon1= 'a_icon', Team1Name= 'common.sides.a.name', },
    { Team2Name= 'common.sides.b.name', key= 'era_b', icon2= 'bfx_gcw_icon', subst= 'b', showstr= 'common.era.b', icon1= 'b_icon', Team1Name= 'common.sides.b.name', },
    { Team2Name= 'common.sides.d.name', key= 'era_d', icon2= 'newsithwars_icon', subst= 'd', showstr= 'common.era.d', icon1= 'd_icon', Team1Name= 'common.sides.d.name', },
    { Team2Name= 'common.sides.e.name', key= 'era_e', icon2= 'earth_icon', subst= 'e', showstr= 'common.era.e', icon1= 'e_icon', Team1Name= 'common.sides.e.name', },
    { Team2Name= 'common.sides.f.name', key= 'era_f', icon2= 'front_icon', subst= 'f', showstr= 'common.era.f', icon1= 'f_icon', Team1Name= 'common.sides.f.name', },
    { Team2Name= 'common.sides.h.name', key= 'era_h', icon2= 'halo_icon', subst= 'h', showstr= 'common.era.h', icon1= 'h_icon', Team1Name= 'common.sides.h.name', },
    { Team2Name= 'common.sides.i.name', key= 'era_i', icon2= 'i_icon', subst= 'i', showstr= 'common.era.i', icon1= 'i_icon', Team1Name= 'common.sides.i.name', },
    { Team2Name= 'common.sides.j.name', key= 'era_j', icon2= 'j_icon', subst= 'j', showstr= 'common.era.j', icon1= 'j_icon', Team1Name= 'common.sides.j.name', },
    { Team2Name= 'common.sides.l.name', key= 'era_l', icon2= 'lego_icon', subst= 'l', showstr= 'common.era.l', icon1= 'l_icon', Team1Name= 'common.sides.l.name', },
    { Team2Name= 'common.sides.m.name', key= 'era_m', icon2= 'imp_icon', subst= 'm', showstr= 'common.era.m', icon1= 'm_icon', Team1Name= 'common.sides.m.name', },
    { Team2Name= 'common.sides.o.name', key= 'era_o', icon2= 'oldsith_icon', subst= 'o', showstr= 'common.era.o', icon1= 'o_icon', Team1Name= 'common.sides.o.name', },
    { Team2Name= 'common.sides.p.name', key= 'era_p', icon2= 'rep_icon', subst= 'p', showstr= 'common.era.p', icon1= 'p_icon', Team1Name= 'common.sides.p.name', },
    { Team2Name= 'common.sides.q.name', key= 'era_q', icon2= 'all_icon', subst= 'q', showstr= 'common.era.q', icon1= 'q_icon', Team1Name= 'common.sides.q.name', },
    { Team2Name= 'common.sides.r.name', key= 'era_r', icon2= 'rvb_icon', subst= 'r', showstr= 'common.era.r', icon1= 'r_icon', Team1Name= 'common.sides.r.name', },
    { Team2Name= 'common.sides.s.name', key= 'era_s', icon2= 'rebirth_icon', subst= 's', showstr= 'common.era.s', icon1= 's_icon', Team1Name= 'common.sides.s.name', },
    { Team2Name= 'common.sides.t.name', key= 'era_t', icon2= 'toys_icon', subst= 't', showstr= 'common.era.t', icon1= 't_icon', Team1Name= 'common.sides.t.name', },
    { Team2Name= 'common.sides.u.name', key= 'era_u', icon2= 'u_icon', subst= 'u', showstr= 'common.era.u', icon1= 'u_icon', Team1Name= 'common.sides.u.name', },
    { Team2Name= 'common.sides.v.name', key= 'era_v', icon2= 'v_icon', subst= 'v', showstr= 'common.era.v', icon1= 'v_icon', Team1Name= 'common.sides.v.name', },
    { Team2Name= 'common.sides.w.name', key= 'era_w', icon2= 'wacky_icon', subst= 'w', showstr= 'common.era.w', icon1= 'w_icon', Team1Name= 'common.sides.w.name', },
    { Team2Name= 'common.sides.x.name', key= 'era_x', icon2= 'exGCW_icon', subst= 'x', showstr= 'common.era.x', icon1= 'x_icon', Team1Name= 'common.sides.x.name', },
    { Team2Name= 'common.sides.z.name', key= 'era_z', icon2= 'z_icon', subst= 'z', showstr= 'common.era.z', icon1= 'z_icon', Team1Name= 'common.sides.z.name', },
    { Team2Name= 'common.sides.1.name', key= 'era_1', icon2= 'cis_icon', subst= '1', showstr= 'common.era.1', icon1= '1_icon', Team1Name= 'common.sides.1.name', },
    { Team2Name= 'common.sides.2.name', key= 'era_2', icon2= 'imp_icon', subst= '2', showstr= 'common.era.2', icon1= '2_icon', Team1Name= 'common.sides.2.name', },
}



uopMapModes = {
    { key= 'mode_con', subst= 'con', showstr= 'modename.name.con', descstr= 'modename.description.con', icon= 'mode_icon_con', },
    { key= 'mode_ctf', subst= 'ctf', showstr= 'modename.name.ctf', descstr= 'modename.description.ctf', icon= 'mode_icon_2ctf', },
    { key= 'mode_1flag', subst= '1flag', showstr= 'modename.name.1flag', descstr= 'modename.description.1flag', icon= 'mode_icon_ctf', },
    { key= 'mode_assault', subst= 'ass', showstr= 'modename.name.spa-assault', descstr= 'modename.description.assault', icon= 'mode_icon_ass', },
    { key= 'mode_hunt', subst= 'hunt', showstr= 'modename.name.hunt', descstr= 'modename.description.hunt', icon= 'mode_icon_hunt', },
    { key= 'mode_eli', subst= 'eli', showstr= 'modename.name.hero-assault', descstr= 'modename.description.elimination', icon= 'mode_icon_eli', },
    { key= 'mode_tdm', subst= 'tdm', showstr= 'modename.name.tdm', descstr= 'modename.description.tdm', icon= 'mode_icon_tdm', },
    { key= 'mode_xl', subst= 'xl', showstr= 'modename.name.xl', descstr= 'modename.description.xl', icon= 'mode_icon_xl', },
    { key= 'mode_obj', subst= 'obj', showstr= 'modename.name.obj', descstr= 'modename.description.obj', icon= 'mode_icon_obj', },
    { key= 'mode_c', subst= 'c', showstr= 'modename.name.c', descstr= 'modename.description.c', icon= 'mode_icon_c', },
    { key= 'mode_uber', subst= 'uber', showstr= 'modename.name.uber', descstr= 'modename.description.uber', icon= 'mode_icon_uber', },
    { key= 'mode_bf1', subst= 'bf1', showstr= 'modename.name.bf1', descstr= 'modename.description.bf1', icon= 'mode_icon_bf1', },
    { key= 'mode_holo', subst= 'holo', showstr= 'modename.name.holo', descstr= 'modename.description.holo', icon= 'mode_icon_holo', },
    { key= 'mode_ord66', subst= 'ord66', showstr= 'modename.name.ord66', descstr= 'modename.description.ord66', icon= 'mode_icon_ord66', },
    { key= 'mode_dm', subst= 'dm', showstr= 'modename.name.dm', descstr= 'modename.description.dm', icon= 'mode_icon_dm', },
    { key= 'mode_space', subst= 'space', showstr= 'modename.name.space', descstr= 'modename.description.space', icon= 'mode_icon_space', },
    { key= 'mode_c1', subst= 'c1', showstr= 'modename.name.c1', descstr= 'modename.description.c1', icon= 'mode_icon_c1', },
    { key= 'mode_c2', subst= 'c2', showstr= 'modename.name.c2', descstr= 'modename.description.c2', icon= 'mode_icon_c2', },
    { key= 'mode_c3', subst= 'c3', showstr= 'modename.name.c3', descstr= 'modename.description.c3', icon= 'mode_icon_c3', },
    { key= 'mode_c4', subst= 'c4', showstr= 'modename.name.c4', descstr= 'modename.description.c4', icon= 'mode_icon_c4', },
    { key= 'mode_hctf', subst= 'hctf', showstr= 'modename.name.hctf', descstr= 'modename.description.hctf', icon= 'mode_icon_hctf', },
    { key= 'mode_vhcon', subst= 'vhcon', showstr= 'modename.name.vhcon', descstr= 'modename.description.vhcon', icon= 'mode_icon_vehicle', },
    { key= 'mode_vhtdm', subst= 'vhtdm', showstr= 'modename.name.vhtdm', descstr= 'modename.description.vhtdm', icon= 'mode_icon_vehicle', },
    { key= 'mode_vhctf', subst= 'vhctf', showstr= 'modename.name.vhctf', descstr= 'modename.description.vhctf', icon= 'mode_icon_vehicle', },
    { key= 'mode_avh', subst= 'avh', showstr= 'modename.name.avh', descstr= 'modename.description.avh', icon= 'mode_icon_avh', },
    { key= 'mode_lms', subst= 'lms', showstr= 'modename.name.lms', descstr= 'modename.description.lms', icon= 'mode_icon_lms', },
    { key= 'mode_vh', subst= 'vh', showstr= 'modename.name.vh', descstr= 'modename.description.vh', icon= 'mode_icon_vehicle', },
    { key= 'mode_race', subst= 'race', showstr= 'modename.name.race', descstr= 'modename.description.race', icon= 'mode_icon_race', },
    { key= 'mode_koh', subst= 'koh', showstr= 'modename.name.koh', descstr= 'modename.description.koh', icon= 'mode_icon_koh', },
    { key= 'mode_tdf', subst= 'tdf', showstr= 'modename.name.tdf', descstr= 'modename.description.tdf', icon= 'mode_icon_tdf', },
    { key= 'mode_surv', subst= 'surv', showstr= 'modename.name.surv', descstr= 'modename.description.surv', icon= 'mode_icon_survival', },
    { key= 'mode_rpg', subst= 'rpg', showstr= 'modename.name.rpg', descstr= 'modename.description.rpg', icon= 'mode_icon_rpg', },
    { key= 'mode_wav', subst= 'wav', showstr= 'modename.name.wav', descstr= 'modename.description.wav', icon= 'mode_icon_wav', },
    { key= 'mode_ctrl', subst= 'ctrl', showstr= 'modename.name.ctrl', descstr= 'modename.description.ctrl', icon= 'mode_icon_control', },
    { key= 'mode_seige', subst= 'seige', showstr= 'modename.name.seige', descstr= 'modename.description.seige', icon= 'mode_icon_siege', },
    { key= 'mode_siege', subst= 'siege', showstr= 'modename.name.siege', descstr= 'modename.description.siege', icon= 'mode_icon_siege', },
    { key= 'mode_jhu', subst= 'jhu', showstr= 'modename.name.jhu', descstr= 'modename.description.jhu', icon= 'mode_icon_jhu', },
    { key= 'mode_wea', subst= 'wea', showstr= 'modename.name.wea', descstr= 'modename.description.wea', icon= 'mode_icon_wea', },
    { key= 'mode_ins', subst= 'ins', showstr= 'modename.name.ins', descstr= 'modename.description.ins', icon= 'mode_icon_ins', },
}

function zero_patch_AddEra(entry)
    if( entry.key ~= nil and entry.showstr ~= nil and entry.subst ~= nil and
         entry.Team1Name ~= nil and entry.Team2Name ~= nil  ) then
        ---------- check if it's already present ----------
        for key,value in gMapEras do -- check if entry is already present
            if( value.key == entry.key) then
                print("zero_patch_AddEra(): Era with key '".. value.key .. "' is already present.")
                return
            end
        end
        if(entry.icon1 == nil) then
            print("zero_patch_AddEra: Warning, adding era without property 'icon1'")
        end
        ---------------------------------------------------
        table.insert( gMapEras, entry )
        print("zero_patch_AddEra(): added Era: "  .. tostring(entry.key))
    else
        print("zero_patch_AddEra: Error adding Era. Must specify properties [key, showstr, subst, Team1Name, Team2Name ]\n" ..
            "See 'gMapEras' (missionlist.lua) to see format of existing eras.")
    end
end
function zero_patch_AddGameMode(entry)
    if( entry.key ~= nil and entry.showstr ~= nil and entry.descstr ~= nil and entry.subst ~= nil ) then
        ---------- check if it's already present ----------
        for key,value in gMapModes do
            if( value.key == entry.key) then
                print("zero_patch_AddGameMode(): Mode with key '".. value.key .. "' is already present.")
                return
            end
        end
        if(entry.icon == nil) then
            print("zero_patch_AddGameMode: Warning, adding game mode without property 'icon'")
        end
        ---------------------------------------------------
        table.insert( gMapModes, entry )
        print("zero_patch_AddGameMode(): added Era: " .. tostring(entry.key))
    else
        print("zero_patch_AddGameMode: Error adding Game mode. Must specify [key, showstr, descstr, subst]\n" ..
            "See 'gMapModes' to see format of existing Game mode entries.")
    end
end

if( custom_GetSPMissionList  == nil ) then -- will be nil if the game doesn't have the 1.3 un-official patch
    print("zero_patch: Add UOP Eras and Game Modes: Start")
    local i = 1
    local limit = table.getn(uopMapEras)
    while i < limit do
        zero_patch_AddEra(uopMapEras[i])
        i = i + 1
    end

    i = 1
    limit = table.getn(uopMapModes)
    while i < limit do
        zero_patch_AddGameMode(uopMapModes[i])
        i = i + 1
    end
    print("zero_patch: Add UOP Eras and Game Modes: End")
else
    print("zero_patch: WARNING! zero_patch is not compatible with UOP!!!")
end

-- A place to attach settings to.
-- TODO: Implement Save Settings to .gc file
zero_patch_data = { greeting = "Hello"}

ScriptCB_DoFile("ifs_missionselect_console")
ScriptCB_DoFile("ifs_mod_menu_tree")

-- from ifs_instant_top.lua
--ScriptCB_SetIFScreen("ifs_missionselect")

function OverrideInstantAction()
	local old_ScriptCB_SetIFScreen = ScriptCB_SetIFScreen
	ScriptCB_SetIFScreen = function(...)
		local screen_name = arg[1]
        print("ScriptCB_SetIFScreen: ".. screen_name)
		if(screen_name == "ifs_missionselect" ) then
			arg[1] = "ifs_missionselect_console"
        end
		return old_ScriptCB_SetIFScreen(unpack(arg))
	end
end
if( ScriptCB_IsFileExist("..\\..\\addon2\\0\\patch_scripts\\patch_paths.script") == 1 ) then
    -- only do this for classic collection
    -- give user option to not use the replacement instant action screen
    if( ScriptCB_IsFileExist("..\\..\\addon2\\0\\shell-options\\use_0_patch_instant_action_screen.txt") == 1 ) then
        print("overriding instant action screen")
        OverrideInstantAction()
    end
end

function HandleCustomGC(tag)
    if custom_PressedGCButton(tag) ~= nil then
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
        ifs_movietrans_PushScreen(ifs_freeform_main)
    end
end

-- Temp Solution? for Custom GC
local addon_gc_list = custom_GetGCButtonList()
local display_text = ""
local custom_gc_count = table.getn(addon_gc_list)
if( custom_gc_count > 0 ) then
    print("info: addon_gc_list.count: " .. custom_gc_count)
    local gc_menu = {}
    -- from gc docs -> local ourButton = { tag = gcTag, string = gcString, }
    for _, value in addon_gc_list do
        display_text = value.string
        if(string.find(display_text, "%.")) then -- try to localize
            print("info: try to localize " .. value.string)
            display_text = ScriptCB_ununicode( ScriptCB_getlocalizestr(display_text))
            if(display_text) then
                display_text = display_text
            end
        else
            display_text = value.string
        end
        AddModMenuItem(value.tag, display_text, HandleCustomGC, gc_menu)
    end
    AddModMenuItem("gc_menu", "Custom GC Mods ", gc_menu)
end

AddModMenuItem( "IA",  "Instant Action (alt)", "ifs_missionselect_console")
AddModMenuItem( "IA",  "Instant Action", "ifs_missionselect")
AddModMenuItem( "campaignList",  "ifs.sp.campaign", "ifs_sp_briefing")
AddModMenuItem( "font_test",  "font test", "ifs_fonttest")
AddModMenuItem("spacetraining", "Space Training", "ifs_spacetraining") -- add back in a way to get to this
AddModMenuItem("ifs_ingame_log", "Debug Log", "ifs_ingame_log")

ifs_mod_menu_tree.SaveSettings = function(this)
    print("TODO: Implement Save Settings")
end

-- keep track of the addon missions, for fun.
zero_patch_addon_mission_list = {}

-- keep track of mission count
__ADDDOWNLOADABLECONTENT_COUNT__ = 0 -- same name from uop
local oldAddDownloadableContent = AddDownloadableContent
AddDownloadableContent = function(mapLuaFile, missionName, defaultMemoryModelPlus)
  __ADDDOWNLOADABLECONTENT_COUNT__ = __ADDDOWNLOADABLECONTENT_COUNT__ + 1
  table.insert(zero_patch_addon_mission_list,missionName)
  return oldAddDownloadableContent(mapLuaFile, missionName, defaultMemoryModelPlus)
end

-- stringify a table into "key:value;" pairs.
-- Won't truncate a key/value pair but will stop serializing key-value pairs
-- when the limit is reached.
local function stringify(data, maxSize)
    local retVal = ""
    for key, value in data do
        retVal = retVal .. string.format("%s:%s;", key,value)
        if( maxSize ~= nil and string.len(retVal) > maxSize)then
            print("stringify maxSize reached.")
            break
        end
    end
    return retVal
end

-- Plumb through 'zero_patch_data' to ingame
local zeroPatch_original_ScriptCB_EnterMission = ScriptCB_EnterMission
ScriptCB_EnterMission = function()
    print("ScriptCB_EnterMission ")
    local missionSetup = { }
    if ScriptCB_IsMissionSetupSaved() then
        missionSetup = ScriptCB_LoadMissionSetup()
    end
    -- attach the data
    missionSetup.zero_patch_data = stringify(zero_patch_data, 200)
    ScriptCB_SaveMissionSetup(missionSetup)
    print("ScriptCB_EnterMission calling orig ScriptCB_EnterMission ...")
    zeroPatch_original_ScriptCB_EnterMission()
end

local orig_ScriptCB_SaveMissionSetup = ScriptCB_SaveMissionSetup
ScriptCB_SaveMissionSetup = function(missionSetup)
	if( missionSetup~= nil and missionSetup.zero_patch_data == nil and zero_patch_data ~= nil) then
		missionSetup.zero_patch_data = stringify(zero_patch_data)
	end
	return orig_ScriptCB_SaveMissionSetup(missionSetup)
end

print("info: platform> " .. ScriptCB_GetPlatform() )
print("zero_patch: End 0/addme.script")
