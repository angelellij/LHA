#!/bin/bash

# Get the names of connected outputs (screens)
outputs=$(xrandr | awk '/ connected/ {print $1}')

# Get the currently focused workspace
focused_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')

# Get the first and second output
output1=$(echo "$outputs" | head -n 1)
output2=$(echo "$outputs" | tail -n 1)

# Get the workspaces currently visible on each output
workspace_output1=$(i3-msg -t get_outputs | jq -r ".[] | select(.name==\"$output1\") | .current_workspace")
workspace_output2=$(i3-msg -t get_outputs | jq -r ".[] | select(.name==\"$output2\") | .current_workspace")

# Move the workspaces to each other's outputs
i3-msg "workspace $workspace_output1; move workspace to output $output2"
i3-msg "workspace $workspace_output2; move workspace to output $output1"