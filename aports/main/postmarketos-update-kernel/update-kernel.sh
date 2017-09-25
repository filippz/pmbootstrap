#!/bin/sh
set -e

case $1 in
	--help|-h|'')
		echo "Usage: update-kernel [flavor]"
		exit 1
		;;
esac

# shellcheck disable=SC1091
. /etc/deviceinfo
FLAVOR=$1
mountpoint -q /boot/ || {
	echo "Mounting boot partition..."
	mount -o ro "$(findfs LABEL='pmOS_boot')" /boot/
}
case ${deviceinfo_flash_methods:?} in
	fastboot|heimdall-bootimg)
		echo "Flashing boot.img..."
		BOOT_PARTITION=$(findfs PARTLABEL="boot")
		dd if=/boot/boot.img-"$FLAVOR" of="$BOOT_PARTITION"
		;;
	heimdall-isorec)
		echo "Flashing kernel with isorec method..."
		KERNEL_PARTITION=$(findfs PARTLABEL="${deviceinfo_heimdall_partition_kernel:?}")
		INITFS_PARTITION=$(findfs PARTLABEL="${deviceinfo_heimdall_partition_initfs:?}")
		dd if=/boot/vmlinuz-"$FLAVOR" of="$KERNEL_PARTITION"
		gunzip -c /boot/initramfs-"$FLAVOR" | lzop > "$INITFS_PARTITION"
		;;
esac
echo "Unmounting boot partition..."
umount /boot/
