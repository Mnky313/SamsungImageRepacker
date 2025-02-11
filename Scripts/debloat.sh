#!/bin/bash

for package in $(cat Mods/bloatware.txt); do
    echo $package
    sudo rm -rf Mounts/$package
done