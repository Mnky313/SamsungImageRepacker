#!/bin/bash

for apk in Mods/APKs/*.apk; do
    echo Adding /system/system/priv-app/$apk...
    sudo mkdir Mounts/system/system/priv-app/$(basename "$apk" .apk)
    sudo cp "$apk" Mounts/system/system/priv-app/$(basename "$apk" .apk)/
    sudo chmod 0644 Mounts/system/system/priv-app/$(basename "$apk" .apk)/$(basename "$apk")
done

