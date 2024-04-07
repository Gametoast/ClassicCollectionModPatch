#!/bin/bash

pushd .

cd ..

echo addonSoundFiles = [[ > "0/patch_scripts/soundFiles.lua"

find $PWD -type f -name "*.lvl" | grep -i sound >> "0/patch_scripts/soundFiles.lua"

echo ]] >> "0/patch_scripts/soundFiles.lua"


### Now create symbolic links with _lvl_common pointing to _LVL_PC so that the game
### Can load the mission correctly and all the other files can still be referenced ok

root_directory="."


# Use find with -iname for case-insensitive search of directories named _LVL_PC
find "$root_directory" -type d -iname _LVL_PC | while read -r lvl_pc_dir; do
  # Find the parent directory of the _LVL_PC directory
  parent_dir=$(dirname "$lvl_pc_dir")
  
  # Get the name of the _LVL_PC directory to use in the symbolic link creation
  lvl_pc_dir_name=$(basename "$lvl_pc_dir")

  # CD into the parent directory, linking is more reliable that way
  cd "$parent_dir" || exit

  # Check if the symbolic link already exists
  if [ ! -L "./_lvl_common" ]; then
    # Create the symbolic link pointing to the _LVL_PC directory
    ln -s "$lvl_pc_dir_name" "_lvl_common"
    echo "Created symbolic link: $parent_dir/_lvl_common -> $lvl_pc_dir_name"
  else
    echo "Symbolic link already exists: $parent_dir/_lvl_common"
  fi

  # Return to the script's original directory
  cd - > /dev/null
done


popd 
