#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:atkmm:2.24.2

#REQ:atk
#REQ:glibmm


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/atkmm/2.24/atkmm-2.24.2.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/atkmm/2.24/atkmm-2.24.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/atkmm/2.24/atkmm-2.24.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/atkmm/atkmm-2.24.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/^libdocdir =/ s/$(book_name)/atkmm-2.24.2/' \
    -i doc/Makefile.in


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
echo "atkmm=>`date`" | sudo tee -a $INSTALLED_LIST

