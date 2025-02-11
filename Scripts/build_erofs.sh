#!/bin/bash

system_opts=$(grep -Po 'mkfs.erofs options: +\K(.*$)' Mounts/system/config/system_fs_options)
system_ext_opts=$(grep -Po 'mkfs.erofs options: +\K(.*$)' Mounts/system_ext/config/system_ext_fs_options)
product_opts=$(grep -Po 'mkfs.erofs options: +\K(.*$)' Mounts/product/config/product_fs_options)
vendor_opts=$(grep -Po 'mkfs.erofs options: +\K(.*$)' Mounts/vendor/config/vendor_fs_options)


erofs/mkfs.erofs $system_opts
erofs/mkfs.erofs $system_ext_opts
erofs/mkfs.erofs $product_opts
erofs/mkfs.erofs $vendor_opts

mv system_repack.img Custom/super/system.img
mv system_ext_repack.img Custom/super/system_ext.img
mv product_repack.img Custom/super/product.img
mv vendor_repack.img Custom/super/vendor.img

sudo rm -rf Mounts/system/*
sudo rm -rf Mounts/system_ext/*
sudo rm -rf Mounts/product/*
sudo rm -rf Mounts/vendor/*
