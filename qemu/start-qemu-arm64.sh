#!/usr/bin/env bash

#!/bin/sh

BINARIES_DIR="${0%/*}/"
# shellcheck disable=SC2164
cd "${BINARIES_DIR}"

# nvme0.img created by `dd if=/dev/zero of=nvme0.img bs=1M count=64`.
#-drive file=nvme0.img,if=none,format=raw,id=nvme0 -device nvme,drive=nvme0,serial=1234 \
#-drive file=nvme1.img,if=none,format=raw,id=nvme1 -device nvme,drive=nvme1,serial=5678 \

exec qemu-system-aarch64 \
    -M virt,gic_version=3 \
    -M virtualization=true \
    -cpu cortex-a57 \
    -nographic \
    -smp 2 \
    -kernel Image \
    -append "rootwait root=/dev/vda console=ttyAMA0" \
    -netdev user,id=eth0 -device virtio-net-device,netdev=eth0 \
    -drive file=rootfs.ext2,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 \
    "$@"
