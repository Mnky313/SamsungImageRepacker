#!/bin/bash

lp/lpmake \
--metadata-size 65535 --super-name super \
--metadata-slots 1 \
--device super:$(stat -c '%s' "$(pwd)/Custom/AP/super.raw") \
--group main:$(expr $(stat -c '%s' "$(pwd)/Custom/super/odm.img") + $(stat -c '%s' "$(pwd)/Custom/super/product.img") + $(stat -c '%s' "$(pwd)/Custom/super/system.img") + $(stat -c '%s' "$(pwd)/Custom/super/system_dlkm.img") + $(stat -c '%s' "$(pwd)/Custom/super/system_ext.img") + $(stat -c '%s' "$(pwd)/Custom/super/vendor.img") + $(stat -c '%s' "$(pwd)/Custom/super/vendor_dlkm.img")) \
--partition odm:readonly:$(stat -c '%s' "$(pwd)/Custom/super/odm.img"):main --image odm="$(pwd)/Custom/super/odm.img" \
--partition product:readonly:$(stat -c '%s' "$(pwd)/Custom/super/product.img"):main --image product="$(pwd)/Custom/super/product.img" \
--partition system:readonly:$(stat -c '%s' "$(pwd)/Custom/super/system.img"):main --image system="$(pwd)/Custom/super/system.img" \
--partition system_dlkm:readonly:$(stat -c '%s' "$(pwd)/Custom/super/system_dlkm.img"):main --image system_dlkm="$(pwd)/Custom/super/system_dlkm.img" \
--partition system_ext:readonly:$(stat -c '%s' "$(pwd)/Custom/super/system_ext.img"):main --image system_ext="$(pwd)/Custom/super/system_ext.img" \
--partition vendor:readonly:$(stat -c '%s' "$(pwd)/Custom/super/vendor.img"):main --image vendor="$(pwd)/Custom/super/vendor.img" \
--partition vendor_dlkm:readonly:$(stat -c '%s' "$(pwd)/Custom/super/vendor_dlkm.img"):main --image vendor_dlkm="$(pwd)/Custom/super/vendor_dlkm.img" \
--sparse \
--output "$(pwd)/Custom/AP/super.img"

rm Custom/AP/super.raw 