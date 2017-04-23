#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak FUSE (Filesystem in Userspace) isbr3ak a simple interface for userspace programs to export a virtualbr3ak filesystem to the Linux kernel. Fuse also aims to provide a secure method forbr3ak non privileged users to create and mount their own filesystembr3ak implementations.br3ak"
SECTION="postlfs"
VERSION=2.9.7
NAME="fuse2"

#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/libfuse/libfuse/releases/download/fuse-2.9.7/fuse-2.9.7.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc https://github.com/libfuse/libfuse/releases/download/fuse-2.9.7/fuse-2.9.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz

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

./configure --prefix=/usr    \
            --disable-static \
            --exec-prefix=/  &&
make &&
make DESTDIR=$PWD/Dest install



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v Dest/lib/*.so.*             /lib                    &&
ln -sv ../../lib/libfuse.so.2     /usr/lib/libfuse.so     &&
ln -sv ../../lib/libulockmgr.so.1 /usr/lib/libulockmgr.so &&
cp -v Dest/lib/pkgconfig/* /usr/lib/pkgconfig             && 
                                                         
cp -v Dest/bin/*           /bin                           &&
cp -v Dest/sbin/mount.fuse /sbin                          &&                                                         
install -vdm755                 /usr/include/fuse         &&
cp -v Dest/usr/include/*.h      /usr/include              &&
cp -v Dest/usr/include/fuse/*.h /usr/include/fuse/        &&
cp -v Dest/usr/share/man/man1/* /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
