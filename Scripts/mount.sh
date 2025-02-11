#!/bin/bash

# System
sudo mount -t ext4 -o loop Custom/super/system.img Mounts/system
# Product
sudo mount -t ext4 -o loop Custom/super/product.img Mounts/product
# Vendor
sudo mount -t ext4 -o loop Custom/super/vendor.img Mounts/vendor