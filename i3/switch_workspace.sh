#!/bin/bash

# Function to get the focused output (monitor) using i3-msg
get_focused_output() {
    i3-msg -t get_workspaces | jq -r '.[] | select(.focused).output'
}

# Function to get the active workspace on a specific output (monitor) using i3-msg
get_workspace_on_output() {
    local output="$1"
    i3-msg -t get_workspaces | jq -r ".[] | select(.output == \"$output\" and .visible).name"
}

# Function to check if a workspace is active on any output other than the focused one
is_workspace_selected_on_other_outputs() {
    local workspace="$1"
    local focused_output=$(get_focused_output)

    # Get list of all outputs excluding xroot-0
    local outputs=($(i3-msg -t get_outputs | jq -r '.[].name | select(. != "xroot-0")'))

    # Iterate through outputs
    for output in "${outputs[@]}"; do
        if [ "$output" != "$focused_output" ]; then
            local active_workspace=$(get_workspace_on_output "$output")
            if [ "$active_workspace" = "$workspace" ]; then
                echo 1
                return
            fi
        fi
    done

    echo 0
}

# Get the focused output (monitor)
focused_output=$(get_focused_output)

if [ -n "$focused_output" ]; then
    result=$(is_workspace_selected_on_other_outputs "$1")
    if [ "$result" = 1 ]; then
        ~/.config/i3/swap_workspaces.sh
        i3-msg "workspace $1"
    else
        i3-msg "workspace $1; move workspace to output $focused_output"
    fi
   
else
    echo "Failed to get focused output."
fi
