#!/bin/sh

BINARIES_DIR="${0%/*}/"
# shellcheck disable=SC2164
cd "${BINARIES_DIR}"

mode_serial=false
mode_sys_qemu=false
while [ "$1" ]; do
    case "$1" in
    --serial-only|serial-only) mode_serial=true; shift;;
    --use-system-qemu) mode_sys_qemu=true; shift;;
    --) shift; break;;
    *) echo "unknown option: $1" >&2; exit 1;;
    esac
done

if ${mode_serial}; then
    EXTRA_ARGS='-nographic'
else
    EXTRA_ARGS=''
fi

if ! ${mode_sys_qemu}; then
    export PATH="/home/wangbr/Workspace/buildroot/output/host/bin:${PATH}"
fi

sudo qemu-system-x86_64 \
   -M microvm,x-option-roms=off,pit=off,pic=off,isa-serial=off,rtc=off \
   -enable-kvm -cpu host -m 512m -smp 2 \
   -kernel bzImage -append "console=hvc0 root=/dev/vda" \
   -nodefaults -no-user-config -nographic \
   -chardev stdio,id=virtiocon0 \
   -device virtio-serial-device \
   -device virtconsole,chardev=virtiocon0 \
   -drive id=test,file=rootfs.ext2,format=raw,if=none \
   -device virtio-blk-device,drive=test \
   -netdev tap,id=tap0,script=no,downscript=no \
   -device virtio-net-device,netdev=tap0
