#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:alsa-lib:1.1.1

#OPT:doxygen
#OPT:python2


cd $SOURCE_DIR

URL=http://alsa.cybermirror.org/lib/alsa-lib-1.1.1.tar.bz2

wget -nc ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-lib/alsa-lib-1.1.1.tar.bz2 || wget -nc http://alsa.cybermirror.org/lib/alsa-lib-1.1.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "alsa-lib=>`date`" | sudo tee -a $INSTALLED_LIST

