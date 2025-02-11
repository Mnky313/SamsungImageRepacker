#!/bin/bash

for apk in Mods/APKs/*.apk; do
    sudo mkdir Mounts/system/system/system/priv-app/$(basename "$apk" .apk)
    sudo cp "$apk" Mounts/system/system/system/priv-app/$(basename "$apk" .apk)/
    sudo chmod 0644 Mounts/system/system/system/priv-app/$(basename "$apk" .apk)/$(basename "$apk")

    echo /system/system/system/priv-app/$(basename "$apk" .apk) u:object_r:system_file:s0 >> Mounts/system/config/system_file_contexts
    echo /system/system/system/priv-app/$(basename "$apk" .apk)/$(basename "$apk" .apk)\\.apk u:object_r:system_file:s0 >> Mounts/system/config/system_file_contexts

    echo system/system/priv-app/$(basename "$apk" .apk) 0 0 0755 >> Mounts/system/config/system_fs_config
    echo system/system/priv-app/$(basename "$apk" .apk)/$(basename "$apk" .apk)\\.apk 0 0 0644 >> Mounts/system/config/system_fs_config
done

