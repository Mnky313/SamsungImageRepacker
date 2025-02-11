#!/bin/bash

lp/lpmake \
--metadata-size 65535 --super-name super \
--metadata-slots 1 \
--device super:$(stat -c '%s' "$(pwd)/Custom/AP/super.raw") \
--group main:$(expr $(stat -c '%s' "$(pwd)/Custom/super/odm.img") + $(stat -c '%s' "$(pwd)/Custom/super/product.img") + $(stat -c '%s' "$(pwd)/Custom/super/system.img") + $(stat -c '%s' "$(pwd)/Custom/super/vendor.img")) \
--partition odm:readonly:$(stat -c '%s' "$(pwd)/Custom/super/odm.img"):main --image odm="$(pwd)/Custom/super/odm.img" \
--partition product:readonly:$(stat -c '%s' "$(pwd)/Custom/super/product.img"):main --image product="$(pwd)/Custom/super/product.img" \
--partition system:readonly:$(stat -c '%s' "$(pwd)/Custom/super/system.img"):main --image system="$(pwd)/Custom/super/system.img" \
--partition vendor:readonly:$(stat -c '%s' "$(pwd)/Custom/super/vendor.img"):main --image vendor="$(pwd)/Custom/super/vendor.img" \
--sparse \
--output "$(pwd)/Custom/AP/super.img"

rm Custom/AP/super.raw 