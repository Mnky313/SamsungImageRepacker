#!/bin/bash

# Decompress super
lz4 Custom/AP/super.img.lz4
simg2img Custom/AP/super.img Custom/AP/super.raw
lp/lpunpack Custom/AP/super.raw Custom/super

# Delete old images
rm Custom/AP/super.img.lz4
rm Custom/AP/super.img
rm Custom/AP/super.raw
