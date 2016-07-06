#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:imlib2:1.4.9

#REQ:x7lib
#OPT:libpng
#OPT:libjpeg
#OPT:libtiff
#OPT:giflib


cd $SOURCE_DIR

URL=http://sourceforge.net/projects/enlightenment/files/imlib2-src/1.4.9/imlib2-1.4.9.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/imlib2/imlib2-1.4.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/imlib2/imlib2-1.4.9.tar.bz2 || wget -nc http://sourceforge.net/projects/enlightenment/files/imlib2-src/1.4.9/imlib2-1.4.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/imlib2/imlib2-1.4.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/imlib2/imlib2-1.4.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/imlib2/imlib2-1.4.9.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/imlib2-1.4.9 &&
install -v -m644    doc/{*.gif,index.html} \
                    /usr/share/doc/imlib2-1.4.9

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "imlib2=>`date`" | sudo tee -a $INSTALLED_LIST
