
local function ReadInFileSystem()
    print("info: ReadInFileSystem()")
    local checkFile = "addon2\\0\\patch_scripts\\fs.lua"
    local prefix = "addon2\\"
    if(IsFileExist(checkFile) == 0 ) then
        -- make compatible with OG version too
        checkFile = "addon\\0\\patch_scripts\\fs.lua"
        prefix = "addon\\"
    end
    if(IsFileExist(checkFile) == 1 ) then
        zero_patch_files_string = ""
        dofile(checkFile)
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
            if startPos then
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


zero_patch_fs = {
    -- Get files given a lua pattern. For get all files, pass no argument
    -- Lua pattern matching  https://riptutorial.com/lua/example/20315/lua-pattern-matching
    getFiles = function(pattern)
        
        local matchedFiles = {}
        local lowerPattern = pattern and string.lower(pattern)
        local file_system = ReadInFileSystem() -- let this get cleaned out after use, how many times would it get called anyway?
        for i, v in ipairs(file_system) do
            if( pattern == nil or  string.find(v, lowerPattern)) then
                table.insert(matchedFiles, v)
            end
        end
        if(table.getn(matchedFiles) == 0 and not gFinalBuild ) then 
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
======================================================
Quick Reminders:
    ^  = Beginning of string/line
    $  = End of string/line
    .* = match any number of characters

Example:
    Get all .lvl files under the 'abc' addon folder:
        abc_lvls = zero_patch_fs.getFiles(".*abc.*lvl")

Or use the following guide for lua pattern matching:
    https://riptutorial.com/lua/example/20315/lua-pattern-matching
]]
        print(msg)
    end
}