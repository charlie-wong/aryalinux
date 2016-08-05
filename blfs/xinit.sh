#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xinit:1.3.4

#REQ:x7lib
#REQ:twm
#REQ:xclock
#REQ:xterm


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/app/xinit-1.3.4.tar.bz2

wget -nc ftp://ftp.x.org/pub/individual/app/xinit-1.3.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc http://ftp.x.org/pub/individual/app/xinit-1.3.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

sed -e '/$serverargs $vtarg/ s/serverargs/: #&/' \
    -i startx.cpp


./configure $XORG_CONFIG \
            --with-xinitdir=/etc/X11/app-defaults &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ldconfig

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xinit=>`date`" | sudo tee -a $INSTALLED_LIST
