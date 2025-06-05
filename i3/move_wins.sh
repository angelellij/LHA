#!/bin/bash

chrome_windows=0

i3-msg -t subscribe -m '[ "window" ]' | while read -r line; do
    window_class=$(echo "$line" | grep -o '"class":"[^"]*"' | cut -d '"' -f 4)
    
    if [[ "$window_class" == "discord" ]]; then
        i3-msg '[class="discord"] move to workspace 3'
        i3-msg 'workspace 3'
    elif [[ "$window_class" == "Google-chrome" ]]; then
        if [[ $chrome_windows -eq 0 ]]; then
            i3-msg '[class="Google-chrome"] move to workspace 2'
            i3-msg 'workspace 2'
        fi
        chrome_windows=$((chrome_windows + 1))
    fi
done
