#!/bin/bash

set -e
set +h

VERSION=2017

pushd ~/sources

wget -nc http://pkgs.fedoraproject.org/lookaside/pkgs/dosfstools/dosfstools-3.0.26.tar.xz/45012f5f56f2aae3afcd62120b9e5a08/dosfstools-3.0.26.tar.xz
wget -nc http://ftp.gnu.org/gnu/which/which-2.21.tar.gz
wget -nc http://ftp.de.debian.org/debian/pool/main/o/os-prober/os-prober_1.74.tar.xz
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/efivar/efivar-30.tar.bz2/143f055904fceaad6ed39f8e849ba079/efivar-30.tar.bz2
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/efibootmgr/efibootmgr-14.tar.bz2/f74e87963c2c5cb1bf6d588675dbd9b4/efibootmgr-14.tar.bz2
wget -nc http://downloads.sourceforge.net/freetype/freetype-2.6.3.tar.bz2
wget -nc http://unifoundry.com/pub/unifont-7.0.05/font-builds/unifont-7.0.05.pcf.gz
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/pciutils/pciutils-3.4.1.tar.gz/acc91d632dbc98f624a8e57b4e478160/pciutils-3.4.1.tar.gz
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/popt/popt-1.16.tar.gz/3743beefa3dd6247a73f8f7a32c14c33/popt-1.16.tar.gz
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/linux-firmware/linux-firmware-20160321.tar.gz/46a7ec26850851c9da93ba84dd14fc71/linux-firmware-20160321.tar.gz
wget -nc http://ftp.gnu.org/pub/gnu/cpio/cpio-2.12.tar.bz2
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/redhat-lsb/lsb-release-1.4.tar.gz/30537ef5a01e0ca94b7b8eb6a36bb1e4/lsb-release-1.4.tar.gz
wget -nc https://busybox.net/downloads/fixes-1.20.2/busybox-1.20.2-sys-resource.patch
wget -nc https://busybox.net/downloads/busybox-1.20.2.tar.bz2
wget -nc https://ftp.gnu.org/gnu/nettle/nettle-3.1.1.tar.gz
wget -nc http://ftp.gnu.org/gnu/libtasn1/libtasn1-4.5.tar.gz
wget -nc http://p11-glue.freedesktop.org/releases/p11-kit-0.23.1.tar.gz
wget -nc ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.3.tar.xz
wget -nc http://ftp.gnu.org/gnu/wget/wget-1.16.3.tar.xz
wget -nc http://www.sudo.ws/dist/sudo-1.8.16.tar.gz
wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
wget -nc https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tar.xz
wget -nc http://anduin.linuxfromscratch.org/sources/other/certdata.txt
wget -nc http://www.openssl.org/source/openssl-1.0.1i.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/7.6-systemd/openssl-1.0.1i-fix_parallel_build-1.patch
wget -nc http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.06.tar.xz
wget -nc http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.1.tar.gz
wget -nc https://github.com/dracutdevs/dracut/archive/master.zip
unzip master.zip
tar -cJvf dracut-master.tar.xz dracut-master
rm -r dracut-master
rm -r master.zip
wget -nc ftp://sources.redhat.com/pub/lvm2/releases/LVM2.2.02.155.tgz
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/$VERSION/aufs-4.9.tar.gz
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/$VERSION/aufs4-base.patch
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/$VERSION/aufs4-kbuild.patch
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/$VERSION/aufs4-loopback.patch
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/$VERSION/aufs4-mmap.patch
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/$VERSION/aufs4-standalone.patch
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/$VERSION/0.21-nvme_ioctl.h.patch
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.02/efivar-30-z-muldefs.patch

pushd ~/aryalinux/applications
git checkout $VERSION.02
git pull
tar -czf alps-scripts-$VERSION.tar.gz *.sh
popd

mv -f ~/aryalinux/applications/alps-scripts-$VERSION.tar.gz .

wget -nc https://sourceforge.net/projects/cdrtools/files/cdrtools-3.01.tar.bz2
wget -nc https://launchpad.net/ubuntu/+archive/primary/+files/cdrkit_1.1.11.orig.tar.gz
wget -nc http://www.cmake.org/files/v3.5/cmake-3.5.0.tar.gz
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/squashfs-tools/squashfs4.3.tar.gz/370d0470f3c823bf408a3b7a1f145746/squashfs4.3.tar.gz
wget -nc aryalinux.org/releases/2016.08/bootx64.efi
wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz

set +e

wget https://raw.githubusercontent.com/FluidIdeas/alps/master/var/lib/alps/functions -O functions
wget https://raw.githubusercontent.com/FluidIdeas/alps/master/usr/bin/alps -O alps
wget https://raw.githubusercontent.com/FluidIdeas/alps/master/etc/alps/alps.conf -O alps.conf
wget https://raw.githubusercontent.com/FluidIdeas/package-builder/master/makepkg.sh -O makepkg.sh

set -e

popd
