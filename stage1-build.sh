#!/bin/bash

sh Scripts/unpack.sh
sh Scripts/patch_vbmeta.sh
sh Scripts/extract_super.sh
if erofs/dump.erofs Custom/super/system.img; then
    printf 'EROFS Image\n'
    sh Scripts/extract_erofs.sh
    sh Scripts/debloat_erofs.sh
    sh Scripts/install_apps_erofs.sh
    sh Scripts/build_erofs.sh
    sh Scripts/build_super_erofs.sh
else
    printf 'EXT4 Image\n'
    sh Scripts/mount.sh
    sh Scripts/debloat.sh
    sh Scripts/install_apps.sh
    sh Scripts/unmount.sh
    sh Scripts/build_super.sh
fi
sh Scripts/pack.sh
sh Scripts/flash.sh
#sh Scripts/cleanup.sh
