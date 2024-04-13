#!/bin/bash

# Get the name of the current directory
current_directory=$(basename "$PWD")

# Verify the script is run from a directory named 'addon2'
if [ "$current_directory" != "addon2" ]; then
    echo "Error: This script must be run from a directory named 'addon2'. Exiting."
    exit 1
fi

# Search for _LVL_PC directories case-insensitively and rename them
find . -type d -iname _LVL_PC | while read -r dir; do
    # Construct the new directory name (_lvl_common) based on the found directory
    new_dir=$(dirname "$dir")/_lvl_common

    # Check if _lvl_common already exists
    if [ -e "$new_dir" ]; then
        echo "Directory $new_dir already exists, skipping."
    else
        # Rename _LVL_PC to _lvl_common
        mv "$dir" "$new_dir"
        if [ $? -eq 0 ]; then
            echo "Renamed $dir to $new_dir"
        else
            echo "Failed to rename $dir"
        fi
    fi
done

echo zero_patch_files_string = [[ > "0/patch_scripts/fs.lua"

# find $PWD -type f -name "*.lvl" | grep -i sound >> "0/patch_scripts/fs.lua"
find $PWD -type f >> "0/patch_scripts/fs.lua"

echo ]] >> "0/patch_scripts/fs.lua"
