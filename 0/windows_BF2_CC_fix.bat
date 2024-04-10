@echo off
setlocal EnableDelayedExpansion

REM possibly change name to 'windows_zero_patch_run_after_adding_mod.bat'

set "ExpectedFolderName=addon2"

:: Extract the name of the directory where the batch file is located
for %%I in ("%~dp0.") do set "CurrentFolderName=%%~nxI"

:: Compare the current folder name to the expected one
if /i "%CurrentFolderName%" neq "%ExpectedFolderName%" (
    :: If not matching, display a message box using VBScript
    >"%temp%\tempmessage.vbs" echo MsgBox "This batch file needs to run from a folder called '%ExpectedFolderName%'. Please ensure it is located in the correct folder and try again.", 0 + 48, "Incorrect Folder"
    wscript.exe "%temp%\tempmessage.vbs"
    del "%temp%\tempmessage.vbs"
    exit /b
)

:: Set the root directory to start searching from
set "root_directory=."

:: Use dir /b /s /ad to list directories case-insensitively
for /f "delims=" %%D in ('dir /b /s /ad "%root_directory%\*LVL_PC*"') do (
    set "dirName=%%~nxD"
    set "dirPath=%%~dpD"
    set "fullPath=%%D"

    :: Check if the directory name matches _LVL_PC
    if /i "!dirName!"=="_LVL_PC" (
        :: Attempt to rename _LVL_PC to _LVL_COMMON
        ren "!fullPath!" "_lvl_common"
        if !ERRORLEVEL! equ 0 (
            echo Renamed: !dirName! to _lvl_common
        ) else (
            echo Failed to rename: !dirName!
        )
    )
)


echo zero_patch_files_string = [[ > "0\\patch_scripts\\fs.lua"

dir /b /s * >> "0\\patch_scripts\\fs.lua"

echo ]] >> "0\\patch_scripts\\fs.lua"

endlocal

