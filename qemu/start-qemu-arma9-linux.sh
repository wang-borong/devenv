#!/usr/bin/env bash

qemu-system-arm -cpu cortex-a15 -smp 4 -m 512 \
    -machine type=vexpress-a9 -serial mon:stdio \
    -drive if=sd,driver=file,filename=rootfs.ext2 \
    -kernel zImage  \
    -dtb vexpress-v2p-ca9.dtb \
    -nographic \
    -append "console=ttyAMA0 root=/dev/mmcblk0 ro"
