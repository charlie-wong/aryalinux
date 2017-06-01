#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libESMTP package contains thebr3ak libESMTP libraries which are usedbr3ak by some programs to manage email submission to a mail transportbr3ak layer.br3ak"
SECTION="general"
VERSION=1.0.6
NAME="libesmtp"

#OPT:openssl


cd $SOURCE_DIR

URL=http://www.stafford.uklinux.net/libesmtp/libesmtp-1.0.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/libesmtp/libesmtp-1.0.6.tar.bz2/bf3915e627fd8f35524a8fdfeed979c8/libesmtp-1.0.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://www.stafford.uklinux.net/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2

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
