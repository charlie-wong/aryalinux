#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Qtwebkit is a Qt based web browserbr3ak engine.br3ak"
SECTION="x"
VERSION=5.8.0
NAME="qtwebkit5"

#REQ:icu
#REQ:libjpeg
#REQ:libpng
#REQ:libwebp
#REQ:libxslt
#REQ:qt5
#REQ:ruby
#REQ:sqlite
#REC:gst10-plugins-base


cd $SOURCE_DIR

URL=http://download.qt.io/community_releases/5.8/5.8.0-final/qtwebkit-opensource-src-5.8.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.8.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.8.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.8.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.8.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.8.0.tar.xz || wget -nc http://download.qt.io/community_releases/5.8/5.8.0-final/qtwebkit-opensource-src-5.8.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.8.0.tar.xz

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

SAVEPATH=$PATH             &&
export PATH=$PWD/bin:$PATH &&
mkdir -p build        &&
cd       build        &&
qmake ../WebKit.pro   &&
make                  &&
export PATH=$SAVEPATH &&
unset SAVEPATH



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find /opt/qt5/lib/pkgconfig -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find /opt/qt5/ -name qt_lib_bootstrap_private.pri \
   -exec sed -i -e "s:$PWD/qtbase://opt/qt5/lib/:g" {} \; &&
find /opt/qt5/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
