#!/bin/bash

# Extract archives
tar -xvf Stock/BL_* -C Custom/BL/
tar -xvf Stock/AP_* -C Custom/AP/
tar -xvf Stock/CP_* -C Custom/CP/
tar -xvf Stock/CSC_* -C Custom/CSC/

# Check and replace optics/prism partitions for USA CSC
if ls Stock/USA_CSC_* 1> /dev/null 2>&1; then
    mkdir Custom/CSC_USA
    tar -xvf Stock/USA_CSC_* -C Custom/CSC_USA/
    mv Custom/CSC_USA/optics.img.lz4 Custom/CSC/
    mv Custom/CSC_USA/prism.img.lz4 Custom/CSC/
    rm -rf Custom/CSC_USA
fi

