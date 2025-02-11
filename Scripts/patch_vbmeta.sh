#!/bin/bash

# Decompress & Patch
lz4 Custom/BL/vbmeta.img.lz4
rm Custom/BL/vbmeta.img.lz4
lp/vbmeta-disable-verification Custom/BL/vbmeta.img

if [ -f "Custom/AP/vbmeta.img.lz4" ]; then
    lz4 Custom/AP/vbmeta.img.lz4
    rm Custom/AP/vbmeta.img.lz4
    lp/vbmeta-disable-verification Custom/AP/vbmeta.img
fi