
@echo off
cd 0

if exist base.loading.lvl (
    :: Merge Core (collect all new strings from core.lvl files and add them to tha game's core.lvl)
    :: this program can leave around a string hash 'dictionary', let's delete it so we don't confuse the user.

    echo Merging strings ...
    :: The "| findstr -v " part suppresses a confusing message
    bin\LVLTool.exe -file base.loading.lvl -merge_strings ..  -o ..\..\data1\_lvl_pc\loading.lvl | findstr /v specified

)
pause
