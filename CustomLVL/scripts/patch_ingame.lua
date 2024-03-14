---@diagnostic disable: deprecated
-- STAR WARS BATTLEFRONT CLASSIC COLLECTION - Old Mod Patcher - Redirects an all.lvl load to all1 and all2, redirects an addon load to addon2
-- Greetings from Kenny

__scriptName__ = "[CCPatch: patch_ingame]: "

function replaceAllLVL(func)
    -- backup old function
    local oldFunc = func

    -- wrap function
    return function(...)
		-- use string.sub and not find to make sure that it is not dc:SIDE
        if string.sub(arg[1], 1, 12) == "SIDE\\all.lvl" then
            print(__scriptName__, "FOUND SIDE\\all.lvl call. Replacing... NOW!")
            arg[1] = string.gsub(arg[1], "SIDE\\all.lvl", "SIDE\\all1.lvl")
            -- run ReadDataFile on all1, then on all2 to cover the whole side.
            oldFunc(unpack(arg))
            arg[1] = string.gsub(arg[1], "SIDE\\all1.lvl", "SIDE\\all2.lvl")
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

----------------------------------------------------------------------------------------

function patch_ingame()
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
    
    if ScriptCB_DoFile then
        ScriptCB_DoFile = replaceAddonPath(ScriptCB_DoFile)
    end
    
    if PlayAudioStream then
        PlayAudioStream = replaceAddonPath(PlayAudioStream)
    end
    
    -- I do not know who came up with the idea to make this a whole other function, but screw you
    if PlayAudioStreamUsingProperties then
        PlayAudioStreamUsingProperties = replaceAddonPath(PlayAudioStreamUsingProperties)
    end
    
    if OpenAudioStream then
        OpenAudioStream = replaceAddonPath(OpenAudioStream)
    end
    
    if AudioStreamAppendSegments then
        AudioStreamAppendSegments = replaceAddonPath(AudioStreamAppendSegments)
    end
    
    if SetMissionEndMovie then
        SetMissionEndMovie = replaceAddonPath(SetMissionEndMovie)
    end
    
    if CreateEffect then
        CreateEffect = replaceAddonPath(CreateEffect)
    end
    
    

    -- This does not work. Find a better solution asap.
    --[[ load core again for custom localization
    if ScriptCB_IsFileExist("dc:core.lvl") == 1 then
        ReadDataFile("dc:core.lvl")
    end]]--
end