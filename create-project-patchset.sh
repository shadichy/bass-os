#!/bin/bash -e

trap 'echo -e "\ncreate-project-patchset.sh interrupted"; exit 1' SIGINT

echo -e "\033[1;34mCreate project patchset\033[0m"
bash bass/tools/tool-create-project-patchset.sh $@


