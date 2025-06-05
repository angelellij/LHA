#!/bin/bash

declare -A commands=(
    ["Config"]="code ~/.config > /dev/null 2>&1"
)

for option in "${!commands[@]}"; do
    if [ "$option" = "$1" ]; then
        coproc eval "${commands[$option]}"
        exit 0
    fi
done

for option in "${!commands[@]}"; do
    echo $option
done