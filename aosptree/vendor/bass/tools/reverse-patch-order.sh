#!/bin/bash

# trap 'kill $(jobs -p); exit 1' EXIT

# Function to process patch files in a given patchset directory
process_patch_files() {
    local patchset="$1"
    local patch_num=0
    
    find "$patchset" -type f -name '*.patch' ! -path '*skip*' ! -path '*ignore*' | sort -r | while IFS= read -r patch_file; do
        # echo -e "\e[32mProcessing patch file:\e[0m $patch_file "
        # patch_num=$((patch_num+1))
        # new_patch_file=$(printf "%04d-%s" "$((patch_num-1))" "$(basename "$patch_file" | sed -E 's/^[0-9]+-[0-9]+-[0-9]+-[0-9]+-//')")
        # mv "$patch_file" "$(dirname "$patch_file")/$new_patch_file"
        # Inside the loop where the filenames are being generated
        pnumber=$((pnumber+1))
        padded_pnumber=$(printf "%04d" "$pnumber")
        patchfile_name=$(basename "$patch_file")

        # Remove the [0-9]- prefixes from the filename using sed
        # new_filename=$(sed 's/^[0-9]-\([0-9]-\)\+//' <<< "$patchfile_name")
        new_filename=$(sed 's/^[0-9]\{4\}-[0-9]\{4\}-//' <<< "$patchfile_name")

        # Move the patch file with the new filename to the PATCHES_FOLDER
        mv "$patch_file" "$(dirname "$patch_file")/$padded_pnumber-$new_filename"
    done
}

project_dir=$(pwd)

# Find directories containing .patch files and iterate over them
find "$project_dir/patchsets" -type f -name "*.patch" -exec dirname {} \; | sort -u | while IFS= read -r patchset_folder; do
    if [ -d "$patchset_folder" ]; then
        # Process the patch files
        echo -e "\e[32mProcessing patchset folder:\e[0m $patchset_folder "
        process_patch_files "$patchset_folder"
    else
        echo "Skipping non-directory: $patchset_folder"
    fi
done
