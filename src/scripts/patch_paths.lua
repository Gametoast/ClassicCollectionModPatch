---@diagnostic disable: deprecated
-- STAR WARS BATTLEFRONT CLASSIC COLLECTION - Old Mod Patcher - Redirects an all.lvl load to all1 and all2, redirects an addon load to addon2
-- Greetings from Kenny

__scriptName__ = "[CCPatch: patch_ingame]: "

if string.starts == nil then 
    function string.starts(str, Start)
        return string.sub(str, 1, string.len(Start)) == Start;
    end
end

if( string.endsWith == nil ) then 
    function string.endsWith(str, ending)
        return ending == "" or string.sub(str, -string.len(ending)) == ending
    end
end

function replaceAllLVL(func)
    -- backup old function
    local oldFunc = func

    -- wrap function
    return function(...)
		-- use string.sub and not find to make sure that it is not dc:SIDE
        local test = string.lower(arg[1])
        test = string.gsub(test, "/", "\\") -- normalize the path separator
        if test == "side\\all.lvl" then
            print(__scriptName__, "FOUND side\\all.lvl call. Replacing... NOW!")
            arg[1] = "side\\all1.lvl"
            -- run ReadDataFile on all1, then on all2 to cover the whole side.
            oldFunc(unpack(arg))
            arg[1] = "side\\all2.lvl"
        end

        local retval = {oldFunc(unpack(arg))}
        return unpack(retval)
    end
end

function replaceAddonPath(func)
    -- backup old function
    local oldFunc = func

    -- wrap function
    return function(...)
		-- Use "addon\\" to ensure that it isnt already addon2
        if string.find(arg[1], "addon\\") then
			print(__scriptName__, "FOUND addon call. Replacing... NOW!")
            arg[1] = string.gsub(arg[1], "addon\\", "addon2\\")
        end

        -- let the original function happen
        local retval = {oldFunc(unpack(arg))}

        -- return unmodified return values
        return unpack(retval)
    end
end

if IsFileExist == nil then 
	print("defining IsFileExist")
	IsFileExist = function(path)
		local testPath = "..\\..\\".. path
		return ScriptCB_IsFileExist(testPath)
	end
end

-- 'gAddonSoundFiles' is referenced in 'workAroundSoundReferenceBug' and is expected to look like this pattern
--gAddonSoundFiles = { 
--          it may be read in at 'ingame' time.
--    "..\\..\\addon2\\xbox_dlc\\data\\_lvl_common\\sound\\hero.lvl", 
--    "..\\..\\addon2\\xms\\data\\_lvl_pc\\sound\\xms.lvl" 
--}

function workAroundSoundReferenceBug(func)
    local oldFunc = func
    -- wrap function 
    return function(...)
        if( gAddonSoundFiles ~= nil and string.starts(string.lower(arg[1]), "dc:")) then
            local tmp = string.lower(arg[1])
            tmp = string.gsub(tmp, "/", "\\") -- normalize the path separator
            tmp = string.gsub(tmp, "dc:", "") -- get rid of the prefix
            for i, v in ipairs(gAddonSoundFiles) do
                if string.endsWith(gAddonSoundFiles[i], tmp) then
                    print("substituting " .. arg[1] .. " to " .. gAddonSoundFiles[i])
                    arg[1] = gAddonSoundFiles[i]
                    break
                end
            end
        end
        -- let the original function happen
        local retval = {oldFunc(unpack(arg))}
        -- return unmodified return values
        return unpack(retval)
    end
end

----------------------------------------------------------------------------------------

if(ScriptCB_IsFileExist("side\\all2.lvl") == 1) then 
    print("This is BF Classic Collection; patching file paths")
    -- patch paths
    if ReadDataFile then
        ReadDataFile = replaceAddonPath(ReadDataFile)
        ReadDataFile = replaceAllLVL(ReadDataFile)
    end

    if ReadDataFileInGame then
        ReadDataFileInGame = replaceAddonPath(ReadDataFileInGame)
        ReadDataFileInGame = replaceAllLVL(ReadDataFileInGame)
    end

    if ScriptCB_IsFileExist then
        ScriptCB_IsFileExist = replaceAddonPath(ScriptCB_IsFileExist)
    end

    if ScriptCB_OpenMovie then 
        ScriptCB_OpenMovie = replaceAddonPath(ScriptCB_OpenMovie)
    end
    -- not needed, ScriptCB_DoFile 'does' a file that has already been read into memory.
    --if ScriptCB_DoFile then
    --    ScriptCB_DoFile = replaceAddonPath(ScriptCB_DoFile)
    --end

    if PlayAudioStream then
        PlayAudioStream = replaceAddonPath(PlayAudioStream)
    end

    -- I do not know who came up with the idea to make this a whole other function, but screw you
    if PlayAudioStreamUsingProperties then
        PlayAudioStreamUsingProperties = replaceAddonPath(PlayAudioStreamUsingProperties)
    end

    if OpenAudioStream then
        OpenAudioStream = replaceAddonPath(OpenAudioStream)
        OpenAudioStream = workAroundSoundReferenceBug(OpenAudioStream)
    end

    if AudioStreamAppendSegments then
        AudioStreamAppendSegments = replaceAddonPath(AudioStreamAppendSegments)
        AudioStreamAppendSegments = workAroundSoundReferenceBug(AudioStreamAppendSegments)
    end

    if SetMissionEndMovie then
        SetMissionEndMovie = replaceAddonPath(SetMissionEndMovie)
    end

    if CreateEffect then
        CreateEffect = replaceAddonPath(CreateEffect)
    end

end

-- This does not work. Find a better solution asap.
--[[ load core again for custom localization
if ScriptCB_IsFileExist("dc:core.lvl") == 1 then
    ReadDataFile("dc:core.lvl")
end]]--

