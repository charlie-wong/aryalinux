#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GtkSourceView package containsbr3ak libraries used for extending the GTK+ text functions to include syntaxbr3ak highlighting.br3ak"
SECTION="x"
VERSION=3.22.2
NAME="gtksourceview"

#REQ:gtk3
#REC:gobject-introspection
#OPT:vala
#OPT:valgrind
#OPT:gtk-doc
#OPT:itstool
#OPT:fop


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.22/gtksourceview-3.22.2.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.22/gtksourceview-3.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.22.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtksourceview/gtksourceview-3.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.22.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.22.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.22/gtksourceview-3.22.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gtksourceview/gtksourceview-3.22.2.tar.xz

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
