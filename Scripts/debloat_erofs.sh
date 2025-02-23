#!/bin/bash

declare -a packagepaths=(
    "system/system/system/app"
    "system/system/system/priv-app"
    "system_ext/system_ext/app"
    "system_ext/system_ext/priv-app"
    "product/product/app"
    "product/product/priv-app"
    "vendor/vendor/app"
    "vendor/vendor/priv-app"
)

for path in "${packagepaths[@]}"; do
    for package in $(cat Mods/bloatware.txt); do
        if ls Mounts/$path/$package 1> /dev/null 2>&1; then
            tmppart=$(echo $path | grep -Po '^\w+/')
            part=${tmppart::-1}

            echo Removing $path/$package...

            # Modify system_file_context
            tmppath=${path//$part\/$part/$part}
            temppkg=${package//\*/.*}
            temppkg=$tmppath/$temppkg
            temppkg=${temppkg//\//\\\/}
            temppkg=${temppkg//\./\\\.}
            
            sed -i "/^\/$temppkg[\/ ]/d" Mounts/$part/config/${part}_file_contexts
            sed -i "/^$temppkg[\/ ]/d" Mounts/$part/config/${part}_fs_config
            
            sudo rm -rf Mounts/$path/$package
        fi
    done
done