#!/bin/bash

set -e
set +h

. ./build-properties

if [ "x$1" == "x" ]; then echo "Stage not mentioned. Aborting..." && exit 1; fi

./umountal.sh

LFS=/mnt/lfs
yes | mkfs.ext4 $ROOT_PART
mount $ROOT_PART $LFS

mkdir -pv $LFS/sources
mkdir -pv $LFS/tools

ln -svf $LFS/sources /
ln -svf $LFS/tools /

new_id=$(blkid $ROOT_PART | cut -d '"' -f2)
echo "Root partition UUID : $new_id"

echo "Untarring system backup..."
if [ "x$1" == "xbase" ]; then tar xf ~/backup/aryalinux-*-base-system-$(uname -m)*tar.gz -C /; fi
if [ "x$1" == "xxfce" ]; then tar xf ~/backup/aryalinux-*-base-system-with-xfce*tar.gz -C /; fi
if [ "x$1" == "xxserver" ]; then tar xf ~/backup/aryalinux-*-base-system-with-xserver*tar.gz -C /; fi
if [ "x$1" == "xmate" ]; then tar xf ~/backup/aryalinux-*-base-system-with-mate*tar.gz -C /; fi
if [ "x$1" == "xkde" ]; then tar xf ~/backup/aryalinux-*-base-system-with-kde*tar.gz -C /; fi
if [ "x$1" == "xgnome" ]; then tar xf ~/backup/aryalinux-*-base-system-with-gnome*tar.gz -C /; fi

echo "Untarring toolchain..."
tar xf ~/backup/toolchain* -C /

echo "Copying /sources..."
cp -r ~/sources $LFS
echo "Copying buildscripts..."
cp -r * $LFS/sources/

echo "Copying application source tarballs..."
mkdir -pv $LFS/var/cache/alps/sources
if [ -d ~/sources-apps ]; then
pushd ~/sources-apps
for f in *; do
if [ -f $f ]; then
	cp $f $LFS/var/cache/alps/sources/
fi
done
# cp -r ~/sources-apps/{app,font,lib,proto} $LFS/var/cache/alps/sources/
if [ -d ~/sources-apps/portingAids ]; then
	cp -r ~/sources-apps/portingAids $LFS/var/cache/alps/sources/
fi
popd
fi
chmod -R a+rw $LFS/var/cache/alps/sources

echo "Copying backup tarballs..."
if [ "x$1" == "xbase" ]; then cp ~/backup/aryalinux-*base-system-$(uname -m)*tar.gz /sources/; fi
echo 6 > /sources/currentstage
if [ "x$1" == "xxserver" ]; then cp ~/backup/aryalinux-*base-system-with-xserver-*tar.gz /sources/; fi
echo 7 > /sources/currentstage
if [ "x$1" == "xxfce" ]; then cp ~/backup/aryalinux-*base-system-with-xfce*tar.gz /sources/; fi
echo 7 > /sources/currentstage
if [ "x$1" == "xmate" ]; then cp ~/backup/aryalinux-*base-system-with-mate*tar.gz /sources/; fi
echo 7 > /sources/currentstage
if [ "x$1" == "xkde" ]; then cp ~/backup/aryalinux-*base-system-with-kde*tar.gz /sources/; fi
echo 7 > /sources/currentstage
if [ "x$1" == "xgnome" ]; then cp ~/backup/aryalinux-*base-system-with-gnome*tar.gz /sources/; fi
cp ~/backup/toolchain* /sources/

old_id=$(grep UUID /mnt/lfs/etc/fstab | cut -d ' ' -f1 | sed 's/UUID=//')

echo "Fixing UUIDs in /etc/fstab and grub.cfg"
echo "Replacing $old_id with $new_id..."
sed -i "s/$old_id/$new_id/g" $LFS/etc/fstab
sed -i "s/$old_id/$new_id/g" $LFS/boot/grub/grub.cfg

echo "Copying build-log..."
cp -v ~/backup/build-log /sources/

cat > /tmp/responses <<EOF
2
$ROOT_PART
EOF

cat /tmp/responses | ./build-arya
