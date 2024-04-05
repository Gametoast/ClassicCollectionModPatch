
@echo off
pushd .

cd ..

echo addonSoundFiles = [[ > "0\\patch_scripts\\soundFiles.lua"

dir /b /s *.lvl | findstr /i sound >> "0\\patch_scripts\\soundFiles.lua"

echo ]] >> "0\\patch_scripts\\soundFiles.lua"

popd 