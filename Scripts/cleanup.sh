#!/bin/bash
sudo rm -rf Mounts
sudo rm -rf Custom
sudo rm -rf *_repack.img

mkdir Custom
mkdir Custom/AP Custom/BL Custom/CP Custom/CSC Custom/super

mkdir Mounts
mkdir Mounts/system Mounts/system_ext Mounts/product Mounts/vendor