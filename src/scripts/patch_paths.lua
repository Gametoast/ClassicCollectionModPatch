---@diagnostic disable: deprecated
-- STAR WARS BATTLEFRONT CLASSIC COLLECTION - Old Mod Patcher - Redirects an all.lvl load to all1 and all2, redirects an addon load to addon2
-- Greetings from Kenny

local __scriptName__ = "[zero_patch: patch_ingame]: "
print("Start: " .. __scriptName__)

THE_ORIGINAL_ScriptCB_IsFileExist = ScriptCB_IsFileExist

if IsFileExist == nil then
	print("defining IsFileExist")
	IsFileExist = function(path)
		local testPath = "..\\..\\".. path
		return THE_ORIGINAL_ScriptCB_IsFileExist(testPath)
	end
end


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
            arg[1] = "side\\all1.lvl"
            print("info:" .. __scriptName__ .. "FOUND side\\all.lvl call. redirecting -> " .. arg[1])
            -- run ReadDataFile on all1, then on all2 to cover the whole side.
            oldFunc(unpack(arg))
            arg[1] = "side\\all2.lvl"
        end

        local retval = {oldFunc(unpack(arg))}
        return unpack(retval)
    end
end

function redirectBF2Path(func)
    -- backup old function
    local oldFunc = func

    -- wrap function
    return function(...)
		-- Use "addon\\" to ensure that it isnt already addon2
        local arg_1 = string.lower(arg[1])
        local msg = nil

        if string.find(arg_1, "addon\\") then
			arg[1] = string.gsub(arg_1, "addon\\", "addon2\\")
            --msg = "info:" .. __scriptName__ .. " FOUND addon call. redirecting -> " .. arg[1]
            msg = "info: redirect -> " .. arg[1]
        end

        -- We'll re-direct calls to the _lvl_common folder when the asset exists in _lvl_common
        -- and not in _lvl_pc
        arg_1 = string.lower(arg[1])
        if string.find(arg_1, "\\_lvl_pc\\") then
            local commonTest = string.gsub(arg_1, "\\_lvl_pc\\", "\\_lvl_common\\")
            if( THE_ORIGINAL_ScriptCB_IsFileExist(arg_1) == 0 and THE_ORIGINAL_ScriptCB_IsFileExist(commonTest) == 1) then
                arg[1] = commonTest
                --msg = "info: " .. __scriptName__ .. " Redirecting to  " .. arg[1]
                msg = "info: redirect -> " .. arg[1]
            end
        end
        if(msg) then
            print(msg)
        end

        -- let the original function happen
        local retval = {oldFunc(unpack(arg))}

        -- return unmodified return values
        return unpack(retval)
    end
end


----------------------------------------------------------------------------------------

if(ScriptCB_IsFileExist("..\\..\\addon2\\0\\patch_scripts\\patch_paths.script") == 1) then
    print("This is BF Classic Collection; patching file paths")
    -- patch paths
    if ReadDataFile then
        ReadDataFile = redirectBF2Path(ReadDataFile)
        ReadDataFile = replaceAllLVL(ReadDataFile)
    end

    if ReadDataFileInGame then
        ReadDataFileInGame = redirectBF2Path(ReadDataFileInGame)
        ReadDataFileInGame = replaceAllLVL(ReadDataFileInGame)
    end

    if ScriptCB_IsFileExist then
        ScriptCB_IsFileExist = redirectBF2Path(ScriptCB_IsFileExist)
    end

    if ScriptCB_OpenMovie then
        ScriptCB_OpenMovie = redirectBF2Path(ScriptCB_OpenMovie)
    end
    -- not needed, ScriptCB_DoFile 'does' a file that has already been read into memory.
    --if ScriptCB_DoFile then
    --    ScriptCB_DoFile = redirectBF2Path(ScriptCB_DoFile)
    --end

    if PlayAudioStream then
        PlayAudioStream = redirectBF2Path(PlayAudioStream)
    end

    -- I do not know who came up with the idea to make this a whole other function, but screw you
    if PlayAudioStreamUsingProperties then
        PlayAudioStreamUsingProperties = redirectBF2Path(PlayAudioStreamUsingProperties)
    end

    if OpenAudioStream then
        OpenAudioStream = redirectBF2Path(OpenAudioStream)
    end

    if AudioStreamAppendSegments then
        AudioStreamAppendSegments = redirectBF2Path(AudioStreamAppendSegments)
    end

    if SetMissionEndMovie then
        SetMissionEndMovie = redirectBF2Path(SetMissionEndMovie)
    end

    if CreateEffect then
        CreateEffect = redirectBF2Path(CreateEffect)
    end
end

---- debug logging
--local old_ReadDataFile = ReadDataFile
--ReadDataFile = function(...)
--    print("info: enter ReadDataFile " .. arg[1])
--    return old_ReadDataFile(unpack(arg))
--end

-- This does not work. Find a better solution asap.
--[[ load core again for custom localization
if ScriptCB_IsFileExist("dc:core.lvl") == 1 then
    ReadDataFile("dc:core.lvl")
end]]--

print("End: " .. __scriptName__)