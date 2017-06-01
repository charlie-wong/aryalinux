#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Re-alpine is the continuation ofbr3ak Alpine; a text-based email client developed by the University ofbr3ak Washington.br3ak"
SECTION="basicnet"
VERSION=2.03
NAME="re-alpine"

#REC:openssl
#OPT:openldap
#OPT:mitkrb
#OPT:aspell
#OPT:tcl
#OPT:linux-pam


cd $SOURCE_DIR

URL=http://sourceforge.net/projects/re-alpine/files/re-alpine-2.03.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://sourceforge.net/projects/re-alpine/files/re-alpine-2.03.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2

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

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --without-ldap      \
            --without-krb5      \
            --with-ssl-dir=/usr \
            --with-passfile=.pine-passfile &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
