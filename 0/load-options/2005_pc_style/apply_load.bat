@echo off

if exist ..\..\..\..\data2\_lvl_common\load\common.lvl (
	
	copy /y  common.lvl ..\..\..\..\data2\_lvl_common\load\
	copy /y  load.lvl  ..\..\..\..\data2\_lvl_common\load\

) else (
	echo Error! Could not find load\common.lvl; Load option not applied
)

REM Let user see the messages above 
pause 
