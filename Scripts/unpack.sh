#!/bin/bash

# Create directories
mkdir -p Custom/BL
mkdir -p Custom/AP
mkdir -p Custom/CP
mkdir -p Custom/CSC
mkdir -p Custom/super

# Extract archives
tar -xvf Stock/BL_* -C Custom/BL/
tar -xvf Stock/AP_* -C Custom/AP/
tar -xvf Stock/CP_* -C Custom/CP/
tar -xvf Stock/CSC_* -C Custom/CSC/

# Check and replace optics/prism partitions for USA CSC
if ls Stock/USA_CSC_* 1> /dev/null 2>&1; then
    mkdir Custom/CSC_USA
    tar -xvf Stock/USA_CSC_* -C Custom/CSC_USA/
    if ls Custom/CSC_USA/optics.img 1> /dev/null 2>&1; then
        mv Custom/CSC_USA/optics.img Custom/CSC/
        rm -f Custom/CSC/optics.img.lz4
    else
        mv Custom/CSC_USA/optics.img.lz4 Custom/CSC/
    fi
    if ls Custom/CSC_USA/prism.img 1> /dev/null 2>&1; then
        mv Custom/CSC_USA/prism.img Custom/CSC/
        rm -f Custom/CSC/prism.img.lz4
    else
        mv Custom/CSC_USA/prism.img.lz4 Custom/CSC/
    fi
    rm -rf Custom/CSC_USA
fi

# Copy modified boot img
if ls Mods/boot.img 1> /dev/null 2>&1; then
    cp Mods/boot.img Custom/AP/
    rm -rf Custom/AP/boot.img.lz4
fi
