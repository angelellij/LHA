#!/bin/bash

declare -A commands=(
    ["Config"]="code ~/.config > /dev/null 2>&1"
)

github_dir=~/Documents/GitHub
for folder in "$github_dir"/*/; do
    folder_name=$(basename "$folder")
    key="Code $folder_name"
    value="code \"$folder\" > /dev/null 2>&1"
    commands["$key"]="$value"
done

for option in "${!commands[@]}"; do
    if [ "$option" = "$1" ]; then
        coproc eval "${commands[$option]}"
        exit 0
    fi
done

for option in "${!commands[@]}"; do
    echo $option
done