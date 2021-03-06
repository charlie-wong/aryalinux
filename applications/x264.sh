#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak x264 package provides a librarybr3ak for encoding video streams into the H.264/MPEG-4 AVC format.br3ak"
SECTION="multimedia"
VERSION=2245
NAME="x264"

#REC:yasm


cd $SOURCE_DIR

URL=http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20160827-2245-stable.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/x264/x264-snapshot-20160827-2245-stable.tar.bz2

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

./configure --prefix=/usr \
            --enable-shared \
            --disable-cli &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
