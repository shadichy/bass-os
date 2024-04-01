#!/bin/bash

trap 'kill $(jobs -p); exit 1' SIGINT

project_dir=$(pwd)
rom_path="$project_dir/aosptree"
aosppath="$project_dir/aospbasetree"

if [ ! -d "$rom_path" ]; then
  echo -e "\e[31mROM folder $rom_path does not exist. please run update_bliss_manifest.sh\e[0m"
  exit 1
fi

if [ ! -d "$aosppath" ]; then
  echo -e "\e[31mAOSP folder $aosppath does not exist. please run update_aosp_manifest.sh \e[0m"
  exit 1
fi

start_time=$(date +%s)

# Default values
threaded=false
split=false
history_num=300

# Function to display usage information
display_usage() {
    echo "Usage: $0 [-t] [-s|-g] [-h history_num]"
    echo "Options:"
    echo "  -t             Enable threaded mode (Default: false) !!!!Requires a lot of RAM and will not exit cleanly if canceled!!!!"
    echo "  -s, -g         Enable split or grouped mode (Default: grouped)"
    echo "  -h history_num Set the history number (Default: 300)"
}

function spinner() {
    local info="$1"
    local pid=$!
    local delay=0.75
    local spinstr='|/-\'
    tput civis # cursor invisible
    while kill -0 $pid 2> /dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  $info" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        local reset="\b\b\b\b\b\b"
        for ((i=1; i<=$(echo $info | wc -c); i++)); do
            reset+="\b"
        done
        printf $reset
    done
    tput cnorm # cursor visible
    printf "    \b\b\b\b"
}

function cursorBack() {
  echo -en "\033[$1D"
  # Mac compatible, but goes back to first column always. See comments
  #echo -en "\r"
}

function rand_spinner() {
  # make sure we use non-unicode character type locale 
  # (that way it works for any locale as long as the font supports the characters)
  local LC_CTYPE=C

  local pid=$1 # Process Id of the previous running command

  case $(($RANDOM % 12)) in
  0)
    local spin='⠁⠂⠄⡀⢀⠠⠐⠈'
    local charwidth=3
    ;;
  1)
    local spin='-\|/'
    local charwidth=1
    ;;
  2)
    local spin="▁▂▃▄▅▆▇█▇▆▅▄▃▂▁"
    local charwidth=3
    ;;
  3)
    local spin="▉▊▋▌▍▎▏▎▍▌▋▊▉"
    local charwidth=3
    ;;
  4)
    local spin='←↖↑↗→↘↓↙'
    local charwidth=3
    ;;
  5)
    local spin='▖▘▝▗'
    local charwidth=3
    ;;
  6)
    local spin='┤┘┴└├┌┬┐'
    local charwidth=3
    ;;
  7)
    local spin='◢◣◤◥'
    local charwidth=3
    ;;
  8)
    local spin='◰◳◲◱'
    local charwidth=3
    ;;
  9)
    local spin='◴◷◶◵'
    local charwidth=3
    ;;
  10)
    local spin='◐◓◑◒'
    local charwidth=3
    ;;
  11)
    local spin='⣾⣽⣻⢿⡿⣟⣯⣷'
    local charwidth=3
    ;;
  esac

  local i=0
  tput civis # cursor invisible
  while kill -0 $pid 2>/dev/null; do
    local i=$(((i + $charwidth) % ${#spin}))
    printf "%s" "${spin:$i:$charwidth}"

    cursorBack 1
    sleep .1
  done
  tput cnorm # cursor visible
  wait $pid # capture exit code
  return $?
}


# Parse command-line options
while getopts ":tsg:h:" opt; do
  case $opt in
    t)
      echo -e "\e[32mEnabling threaded mode\e[0m"
      threaded=true
      ;;
    s | g)
      echo -e "\e[32mEnabling split mode\e[0m"
      split=true
      ;;
    h)
      history_num=$OPTARG
      echo -e "\e[32mSetting history number to $history_num\e[0m"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      display_usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      display_usage
      exit 1
      ;;
  esac
done

# Handle the --help option
if [[ "$1" = "--help" ]] || [[ "$1" = "-?" ]]; then
  display_usage
  exit 0
fi

if [ "$1" = "" ]; then
  echo "No arguments provided. Running with default options."
  echo ""
  echo " threaded = false, split = false, history_num = 300"
fi

# Shift the parsed options out of the command-line arguments
shift $((OPTIND - 1))

# Example usage:
# ./your_script.sh -t -s -h 500
# This will enable threaded mode, split mode, and set history number to 500
# ./your_script.sh --help
# This will display the usage information

# Cleanup the patchsets folder if it exists
if [ -d "$project_dir/patchsets" ]; then
    echo -e "\e[32mCleaning up existing patchsets folder\e[0m"
    rm -r "$project_dir/patchsets"
fi

sleep 5

pushd aosptree

rm -rf aosp_folders_missing.txt 

# Generate temporary manifest file
temp_manifest="temp-manifest.xml"
repo manifest -o "$temp_manifest"

# Parse the XML file for repository paths
echo -e "\e[32mGetting repo paths\e[0m"
repo_paths=$(grep 'remote=' "temp-manifest_2.xml" | grep -oP 'path="\K[^"]+')

# Read each repository path
while IFS= read -r repo_path; do
  if [ -n "$repo_path" ]; then    
    rom_repo="$rom_path/$repo_path"
    aosp_repo="$aosppath/$repo_path"
    if [ "$split" = true ]; then
        patchset_mode="split"
    else
        patchset_mode="grouped"
    fi
    if [ "$threaded" = true ]; then
        clear
        bash $rom_path/vendor/bass/tools/build-patchset.sh "$rom_repo" "$aosp_repo" "$history_num" "$patchset_mode" "$project_dir" &> /dev/null & 
        spinner "Generating patchsets for $repo_path" &
    else
        echo -e "\e[33mChecking $repo_path to see if patchsets are needed\e[0m"
        bash $rom_path/vendor/bass/tools/build-patchset.sh "$rom_repo" "$aosp_repo" "$history_num" "$patchset_mode" "$project_dir" &> /dev/null &
        rand_spinner $! 
    fi
  else
    echo -e "\e[31mRepository path is empty. Skipping...\e[0m"
  fi

done <<< "$repo_paths"

wait

# Clean up the temporary manifest file
rm "$temp_manifest"

mv $project_dir/aosptree/aosp_folders_missing.txt $project_dir

popd

# Check each folder in $project_dir/patchsets/*, and if the folder has .patch files
# we will want to make a reverse order list of the patch files, and rename them one by one from 
# 1959561711843196723-0001-xxx.patch, 1959561711843196709-0001-xxx.patch to be 0001-xxx.patch, 0002-xxx.patch, etc.

echo -e "\e[33mReversing patch orders for all patchsets\e[0m"

bash $project_dir/bass/tools/reverse-patch-order.sh

echo -e "\e[92mFinished\e[0m"
end_time=$(date +%s)
execution_time=$((end_time - start_time))
# format the execution time to HH:MM:SS
execution_hours=$((execution_time / 3600))
execution_minutes=$(((execution_time % 3600) / 60))
execution_seconds=$((execution_time % 60))
execution_time_formatted=$(printf "%02d:%02d:%02d" $execution_hours $execution_minutes $execution_seconds)
echo -e "\e[32mTotal execution time: $execution_time_formatted\e[0m"




