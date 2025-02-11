# This is linux only

I use these scripts to unpack, debloat & modify, then repack firmware for flashing via the included odin.

Currently this only works with devices that use EXT4 not EROFS (it seems like devices after ~2022 switched to EROFS, my Fold3 doesn't use it but Fold5 does).

Working on adding EROFS support

# Basic steps to use this to debloat/install apps.

Copy stock firmware images (BL_\*.tar.md5, AP_\*.tar.md5, CP_\*.tar.md5, CSC_\*.tar.md5) to the Stock folder (if you want to pre-patch the AP file with magisk that also works just make sure it's named AP_\*)

Modify the Mods/bloatware.txt file with the list of packages you want to remove, I included mine however mine also removes play services and related items because I replace them with microG (as well as breaks bluetooth support, never bothered to figure out what causes that as I don't use bluetooth so I just leave it off)

(if you want to manually mess with the filesystem check out the manual instructions later on)

Add any APKs you want to be installed as system/priv-apps to the Mods/APKs folder

cd into the root of this folder & run sh ./stage1-build.sh

Once you get to 'waiting for device...' plug in your phone in Download mode and it should flash.

# Manual Steps/what the scripts do

(I'm assuming your current directory is the root directory of this repo for all these commands)

Copy stock firmware images (BL_\*.tar.md5, AP_\*.tar.md5, CP_\*.tar.md5, CSC_\*.tar.md5) to the Stock folder (if you want to pre-patch the AP file with magisk that also works just make sure it's named AP_\*)

Extract the firmware to relevant folders:
```
tar -xvf Stock/BL_* -C Custom/BL/
tar -xvf Stock/AP_* -C Custom/AP/
tar -xvf Stock/CP_* -C Custom/CP/
tar -xvf Stock/CSC_* -C Custom/CSC/
```

if you want to replace certain images you can now, for example if you're in the US you might want to replace the stock international device's prism/optics partition with one from a US model.

Patch VBMETA partition to prevent verification error:
```
lz4 Custom/BL/vbmeta.img.lz4 # Decompress lz4
rm Custom/BL/vbmeta.img.lz4 # Delete compressed image so it doesn't get repacked later
lp/vbmeta-disable-verification Custom/BL/vbmeta.img # Disable verification
```

Extract super partition:
```
lz4 Custom/AP/super.img.lz4 # Decompress lz4
simg2img Custom/AP/super.img Custom/AP/super.raw # Convert sparse image to raw
lp/lpunpack Custom/AP/super.raw Custom/super # Extract image
# Delete old images so they don't get repacked later
rm Custom/AP/super.img.lz4 
rm Custom/AP/super.img
rm Custom/AP/super.raw
```

Mounting partitions:

Only certain partitions can be mounted this way, the important ones that you probably want to delete apps from are:
```
# System
sudo mount -t ext4 -o loop Custom/super/system.img Mounts/system
# Product
sudo mount -t ext4 -o loop Custom/super/product.img Mounts/product
# Vendor
sudo mount -t ext4 -o loop Custom/super/vendor.img Mounts/vendor
```

At this point you can modify the images from the Mounts/* folders.
Make sure if you are adding apps that they have their permissions set correctly (0644)

Once done you can unmount the partitions:
```
# System
sudo umount Custom/super/system.img
# Product
sudo umount Custom/super/product.img
# Vendor
sudo umount Custom/super/vendor.img
```

Rebuild super partition:
This long command automatically grabs the size of the images instead of having to manually calculate them.

This --device super:X *might* be device specific but AFAIK it works on both my Fold3 and 5 so I assume it's not, though they are both 256gb phones so it probably would need to be changed for different storage sizes.
```
lp/lpmake \
--metadata-size 65535 --super-name super \
--metadata-slots 1 \
--device super:12979273728 \
--group main:$(expr $(stat -c '%s' "$(pwd)/Custom/super/odm.img") + $(stat -c '%s' "$(pwd)/Custom/super/product.img") + $(stat -c '%s' "$(pwd)/Custom/super/system.img") + $(stat -c '%s' "$(pwd)/Custom/super/vendor.img")) \
--partition odm:readonly:$(stat -c '%s' "$(pwd)/Custom/super/odm.img"):main --image odm="$(pwd)/Custom/super/odm.img" \
--partition product:readonly:$(stat -c '%s' "$(pwd)/Custom/super/product.img"):main --image product="$(pwd)/Custom/super/product.img" \
--partition system:readonly:$(stat -c '%s' "$(pwd)/Custom/super/system.img"):main --image system="$(pwd)/Custom/super/system.img" \
--partition vendor:readonly:$(stat -c '%s' "$(pwd)/Custom/super/vendor.img"):main --image vendor="$(pwd)/Custom/super/vendor.img" \
--sparse \
--output "$(pwd)/Custom/AP/super.img"
```

Repack the images into tar
```
cd Custom/BL
tar -cvf ../BL_modified.tar *.*
cd ../AP
tar -cvf ../AP_modified.tar meta-data *.*
cd ../CP
tar -cvf ../CP_modified.tar *.*
cd ../CSC
tar -cvf ../CSC_modified.tar meta-data *.*
cd ../..
```

Flash:
The -d flag shouldn't be needed but I've had better luck with it so I just left it.
```
./odin4 \
-b Custom/BL_modified.tar \
-a Custom/AP_modified.tar \
-c Custom/CP_modified.tar \
-s Custom/CSC_modified.tar \
-d $(./odin4 -l)
```

# Manual modification of EROFS devices

Follow the same steps until you get to the mounting partitions section.

Move original images so we can rebuild them later
```
mv Custom/super/system.img Custom/super/system.img.orig
mv Custom/super/system_ext.img Custom/super/system_ext.img.orig
mv Custom/super/product.img Custom/super/product.img.orig
mv Custom/super/vendor.img Custom/super/vendor.img.orig
```

Extract the images:
```
erofs/extract.erofs -i Custom/super/system.img.orig -x -f -o Mounts/system
erofs/extract.erofs -i Custom/super/system_ext.img.orig -x -f -o Mounts/system_ext
erofs/extract.erofs -i Custom/super/product.img.orig -x -f -o Mounts/product
erofs/extract.erofs -i Custom/super/vendor.img.orig -x -f -o Mounts/vendor
```

At this point you can modify these images in their Mounts/* folder.
**make sure you update the Mounts/X/config/system_fs_options file to reflect your changes** (removing/adding folders/files)

After you're done you can use the commands in the Mounts/X/config/system_fs_options to rebuild the images in their original location (not .orig)

From there the steps are the same as EXT4, use lpmake to rebuild the super partition & tar the partitions together like normal.


# Stage 2 ADB script

There are some apps that are in partitions that can't be mounted (optics/prism) as well as user apps that aren't removed but can be simply uninstalled after the phone is booted.

This script handles that but looking at Mods/bloatware-user.txt

It also installs the system apks as the user to make them actually function correctly.

(and it disables bluetooth)