#!/bin/bash

# Install system apps as user
for apk in Mods/APKs/*.apk; do
    adb install "$apk"
done

# Remove user bloatware packages
for package in $(cat Mods/bloatware-user.txt); do
    echo $package
    adb uninstall "$package"
done

# Disable Bluetooth
adb shell cmd bluetooth_manager disable