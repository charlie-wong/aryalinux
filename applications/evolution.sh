#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Evolution package contains anbr3ak integrated mail, calendar and address book suite designed for thebr3ak GNOME environment.br3ak"
SECTION="gnome"
VERSION=3.22.6
NAME="evolution"

#REQ:adwaita-icon-theme
#REQ:evolution-data-server
#REQ:gnome-autoar
#REQ:gtkhtml
#REQ:itstool
#REQ:libgdata
#REQ:shared-mime-info
#REQ:webkitgtk
#REC:bogofilter
#REC:enchant
#REC:gnome-desktop
#REC:highlight
#REC:libcanberra
#REC:libgweather
#REC:libnotify
#REC:seahorse
#OPT:clutter-gtk
#OPT:geoclue2
#OPT:geocode-glib
#OPT:libchamplain
#OPT:gtk-doc
#OPT:openldap


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/evolution/3.22/evolution-3.22.6.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/evolution/evolution-3.22.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/evolution/evolution-3.22.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/evolution/evolution-3.22.6.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/evolution/evolution-3.22.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/evolution/evolution-3.22.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evolution/3.22/evolution-3.22.6.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/evolution/3.22/evolution-3.22.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/evolution/evolution-3.22.6.tar.xz

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

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --disable-gtkspell    \
            --disable-pst-import  \
            --disable-libcryptui  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
