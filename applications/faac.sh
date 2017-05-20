#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak FAAC is an encoder for a lossybr3ak sound compression scheme specified in MPEG-2 Part 7 and MPEG-4 Partbr3ak 3 standards and known as Advanced Audio Coding (AAC). This encoderbr3ak is useful for producing files that can be played back on iPod.br3ak Moreover, iPod does not understand other sound compression schemesbr3ak in video files.br3ak"
SECTION="multimedia"
VERSION=1.28
NAME="faac"



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/faac/faac-1.28.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/8.0/faac-1.28-glibc_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/faac/faac-1.28-glibc_fixes-1.patch

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

patch -Np1 -i ../faac-1.28-glibc_fixes-1.patch &&
sed -i -e '/obj-type/d' -e '/Long Term/d' frontend/main.c &&
CFLAGS=-std=c99 CXXFLAGS=-std=c++98 \
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
