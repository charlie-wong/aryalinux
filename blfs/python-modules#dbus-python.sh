#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:dbus-python:1.2.4

#REQ:dbus-glib
#REQ:python2
#REQ:python3


cd $SOURCE_DIR

URL=http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.4.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-python-1.2.4.tar.gz || wget -nc http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-python-1.2.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-python-1.2.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/db/dbus-python-1.2.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-python-1.2.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

mkdir python2 &&
pushd python2 &&
PYTHON=/usr/bin/python     \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.4 &&
make &&
popd

mkdir python3 &&
pushd python3 &&
PYTHON=/usr/bin/python3    \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.4 &&
make &&
popd


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C python2 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C python3 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python-modules#dbus-python=>`date`" | sudo tee -a $INSTALLED_LIST
