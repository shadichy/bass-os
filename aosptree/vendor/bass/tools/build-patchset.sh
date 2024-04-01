#!/bin/bash

# trap 'kill $(jobs -p); exit 1' EXIT
# 
# Function to extract the last common parts and reformat to "frameworks/base"
extract_common_parts() {
    local rom_folder=$1
    local aosp_folder=$2
    local common_parts=()
    IFS='/' read -ra rom_parts <<< "$rom_folder"
    IFS='/' read -ra aosp_parts <<< "$aosp_folder"

    for ((i=${#rom_parts[@]}-1, j=${#aosp_parts[@]}-1; i>=0 && j>=0; i--, j--)); do
        if [ "${rom_parts[i]}" != "${aosp_parts[j]}" ]; then
            break
        fi
        common_parts=("${rom_parts[i]}" "${common_parts[@]}")
    done

    printf "%s/" "${common_parts[@]}" | cut -d '/' -f 1-${#common_parts[@]}
}

ROM_FOLDER=$1
if [ ! -d "$ROM_FOLDER" ]; then
    echo -e "\e[31mROM folder $ROM_FOLDER does not exist\e[0m"
    exit 1
fi
AOSP_FOLDER=$2
if [ ! -d "$AOSP_FOLDER" ]; then
    echo -e "\e[31mAOSP folder $AOSP_FOLDER does not exist\e[0m"
    echo "$AOSP_FOLDER" >> $(pwd)/aosp_folders_missing.txt
    exit 1
fi

HISTORY_NUM=$3
if [ -z "$HISTORY_NUM" ]; then
    echo -e "\e[31mHISTORY_NUM is empty. needs to be a valid integer\e[0m"
    exit 1
fi
PATCH_MODE=$4
if [ "$PATCH_MODE" != "grouped" ] && [ "$PATCH_MODE" != "split" ]; then
    echo -e "\e[31mPATCH_MODE needs to be either 'grouped' or 'split'\e[0m"
    exit 1
fi

if [ -n "$5" ]; then
    working_folder=$5
else
    working_folder=$(pwd)
fi
prefix=0
echo ""
echo -e "\e[32mworking folder: $working_folder\e[0m"
echo ""

# Extract the last common parts and reformat to "frameworks/base"
COMMON_PARTS=$(extract_common_parts "$ROM_FOLDER" "$AOSP_FOLDER")
echo "COMMON PARTS: $COMMON_PARTS"
PATCHES_FOLDER="$working_folder/patchsets/$COMMON_PARTS"
# Create the patchsets folder
# mkdir -p "$PATCHES_FOLDER"

# Create a temporary folder for patch files
TEMP_FOLDER=$(mktemp -d)

# Generate git log for both folders and extract the change subjects
git -C "$ROM_FOLDER" log --pretty=format:%s -n "$HISTORY_NUM" > "$TEMP_FOLDER/rom_changes.txt"
git -C "$AOSP_FOLDER" log --pretty=format:%s -n $((HISTORY_NUM * 10)) > "$TEMP_FOLDER/aosp_changes.txt"

create_patches_split() {
# Compare the change subjects and generate patch files for changes not found in AOSP
pnumber=0
comm -23 <(grep -v "^Merge remote-tracking branch" "$TEMP_FOLDER/rom_changes.txt" | grep -v "^Import translations") <(sort "$TEMP_FOLDER/aosp_changes.txt") | while read -r title; do
    # Find the commit in the ROM_FOLDER
    echo ""
    echo -e "\e[32mGenerating patch file for:\e[0m $title at $PATCHES_FOLDER/$file"
    git -C "$ROM_FOLDER" log --oneline --grep="$title" -n 1 --name-only --pretty=format: | tail -n +2 | while read -r file; do
        git -C "$ROM_FOLDER" format-patch --binary --no-stat -1 -- "$file"
        if [ ! -d "$PATCHES_FOLDER" ]; then
            mkdir -p "$PATCHES_FOLDER"
        fi
        patchfiles=$(find "$ROM_FOLDER" -name "*.patch"  | sed -n 1p)
        for patchfile in $patchfiles; do
            # generate timestamp HHMMSS
            pnumber=$((pnumber+1))
            padded_pnumber=$(printf "%04d" "$pnumber")
            patchfile_name=$(basename "$patchfile")
            mv $patchfile "$PATCHES_FOLDER"/$padded_pnumber-$patchfile_name
        done
        echo "Patch file generated for $title at $PATCHES_FOLDER/$file"
    done
done
}

create_patches_grouped() {
    pnumber=0
    # Compare the change subjects and generate patch files for changes not found in AOSP
    comm -23 <(grep -v "^Merge remote-tracking branch" "$TEMP_FOLDER/rom_changes.txt" | grep -v "^Import translations") <(sort "$TEMP_FOLDER/aosp_changes.txt") | while read -r title; do
        # Find the commit in the ROM_FOLDER
    echo ""
    echo -e "\e[32mGenerating patch file for:\e[0m $title at $PATCHES_FOLDER/$file"
        
        # Generate a single patch file for the commit in the ROM_FOLDER
        git -C "$ROM_FOLDER" format-patch --binary --no-stat -1 --grep="$title"
        
        # Find the generated patch file in the ROM_FOLDER
        patchfile=$(find "$ROM_FOLDER" -name "*.patch" | head -n 1)
        if [ "$patchfile" != "" ]; then
            if [ ! -d "$PATCHES_FOLDER" ]; then
                mkdir -p "$PATCHES_FOLDER"
            fi
            pnumber=$((pnumber+1))
            padded_pnumber=$(printf "%04d" "$pnumber")
            patchfile_name=$(basename "$patchfile")
            
            # Move the patch file with the shell date to the PATCHES_FOLDER
            mv "$patchfile" "$PATCHES_FOLDER/$padded_pnumber-$patchfile_name"
            
            echo "Patch file generated for $title at $PATCHES_FOLDER/$padded_pnumber-$patchfile_name"
        fi
    done
}
# ...
if [ "$PATCH_MODE" == "grouped" ]; then
  create_patches_grouped
elif [ "$PATCH_MODE" == "split" ]; then
  create_patches_split
else
  echo "Invalid patch mode. Use 'grouped' or 'split'."
  exit 1
fi

# Clean up temporary files
# rm -r "$TEMP_FOLDER"
# cd $TEMP_FOLDER
# ls -a 

echo "Patch files generated for changes not found in AOSP_FOLDER."

echo -e "\e[32mBuild Patchset Script execution completed.\e[0m"
