#!/bin/bash

cd Custom/BL
tar -cvf ../BL_modified.tar *.*
cd ../AP
tar -cvf ../AP_modified.tar meta-data *.*
cd ../CP
tar -cvf ../CP_modified.tar *.*
cd ../CSC
tar -cvf ../CSC_modified.tar meta-data *.*
cd ../..