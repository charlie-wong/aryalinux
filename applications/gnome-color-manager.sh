#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak GNOME Color Manager is a sessionbr3ak framework for the GNOME desktopbr3ak environment that makes it easy to manage, install and generatebr3ak color profiles.br3ak"
SECTION="gnome"
VERSION=3.22.2
NAME="gnome-color-manager"

#REQ:colord-gtk
#REQ:colord1
#REQ:gtk3
#REQ:itstool
#REQ:lcms2
#REQ:libcanberra
#REQ:libexif
#REC:appstream-glib
#REC:exiv2
#REC:vte
#OPT:docbook-utils


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.22/gnome-color-manager-3.22.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.22/gnome-color-manager-3.22.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.22/gnome-color-manager-3.22.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.2.tar.xz

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

./configure --prefix=/usr --disable-packagekit &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
