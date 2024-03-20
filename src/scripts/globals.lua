--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Tuning values for the game, broken off into a lua script so that
-- people can muck with them easily w/o editing the game exe directly.

-- Note: items in here are just shoved in lua globals. Items added
-- will require the exe to be modified to do something with them.
-- TwoPI = 6.28318 5307179586476925286766559
--Current anim times:  (goes by the lockinput time
--Land = .5
--ProneToStand = 1.33
--Dive (needs adjusting, its too fast right now) = .5f
--crouchToProne = 1.33


RollLeft = {
	Size = 3,  --number of points interpolated between current math.max is 6, each point MUST have a vec,slop,ore,rslope and time associated with it

	Vec = {
		{-0.1,-0.2,0.0}, -- x y z, offset from the camera's position (keep in mind the camera's position moves on its own as well)
		{0.0,-0.3,0.0},
		{0.1,0.0,0.0},
	},

	Slope = {
		{0.4,  0.3,  0.0}, --x y z the slope of the points, adjusts the curve
		{0.2, -0.3,  0.0},
		{0.0,  0.0,  0.0},
	},

	Ore = {
		{0.0, 0.0, 0.0}, --euler angles, x y z
		{0.0, 0.0, 0.0}, --two pi
		{0.0, 0.0, 0.0},
	},

	RSlope = {
		{0.0, 0.0, 0.0}, -- slope of the rotation, adjusts the rotation interpolation
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},

	Time = {
		.3, .5, .3 --times, in magical floating point frontline time.
	},
}

RollRight = {
	Size = 3,  

	Vec = {
		{0.1,-0.2,0.0},
		{0.0,-0.3,0.0},
		{-0.1,0.0,0.0},
	},

	Slope = {
		{0.4,  0.3,  0.0},
		{0.2, -0.3,  0.0},
		{0.0,  0.0,  0.0},
	},

	Ore = {
		{0.0, 0.0, 0.0},
		{0.0, 0.0, -0.0}, 
		{0.0, 0.0, -0.0},
	},

	RSlope = {
		{0.0, 0.0, 0.0}, -- slope of the rotation, adjusts the rotation interpolation
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},
	Time = {
		.3, .5, .3
	},
}

Crouch = {
	Size = 3,  

	Vec = {
		{0.0, -1.0,  0.0},
		{0.0, -0.0,  0.0},
		{0.0,  0.0,  0.0},
	},

	Slope = {
		{0.0, 0.2, 0.0},
		{0.0, -0.2, 0.0},
		{0.0,  0.0,  0.0},
	},

	Ore = {
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},

	RSlope = {
		{0.0, 0.0, 0.5},
		{0.0, 0.0, 0.3},
		{0.0, 0.0, 0.4},
	},

	Time = {
		.2, .1, .2
	},
}


CrouchToProne = {
	Size = 3,  

	Vec = {
		{0.0,-0.0,0.4},
		{0.0, 0.0,  0.2},
		{0.0,  0.0,  0.0},
	},

	Slope = {
		{0.0, 0.0, 0.0},
		{0.0, -0.0, 0.0},
		{0.0,  0.0,  0.0},
	},

	Ore = {
		{-0.4, 0.0, 0.0},
		{-0.2, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},

	RSlope = {
		{0.0, 0.0, 0.3},
		{0.0, 0.0, -0.3},
		{0.0, 0.0, 0.0},
	},

	Time = {
		.6, .5, .5
	},
}


Land = {
	Size = 3,  

	Vec = {
		{0.0,-1.0,0.0},
		{0.0, 0.2,  0.0},
		{0.0,  0.0,  0.0},
	},

	Slope = {
		{0.0, 0.2, 0.0},
		{0.0, -0.2, 0.0},
		{0.0,  0.0,  0.0},
	},

	Ore = {
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},

	RSlope = {
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},

	Time = {
		.17, .17, .17
	},
}

StandToProne = {  -- Note this never actually gets called, game logic currently has the person jump to the crouch state b4 going prone
	Size = 3,  

	Vec = {
		{0.0,-0.0,0.4},
		{0.0, 0.0,  0.2},
		{0.0,  0.0,  0.0},
	},

	Slope = {
		{0.0, 0.0, 0.0},
		{0.0, -0.0, 0.0},
		{0.0,  0.0,  0.0},
	},

	Ore = {
		{-0.4, 0.0, 0.0},
		{-0.2, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},

	RSlope = {
		{0.0, 0.0, 0.3},
		{0.0, 0.0, -0.3},
		{0.0, 0.0, 0.0},
	},

	Time = {
		.6, .5, .5
	},
}

ProneToStand = { 
	Size = 3,  

	Vec = {
		{0.0,-0.2,0.4},
		{0.0, 0.0,  0.2},
		{0.0,  0.0,  0.0},
	},

	Slope = {
		{0.0, 0.0, 0.0},
		{0.0, -0.2, 0.0},
		{0.0,  0.0,  0.0},
	},

	Ore = {
		{-0.6, 0.0, 0.0},
		{-0.2, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},

	RSlope = {
		{0.0, 0.0, 0.3},
		{0.0, 0.0, -0.3},
		{0.0, 0.0, 0.0},
	},

	Time = {
		.6, .5, .4
	},
}

CrouchToStand = { 
	Size = 3,  

	Vec = {
		{0.0,0.2,0.0},
		{0.0, 0.0,  0.0},
		{0.0,  0.0,  0.0},
	},

	Slope = {
		{0.0, -0.1, 0.0},
		{0.0,  0.1, 0.0},
		{0.0,  0.0, 0.0},
	},

	Ore = {
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
	},

	RSlope = {
		{0.0, 0.0, -0.5},
		{0.0, 0.0, -0.3},
		{0.0, 0.0, -0.4},
	},

	Time = {
		.12, .12, .12
	},
}

--Rumble Region Junk 
RumbleSmall = { 
---In A math.min/math.max string.format
	Interval = { 4.0 , 15.0 },  --how often the rumble gets set off
	Light =  {1.0, 1.0},
	Heavy =  {0.0,.2},
	HeavyDecay = { .5,.5 },
	LightDecay = {.5, .5 },
	DelayLight = {0.0, 0.0 },
	DelayHeavy = { 0.0, 0.0 },
	TimeLeftHeavy = {1.0, 1.0}, --how long each rumble lasts
	TimeLeftLight = {0.5, 1.0}, 
	ShakeAmt = { 0.5 , 1.0 },
	ShakeLen = { 0.5, 1.5 }, --Camera shake length
	FXName = "Doesn'tWorkYet", --the particle effect that gets triggered, is read in, but not used yet.
	
}
RumbleMedium = { 
---In A math.min/math.max string.format
	Interval = { 4.0 , 15.0 },  --how often the rumble gets set off	
	Light =  {1.0, 1.0},
	Heavy =  {.2,.4},
	HeavyDecay = { .5,.5 },
	LightDecay = {.5, .5 },
	DelayLight = {0.0, 0.0 },
	DelayHeavy = { 0.0, 0.0 },
	TimeLeftHeavy = {1.0, 1.0}, --how long each rumble lasts
	TimeLeftLight = {1.0, 1.0}, 
	ShakeAmt = { 1.5 , 2.5 },
	ShakeLen = { 0.5, 1.5 }, --Camera shake length
	FXName = "Doesn'tWorkYet", --the particle effect that gets triggered, is read in, but not used yet.
	
}

RumbleLarge = { 
---In A math.min/math.max string.format
	Interval = { 4.0 , 15.0 },  --how often the rumble gets set off	
	Light =  {1.0, 1.0},	
	Heavy =  {.6,.8},
	HeavyDecay = { .5,.5 },
	LightDecay = {.5, .5 },
	DelayLight = {0.0, 0.0 },
	DelayHeavy = { 0.0, 0.0 },
	TimeLeftHeavy = {1.0, 1.0}, --how long each rumble lasts
	TimeLeftLight = {1.0, 1.0}, 
	ShakeAmt = { 3.0 , 4.0 },
	ShakeLen = { 0.5, 1.5 }, --Camera shake length
	FXName = "Doesn'tWorkYet", --the particle effect that gets triggered, is read in, but not used yet.
	
}
print("Apply_Classic_Collection_Patch_To_Common.lvl")
-- Enter patch stuff!
local target = "..\\..\\addon2\\0\\patch_scripts\\patch_paths.script"
if ScriptCB_IsFileExist(target) == 1 then
	ReadDataFile(target)
	ScriptCB_DoFile("patch_paths")
	-- are we ingame? if so do some more stuff
end

-- since globals runs in Shell and ingame, we call out selectively to setup 'patching'
-- for the respective lua env
if ( SetupTeams ~= nil ) then  -- this will exist at mission script execution/ingame time
    -- this should run during game_interface execution
	local target = "..\\..\\addon2\\0\\patch_scripts\\patch_ingame.script"
	if(ScriptCB_IsFileExist(target) == 1 )  then 
		ReadDataFile(target)
		ScriptCB_DoFile(target)
	end
else
	-- running at shell time 
    local target = "..\\..\\addon2\\0\\patch_scripts\\patch_shell.script"
	if(ScriptCB_IsFileExist(target) == 1 )  then 
		ReadDataFile(target)
		ScriptCB_DoFile(target)
	end
end 