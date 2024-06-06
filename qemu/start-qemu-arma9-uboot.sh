#!/usr/bin/env bash

sudo qemu-system-arm \
    -M vexpress-a9 \
    -m 512M \
    -net nic -net tap,ifname=tap0 \
    -nographic \
    -kernel u-boot
