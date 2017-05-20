#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Inkscape is a what you see is whatbr3ak you get Scalable Vector Graphics editor. It is useful for creating,br3ak viewing and changing SVG images.br3ak"
SECTION="xsoft"
VERSION=0.92.0
NAME="inkscape"

#REQ:boost
#REQ:gc
#REQ:gsl
#REQ:gtkmm2
#REQ:gtkmm3
#REQ:libxslt
#REQ:popt
#REC:imagemagick6
#REC:lcms2
#REC:lcms
#OPT:aspell
#OPT:dbus
#OPT:doxygen
#OPT:poppler
#OPT:python-modules#lxml


cd $SOURCE_DIR

URL=https://launchpad.net/inkscape/0.92.x/0.92/+download/inkscape-0.92.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/inkscape/inkscape-0.92.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/inkscape/inkscape-0.92.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/inkscape/inkscape-0.92.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/inkscape/inkscape-0.92.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/inkscape/inkscape-0.92.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/inkscape/inkscape-0.92.0.tar.bz2 || wget -nc https://launchpad.net/inkscape/0.92.x/0.92/+download/inkscape-0.92.0.tar.bz2

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

./autogen.sh &&
IMAGEMAGICK_CFLAGS=-I/usr/include/ImageMagick-6 \
IMAGEMAGICK_LIBS="-lMagickCore-6.Q16HDRI -lMagick++-6.Q16HDRI -lMagickWand-6.Q16HDRI" \
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
