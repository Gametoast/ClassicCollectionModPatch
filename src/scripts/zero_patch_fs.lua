
local function ReadFileSystemLuaFile()
    local checkFile = "addon2\\0\\patch_scripts\\fs.lua"
    local prefix = "addon2\\"
    if(IsFileExist("addon2\\0\\addme.script") == 0 ) then
        -- make compatible with OG version too
        checkFile = "addon\\0\\patch_scripts\\fs.lua"
    end
    if(IsFileExist(checkFile) == 1) then 
        dofile(checkFile)
        print("info: ReadFileSystemLuaFile; read in fs.lua")
        return true
    end
    return false
end

-- The switch (NX) version does not support 'dofile()'
local function ReadFileSystemScriptFile()
    local checkFile = "..\\..\\addon\\0\\patch_scripts\\fs.script"
    if( ScriptCB_IsFileExist(checkFile) == 1 ) then 
        ReadDataFile(checkFile)
        ScriptCB_DoFile("fs")
        print("info: ReadFileSystemScriptFile; read in fs.script")
        return true
    end
    return false
end


local function ReadInFileSystem()
    print("info: ReadInFileSystem()")
    local prefix = "addon2\\"
    if(IsFileExist("addon2\\0\\addme.script") == 0 ) then
        -- make compatible with OG version too
        prefix = "addon\\"
    end
    
    zero_patch_files_string = ""
    if( ReadFileSystemScriptFile() or ReadFileSystemLuaFile() ) then
        -- the  zero_patch_files_string string  should exist now
        local function splitStringByNewline(str)
            local t = {}
            local start = 1
            local splitStart, splitEnd = string.find(str, "\r?\n", start)
            while splitStart do
                table.insert(t, string.sub(str, start, splitStart - 1))
                start = splitEnd + 1
                splitStart, splitEnd = string.find(str, "\r?\n", start)
            end
            table.insert(t, string.sub(str, start))
            return t
        end
        zero_patch_files_string = string.gsub(zero_patch_files_string, "/", "\\") -- normalize path sep
        local myList = splitStringByNewline(string.lower(zero_patch_files_string))

        local allFiles = { }

        for i, line in ipairs(myList) do
            local startPos, endPos = string.find(line, prefix)
            -- TODO: discuss if we want to disable scripts/files this way.
            if startPos and string.find(line, "disabled") == nil then
                -- Extract and print part of the line from "addon2\" to the end
                local part = "..\\..\\" .. string.sub(line, startPos)
                table.insert( allFiles, part)
                --print(part)
            end
        end
        -- clean out memory
        zero_patch_files_string = nil

        return allFiles
    end
end 

local function hasExtension(path, ext_list)
    if ext_list == nil then 
        return true
    end
    -- Iterate through each extension in the list
    for _, ext in ipairs(ext_list) do
        -- Check if the path ends with the current extension
        if string.sub(path, -string.len(ext)) == ext then
            return true
        end
    end
    return false
end
zero_patch_fs = {
    
    -- Get files given a lua pattern. For get all files, pass no argument
    -- Lua pattern matching is a bit on the 'weak' side, it is not 'POSIX' compliant.
    -- Lua pattern matching  https://riptutorial.com/lua/example/20315/lua-pattern-matching
    -- pattern - A Lua pattern 
    -- ext_list - extensions you need the file to have; example: { ".lvl", ".script"}
    getFiles = function(pattern, ext_list)
        local matchedFiles = {}
        local lowerPattern = pattern and string.lower(pattern)
        local file_system = ReadInFileSystem() -- let this get cleaned out after use, how many times would it get called anyway?
        for i, v in ipairs(file_system) do
            if( pattern == nil ) then
                table.insert(matchedFiles, v)
            elseif string.find(v, lowerPattern) and hasExtension(v, ext_list) then
                table.insert(matchedFiles, v)
            end
        end
        if(table.getn(matchedFiles) == 0 and not gFinalBuild ) then 
            -- print out a help message if using the debugger
            print(string.format("zero_patch_fs.getFiles('%s') -> Matched 0 files.\n  If you need help with lua patterns check the help message:", tostring(pattern)))
            zero_patch_fs.printHelp()
        end
        table.sort(matchedFiles)
        return matchedFiles
    end,

    printHelp = function() 
        local msg = [[
======================================================
zero_patch_fs.print_help()
getFiles(pattern, extension_list)
======================================================
Quick Reminders:
    ^  = Beginning of string/line
    $  = End of string/line
    .* = match any number of characters
    or = doesn't exist in Lua patterns

Example:
    Get all .lvl files under the 'abc' addon folder:
        abc_lvls = zero_patch_fs.getFiles(".*abc.*lvl")
        user_scripts = zero_patch_fs.getFiles("user_script_", {".lvl", ".script"})

Or use the following guide for lua pattern matching:
    https://riptutorial.com/lua/example/20315/lua-pattern-matching
]]
        print(msg)
    end
}