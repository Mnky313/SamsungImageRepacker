#!/bin/bash

echo "Waiting for device..."
while true ; do
    command=$(./odin4 -l)
    if [[ ! -z "$command" ]] ; then 
        break
    fi
    sleep 5
done

./odin4 \
-b Custom/BL_modified.tar \
-a Custom/AP_modified.tar \
-c Custom/CP_modified.tar \
-s Custom/CSC_modified.tar \
-d $(./odin4 -l)