
pushd .

cd ..

echo addonSoundFiles = [[ > "0/patch_scripts/soundFiles.lua"

find $PWD -type f -name "*.lvl" | grep -i sound >> "0/patch_scripts/soundFiles.lua"

echo ]] >> "0/patch_scripts/soundFiles.lua"

popd 
