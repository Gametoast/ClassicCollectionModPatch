
:: At some point we could possibly do an automatic copy from the user's _lvl_common\common.lvl
:: but for now, let's keep it simple. (if doing teh copy we'd want to check if it had already been patched, maybe)
@echo off

if not exist "base_common.lvl_goes_in_here\common.lvl" (
    echo Error: file does not exist, place your common.lvl file into the 'base_common.lvl_goes_in_here' folder
	pause
    exit /b
)

REM If you want to run this on Linux there are options.
REM 1. Manually run LVLTool.exe through Wine or Bottles, load the common.lvl and replace the 'globals' script with the one in 'patch_scripts', save.
REM 2. Run under a Bottles or Wine command line env (untested).

bin\LVLTool.exe -file base_common.lvl_goes_in_here\common.lvl -r patch_scripts\globals.script  -o common.lvl 

