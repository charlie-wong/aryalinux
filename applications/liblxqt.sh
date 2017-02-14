#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The liblxqt is the core utilitybr3ak library for all LXQt components.br3ak"
SECTION="lxqt"
VERSION=0.11.1
NAME="liblxqt"

#REQ:libqtxdg
#REQ:lxqt-kwindowsystem
#OPT:kframeworks5
#OPT:git
#REQ:lxqt-l10n


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/lxqt/0.11.1/liblxqt-0.11.1.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/liblxqt/liblxqt-0.11.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/liblxqt/liblxqt-0.11.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/liblxqt/liblxqt-0.11.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/liblxqt/liblxqt-0.11.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/liblxqt/liblxqt-0.11.1.tar.xz || wget -nc http://downloads.lxqt.org/lxqt/0.11.1/liblxqt-0.11.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/liblxqt/liblxqt-0.11.1.tar.xz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DPULL_TRANSLATIONS=no              \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      ..                                  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
