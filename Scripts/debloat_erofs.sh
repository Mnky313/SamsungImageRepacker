#!/bin/bash

for package in $(cat Mods/bloatware.txt); do
    part=$(echo $package | grep -Po '^\w+/')
    echo $part$package

    # Modify system_file_context
    temppkg=${package//\//\\\/}
    temppkg=${temppkg//\./\\\.}
    sed -i "/^\/$temppkg/d" Mounts/${part::-1}/config/${part::-1}_file_contexts
    sed -i "/^\/$temppkg/d" Mounts/${part::-1}/config/${part::-1}_fs_config
    
    # Remove package
    sudo rm -rf Mounts/$part$package
done