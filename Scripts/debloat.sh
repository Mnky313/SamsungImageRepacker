#!/bin/bash

declare -a packagepaths=(
    "system/system/app"
    "system/system/priv-app"
    "system/system/system_ext/app"
    "system/system/system_ext/priv-app"
    "product/app"
    "product/priv-app"
    "vendor/app"
    "vendor/priv-app"
)

for path in "${packagepaths[@]}"; do
    for package in $(cat Mods/bloatware.txt); do
        if ls Mounts/$path/$package 1> /dev/null 2>&1; then
            echo Removing $path/$package...
            sudo rm -rf Mounts/$path/$package
        fi
    done
done