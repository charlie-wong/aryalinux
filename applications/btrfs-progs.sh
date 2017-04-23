#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The btrfs-progs package containsbr3ak administration and debugging tools for the B-tree file systembr3ak (btrfs).br3ak"
SECTION="postlfs"
VERSION=4.10.2
NAME="btrfs-progs"

#REQ:lzo
#REC:asciidoc
#REC:xmlto
#OPT:lvm2


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v4.10.2.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.10.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.10.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.10.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.10.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.10.2.tar.xz || wget -nc https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v4.10.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.10.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i '1,100 s/\.gz//g' Documentation/Makefile.in &&
./configure --prefix=/usr \
            --bindir=/bin \
            --libdir=/lib &&
make "-j`nproc`" || make


mv tests/fuzz-tests/001-simple-check-unmounted/test.sh{,.broken}   &&
mv tests/fuzz-tests/003-multi-check-unmounted/test.sh{,.broken}    &&
mv tests/fuzz-tests/007-simple-super-recover/test.sh{,.broken}     &&
mv tests/fuzz-tests/009-simple-zero-log/test.sh{,.broken}          &&
mv tests/mkfs-tests/005-long-device-name-for-ssd/test.sh{,.broken} &&
mv tests/misc-tests/019-receive-clones-on-munted-subvol/test.sh{,.broken}


pushd tests
   ./fsck-tests.sh
   ./mkfs-tests.sh
   ./convert-tests.sh
   ./misc-tests.sh
   ./cli-tests.sh
   ./fuzz-tests.sh
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfv ../../lib/$(readlink /lib/libbtrfs.so) /usr/lib/libbtrfs.so &&
rm -v /lib/libbtrfs.{a,so}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
