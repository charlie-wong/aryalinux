#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The pcmanfm-qt is a file managerbr3ak and desktop icon manager (Qt portbr3ak of pcmanfm and libfm).br3ak"
SECTION="lxqt"
VERSION=0.11.2
NAME="pcmanfm-qt"

#REQ:liblxqt
#REQ:libfm-qt
#REQ:lxmenu-data
#REC:oxygen-icons5
#OPT:git
#OPT:lxqt-l10n


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/pcmanfm-qt/0.11.2/pcmanfm-qt-0.11.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://downloads.lxqt.org/pcmanfm-qt/0.11.2/pcmanfm-qt-0.11.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.2.tar.xz

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

export QT5DIR=/opt/qt5
export LXQT_PREFIX=/opt/lxqt
pathappend /opt/lxqt/bin           PATH
pathappend /opt/lxqt/share/man/    MANPATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/plugins   QT_PLUGIN_PATH
pathappend $QT5DIR/plugins         QT_PLUGIN_PATH
pathappend /opt/lxqt/lib LD_LIBRARY_PATH
pathappend /opt/qt5/lib LD_LIBRARY_PATH
pathappend /opt/qt5/lib/pkgconfig PKG_CONFIG_PATH
pathappend /opt/lxqt/lib/pkgconfig PKG_CONFIG_PATH

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DPULL_TRANSLATIONS=no              \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
