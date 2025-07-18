#!/bin/bash

declare -a packagepaths=(
    "system/system/system/app"
    "system/system/system/priv-app"
    "system_ext/system_ext/app"
    "system_ext/system_ext/priv-app"
    "product/product/app"
    "product/product/priv-app"
    "product/product/overlay"
    "vendor/vendor/app"
    "vendor/vendor/priv-app"
)

for path in "${packagepaths[@]}"; do
    for package in $(cat Mods/bloatware.txt); do
        if ls Mounts/$path/$package 1> /dev/null 2>&1; then
            tmppart=$(echo $path | grep -Po '^\w+/')
            part=${tmppart::-1}

            printf "Removing $path/$package...\n"

            tmppath=${path//$part\/$part/$part} # Remove partition from path (i.e. /system_ext/system_ext/... -> /system_ext/...)
            temppkg=$tmppath/$package # Combine package with real path
            temppkg=${temppkg//\//\\\/} # Escape / for regex match
            temppkg=${temppkg//\./\\\.} # Escape . for regex match
            temppkg=${temppkg//\*/.*} # Convert * to .* so regex match works for bloatware with wildcard
            
            sed -i "/^\/$temppkg[\/ ]/d" Mounts/$part/config/${part}_file_contexts # Modify file_context to remove removed package(s)
            sed -i "/^$temppkg[\/ ]/d" Mounts/$part/config/${part}_fs_config # Modify fs_config to remove removed package(s)
            
            sudo rm -rf Mounts/$path/$package
        fi
    done
done