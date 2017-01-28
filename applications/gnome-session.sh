#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GNOME Session package containsbr3ak the GNOME session manager.br3ak"
SECTION="gnome"
VERSION=3.22.2
NAME="gnome-session"

#REQ:dbus-glib
#REQ:gnome-desktop
#REQ:json-glib
#REQ:mesa
#REQ:upower
#REQ:systemd
#OPT:GConf
#OPT:xmlto
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.22/gnome-session-3.22.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnome-session/gnome-session-3.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-session/gnome-session-3.22.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-session/3.22/gnome-session-3.22.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.22/gnome-session-3.22.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-session/gnome-session-3.22.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-session/gnome-session-3.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-session/gnome-session-3.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-session/gnome-session-3.22.2.tar.xz

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

mv gnome-session/gnome-session.{in,bak} &&
cat > gnome-session/gnome-session.in << "EOF" &&
#!/bin/sh
# Source /etc/profile if running in Xwayland
if [ "${XDG_SESSION_TYPE}" == "wayland" ]; then
 . /etc/profile
fi
EOF
sed 's@#!/bin/sh@@' gnome-session/gnome-session.bak >> \
    gnome-session/gnome-session.in


./configure --prefix=/usr --docdir=/usr/share/doc/gnome-session-3.22.2 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
