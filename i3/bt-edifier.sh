#!/bin/bash

# Stop and start bluetooth service
sudo systemctl stop bluetooth
sudo systemctl start bluetooth

# Remove the device
bluetoothctl remove 60:F4:3A:16:04:D0

# Wait for scanning to complete
while ! bluetoothctl scan on | grep -q "60:F4:3A:16:04:D0"; do
    sleep 1
done

# Connect to the device
bluetoothctl connect 60:F4:3A:16:04:D0

# Turn off scanning
bluetoothctl scan off &>/dev/null &

exit 0