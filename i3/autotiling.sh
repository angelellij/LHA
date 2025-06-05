#!/bin/bash

# Function to check the current window count and split accordingly
check_and_split() {
    # Get the ID of the active window
    active_window_id=$(xdotool getactivewindow)

    # Get the desktop (workspace) of the active window
    desktop=$(xdotool get_desktop_for_window $active_window_id)

    # Get the number of windows in the current workspace
    window_count=$(wmctrl -l | awk -v d="$desktop" '$2 == d {print $1}' | wc -l)
    if [ "$window_count" -gt 1 ]; then
        i3-msg "split v"
    else
        i3-msg "split h"
    fi
}

# Subscribe to window events and call check_and_split function
i3-msg -t subscribe -m '["window"]' | while read -r event; do
    check_and_split
done
