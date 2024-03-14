--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

if not __POINTS_LUA__ then
__POINTS_LUA__ = 1

--------------------------------------------------------------------------------
-- Format: { point_gain =   number  },			--//	description
-- Notes: number should between [-128, 127]
-- If you need to ADD/REMOVE items, please ask programmer to change accordingly
-- enum PointStatT in PlayerStats.h
--------------------------------------------------------------------------------
Player_Stats_Points = {

	{ point_gain =   1  },			--//	PS_GLB_KILL_AI_PLAYER = 0,
	{ point_gain =   2  },			--//	PS_GLB_KILL_HUMAN_PLAYER,
	{ point_gain =   1  },			--//	PS_GLB_KILL_HUMAN_PLAYER_AI_OFF,
	{ point_gain =  -1  },			--//	PS_GLB_KILL_SUICIDE,
	{ point_gain =  -2  },			--//	PS_GLB_KILL_TEAMMATE,
									--//
	{ point_gain =   3  },			--//	PS_GLB_VEHICLE_KILL_INFANTRY_VS_VEHICLE,
	{ point_gain =   2  },			--//	PS_GLB_VEHICLE_KILL_LIGHT_VS_HEAVY,
	{ point_gain =   1  },			--//	PS_GLB_VEHICLE_KILL_LIGHT_VS_MEDIUM,
	{ point_gain =   1  },			--//	PS_GLB_VEHICLE_KILL_HEAVY_VS_LIGHT,
	{ point_gain =   1  },			--//	PS_GLB_VEHICLE_KILL_HEAVY_VS_MEDIUM,
	{ point_gain =   1  },			--//	PS_GLB_VEHICLE_KILL_MEDIUM_VS_LIGHT,
	{ point_gain =   1  },			--//	PS_GLB_VEHICLE_KILL_MEDIUM_VS_HEAVY,
	{ point_gain =  10  },			--//	PS_GLB_VEHICLE_KILL_ATAT,
	{ point_gain =   1  },			--//	PS_GLB_VEHICLE_KILL_EMPTY,
									--//
	{ point_gain =   1  },			--//	PS_GLB_HEAL,
	{ point_gain =   1  },			--//	PS_GLB_REPAIR,
									--//
	{ point_gain =   1  },			--//	PS_GLB_SNIPER_ACCURACY,
	{ point_gain =   1  },			--//	PS_GLB_HEAVY_WEAPON_MULTI_KILL,
	{ point_gain =   1  },			--//	PS_GLB_RAMPAGE,
	{ point_gain =   1  },			--//	PS_GLB_HEAD_SHOT,
	{ point_gain =   5  },			--//	PS_GLB_KILL_HERO,
									--//
									--//	// conquest
	{ point_gain =   5  },			--//	PS_CON_CAPTURE_CP,
	{ point_gain =   2  },			--//	PS_CON_ASSIST_CAPTURE_CP,
	{ point_gain =   2  },			--//	PS_CON_KILL_ENEMY_CAPTURING_CP,
	{ point_gain =   2  },			--//	PS_CON_DEFEND_CP,
	{ point_gain =   1  },			--//	PS_CON_KING_HILL,
									--//
									--//	// capture the flag
	{ point_gain =   1  },			--//	PS_CAP_PICKUP_FLAG,
	{ point_gain =   2  },			--//	PS_CAP_DEFEND_FLAG,
	{ point_gain =  10  },			--//	PS_CAP_CAPTURE_FLAG,
	{ point_gain =   2  },			--//	PS_CAP_DEFEND_FLAG_CARRIER,
	{ point_gain =   2  },			--//	PS_CAP_KILL_ENEMY_FLAG_CARRIER,
	{ point_gain = -12  },			--//	PS_CAP_KILL_ALLY_FLAG_CARRIER,
									--//
									--//	// assault
	{ point_gain =  10  },			--//	PS_ASS_DESTROY_ASSAULT_OBJ,
									--//
									--//	// escort
	{ point_gain =   2  },			--//	PS_ESC_DEFEND,
									--//
									--//	// defend
	{ point_gain =   2  },			--//	PS_DEF_DEFEND,

}

ScriptCB_SetPlayerStatsPoints( Player_Stats_Points )
Player_Stats_Points = nil

end --if not __POINTS_LUA__


-- Enter patch stuff!
patchDir = "..\\..\\addon2\\0\\patch_ingame"
if ScriptCB_IsFileExist(patchDir .. ".lvl") == 1 then
	ReadDataFile(patchDir .. ".lvl")
	ScriptCB_DoFile("patch_ingame")
	patch_ingame()
end