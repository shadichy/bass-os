#!/bin/bash -e

trap 'echo -e "\nbuild_bass.sh interrupted"; exit 1' SIGINT

echo -e "\033[1;34mBuilding Bass OS\033[0m"
. build/envsetup.sh
build-waydroid $@

