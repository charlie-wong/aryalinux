#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak FUSE (Filesystem in Userspace) isbr3ak a simple interface for userspace programs to export a virtualbr3ak filesystem to the Linux kernel. Fuse also aims to provide a secure method forbr3ak non privileged users to create and mount their own filesystembr3ak implementations.br3ak"
SECTION="postlfs"
VERSION=3.0.1
NAME="fuse"

#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/libfuse/libfuse/releases/download/fuse-3.0.1/fuse-3.0.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/libfuse/libfuse/releases/download/fuse-3.0.1/fuse-3.0.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fuse/fuse-3.0.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fuse/fuse-3.0.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fuse/fuse-3.0.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fuse/fuse-3.0.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fuse/fuse-3.0.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fuse/fuse-3.0.1.tar.gz

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
            --exec-prefix=/  \
            --with-pkgconfigdir=/usr/lib/pkgconfig \
            INIT_D_PATH=/tmp/init.d &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                         &&
rm -v /lib/libfuse3.{so,la}                          &&
ln -sfv ../../lib/libfuse3.so.3 /usr/lib/libfuse3.so &&
rm -rf  /tmp/init.d &&
install -v -m755 -d /usr/share/doc/fuse-3.0.1 &&
install -v -m644    doc/{README.NFS,kernel.txt} \
                    /usr/share/doc/fuse-3.0.1 &&
cp -Rv doc/html /usr/share/doc/fuse-3.0.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/fuse.conf << "EOF"
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#
#mount_max = 1000
# Allow non-root users to specify the 'allow_other' or 'allow_root'
# mount options.
#
#user_allow_other
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
