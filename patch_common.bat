:: check for common.lvl, LVLTool 
@echo off
IF EXIST "place_common.lvl_in_here\common.lvl" (
    IF EXIST "LVLTool.exe" (
        LVLTool  -file place_common.lvl_in_here/common.lvl   -o common.lvl -r MUNGED\globals.script
    ) ELSE (
        echo you need to place LVLTool.exe in this folder 
    )
) ELSE (
    echo you need to place your 'common.lvl' file under the "place_common.lvl_in_here" folder
)
