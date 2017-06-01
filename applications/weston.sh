#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Weston is the referencebr3ak implementation of a Waylandbr3ak compositor, and a useful compositor in its own right. It hasbr3ak various backends that lets it run on Linux kernel modesetting andbr3ak evdev input as well as under X11. Weston also ships with a few example clients,br3ak from simple clients that demonstrate certain aspects of thebr3ak protocol to more complete clients and a simplistic toolkit.br3ak"
SECTION="general"
VERSION=1.12.0
NAME="weston"

#REQ:cairo
#REQ:x7driver
#REQ:libjpeg
#REQ:libxkbcommon
#REQ:mesa
#REQ:mtdev
#REQ:wayland
#REQ:wayland-protocols
#REC:glu
#REC:linux-pam
#REC:pango
#REC:systemd
#REC:x7lib
#REC:xorg-server
#OPT:colord
#OPT:doxygen
#OPT:lcms2
#OPT:libpng
#OPT:x7driver
#OPT:libwebp


cd $SOURCE_DIR

URL=http://wayland.freedesktop.org/releases/weston-1.12.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc http://wayland.freedesktop.org/releases/weston-1.12.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/weston/weston-1.12.0.tar.xz

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

./configure --prefix=/usr --enable-demo-clients-install &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


weston


weston-launch


weston-launch -- --backend=fbdev-backend.so




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
