#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GNOME Themes Standard packagebr3ak contains various components of the default GNOME theme.br3ak"
SECTION="x"
VERSION=3.22.2
NAME="gnome-themes-standard"

#REQ:gtk2
#REQ:gtk3
#REQ:librsvg


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.2.tar.xz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
