@echo off

if exist ..\..\..\..\data2\_lvl_common\ingame.lvl (
	REM use LVLTool to replace the player 1 hud file 
	..\..\bin\LVLTool.exe -file ..\..\..\..\data2\_lvl_common\ingame.lvl -r 0xDC27B03D.hud_

	REM overwrite any hud_texture_pack.lvl file
	echo copy hud_texture_pack.lvl  now...
	copy /y hud_texture_pack.lvl .. 
) else (
	echo Error! Could not find ingame.lvl; hud not applied
)


REM Let user see the messages above 
pause 
