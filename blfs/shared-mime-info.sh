#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:shared-mime-info:1.4

#REQ:glib2
#REQ:libxml2


cd $SOURCE_DIR

URL=http://freedesktop.org/~hadess/shared-mime-info-1.4.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/shared-mime-info/shared-mime-info-1.4.tar.xz || wget -nc http://freedesktop.org/~hadess/shared-mime-info-1.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/shared-mime-info/shared-mime-info-1.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/shared-mime-info/shared-mime-info-1.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/shared-mime-info/shared-mime-info-1.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/shared-mime-info/shared-mime-info-1.4.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "shared-mime-info=>`date`" | sudo tee -a $INSTALLED_LIST

