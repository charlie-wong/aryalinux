#!/bin/bash

set -e
set +h

. ./build-properties

isoname="$1"

echo "Creating temporary directories..."
mkdir -pv /tmp/iso
mkdir -pv /tmp/rootsfs

echo "Mounting..."
mount ~/backup/aryalinux-$isoname*.iso /tmp/iso
mount /tmp/iso/aryalinux/root.sfs /tmp/rootsfs

./umountal.sh

echo "Formatting..."
yes | mkfs.ext4 $ROOT_PART

new_id=$(blkid $ROOT_PART | cut -d '"' -f2)
mount $ROOT_PART $LFS

echo "Copying files..."
cp -prf /tmp/rootsfs/* $LFS
rm -r $LFS/lost*

echo "Copying sources..."
cp -r ~/sources $LFS/
cp -r * $LFS/sources/
cp -r * $LFS/sources/

echo "Extracting toolchain..."
tar xf ~/backup/toolchain*.tar.xz -C /
cp ~/backup/mnt/lfs/etc/fstab $LFS/etc/fstab

old_id=$(grep UUID /mnt/lfs/etc/fstab | cut -d ' ' -f1 | sed 's/UUID=//')
echo "Fixing UUIDs in /etc/fstab and grub.cfg"
echo "Replacing $old_id with $new_id..."
sed -i "s/$old_id/$new_id/g" $LFS/etc/fstab
sed -i "s/$old_id/$new_id/g" $LFS/boot/grub/grub.cfg

umount /tmp/rootsfs
umount /tmp/iso
umount $LFS
