::@echo off
setlocal enabledelayedexpansion

:: PATH setup 
set "MyPath=C:\BF2_ModTools\ToolsFL\bin"
echo %PATH% | findstr /C:"%MyPath%" > nul
if errorlevel 1 set "PATH=%MyPath%;%PATH%"

for %%b in (movies\*) do (
    set "outputName=%%~nb.mvs"
    echo Processing file: %%b to !outputName! 
    
    REM change ext for PC (.bik), PS2 (.pss), XBOX (.xmv)
    
    REM internally, all movies will be called 'preview' 
    copy /Y %%b TEMP\preview.bik
    
    REM Create the movie list
    echo TEMP\preview.bik > TEMP\movie_list.mlst 

    MovieMunge.exe -input TEMP\movie_list.mlst -output output\!outputName! -checkdate
    
)

:end
endlocal
