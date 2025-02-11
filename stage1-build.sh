#!/bin/bash

sh Scripts/unpack.sh
sh Scripts/patch_vbmeta.sh
sh Scripts/extract_super.sh
sh Scripts/mount.sh
sh Scripts/debloat.sh
sh Scripts/install_apps.sh
sh Scripts/unmount.sh
sh Scripts/build_super.sh
sh Scripts/pack.sh
sh Scripts/flash.sh
#sh Scripts/cleanup.sh
