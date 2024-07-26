-- user_script_loc_fix.lua

-- Hopefully Aspyr will fix the bf2 loc issue and this can be disgarded after the next update.

-- summary:
-- Loads 'dc:core.lvl' once the script calls ReadDataFile on a path starting with 'dc:'.
-- Should work in most cases.
-- will crash if a mod does not have a core.lvl file (this is rare; work around would be to put a core.lvl one in the mod that doean't have one).

zz_dc_core_loaded = false

local oldReadDataFile = ReadDataFile
ReadDataFile = function(...)
    if(  string.find( string.lower(arg[1]), "dc:" ) == 1 and not zz_dc_core_loaded  ) then
        print("info: loading 'dc:core.lvl' [to fix mod loc issue]")
        oldReadDataFile("dc:core.lvl")
        zz_dc_core_loaded = true
    end
    return oldReadDataFile(unpack(arg))
end