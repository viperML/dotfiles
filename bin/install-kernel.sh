#!/bin/bash

NAME="Gentoo_$(date -u +"%Y%m%d_%H%M")"
echo "$NAME"

KERNEL_ARGS="
root=PARTUUID=5ca5c883-b2b0-1f4a-aeca-d1c2c23e06a3
initrd=\intel-uc.img
initrd=\EFI\Gentoo\initramfs.img
quiet
splash
vt.global_cursor_default=0
nvidia-drm.modeset=1
"

# List installed bootloaders
bootloaders="$(efibootmgr | grep -E "Boot[[:digit:]]{4}" | sed -n '/Gentoo/p')"
old_bootloader="$(efibootmgr | grep -E "Boot[[:digit:]]{4}" | sed -n '/Gentoo/p' | sort -t' ' -n -r -k2 | head -n1)"
echo "Bootloaders available: "
echo "$bootloaders"
echo -e "Deleting\n $old_bootloader"

# efibootmgr \
# 	--create \
# 	--part 1 \
# 	--disk /dev/nvme0n1 \
# 	--label "$NAME" \
# 	--loader '\EFI\Gentoo\bzImage.efi' \
# 	--unicode "$KERNEL_ARGS" \
# 	--verbose
