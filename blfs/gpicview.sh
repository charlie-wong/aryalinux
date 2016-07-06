#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gpicview:0.2.5

#REQ:gtk2


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lxde/gpicview-0.2.5.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gpicview/gpicview-0.2.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gpicview/gpicview-0.2.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gpicview/gpicview-0.2.5.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/gpicview-0.2.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpicview/gpicview-0.2.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpicview/gpicview-0.2.5.tar.xz

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
echo "gpicview=>`date`" | sudo tee -a $INSTALLED_LIST
