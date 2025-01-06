#!/bin/bash -e

trap 'echo -e "\nbuild_bass.sh interrupted"; exit 1' SIGINT

if [ ! -f .config/vendor_config.cfg ]; then
    echo -e "\033[1;31mERROR: vendor_config.cfg not found\033[0m"
    exit 1
fi

# load variables from .config/vendor_config.cfg
# and for each line, export the variable

source .config/vendor_config.cfg

echo -e "\033[1;34mVendor Title: ${vendor_title}\033[0m"
echo -e "\033[1;34mVendor Variant: ${vendor_variant}\033[0m"
echo -e "\033[1;34mLunch Target: ${vendor_lunch_target}\033[0m"
echo -e "\033[1;34mMake Target: ${vendor_make_target}\033[0m"
echo -e "\033[1;34mBass Tools Target: ${vendor_bass_tools_target}\033[0m"
echo -e "\033[1;34mBuild Tools Script: ${vendor_bass_tools_target_script}\033[0m"

export vendor_title=${vendor_title}
export vendor_variant=${vendor_variant}
export vendor_lunch_targets=${vendor_lunch_target}
export vendor_make_target=${vendor_make_target}
export vendor_bass_tools_target=${vendor_bass_tools_target}
export vendor_bass_tools_target_script=${vendor_bass_tools_target_script}

echo -e ""

echo -e "\033[1;34mBuilding Bass OS\033[0m"
pushd aosptree
. build/envsetup.sh
build-x86 $@
popd

