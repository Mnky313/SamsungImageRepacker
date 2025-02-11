#!/bin/bash
mv Custom/super/system.img Custom/super/system.img.orig
mv Custom/super/system_ext.img Custom/super/system_ext.img.orig
mv Custom/super/product.img Custom/super/product.img.orig
mv Custom/super/vendor.img Custom/super/vendor.img.orig

erofs/extract.erofs -i Custom/super/system.img.orig -x -f -o Mounts/system
erofs/extract.erofs -i Custom/super/system_ext.img.orig -x -f -o Mounts/system_ext
erofs/extract.erofs -i Custom/super/product.img.orig -x -f -o Mounts/product
erofs/extract.erofs -i Custom/super/vendor.img.orig -x -f -o Mounts/vendor