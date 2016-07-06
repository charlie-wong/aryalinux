#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-session:3.16.0

#REQ:dbus-glib
#REQ:gnome-desktop
#REQ:json-glib
#REQ:mesa
#REQ:systemd
#OPT:GConf
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.16/gnome-session-3.16.0.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-session/gnome-session-3.16.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.16/gnome-session-3.16.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-session/gnome-session-3.16.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-session/gnome-session-3.16.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-session/3.16/gnome-session-3.16.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-session/gnome-session-3.16.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-session/gnome-session-3.16.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --docdir=/usr/share/doc/gnome-session-3.16.0 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnome-session=>`date`" | sudo tee -a $INSTALLED_LIST

