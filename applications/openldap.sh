#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The OpenLDAP package provides anbr3ak open source implementation of the Lightweight Directory Accessbr3ak Protocol.br3ak"
SECTION="server"
VERSION=2.4.44
NAME="openldap"

#REC:cyrus-sasl
#REC:openssl
#OPT:icu
#OPT:pth
#OPT:unixodbc
#OPT:mariadb
#OPT:postgresql
#OPT:db


cd $SOURCE_DIR

URL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.44.tgz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.44.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openldap/openldap-2.4.44.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openldap-2.4.44-consolidated-2.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/openldap/openldap-2.4.44-consolidated-2.patch

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

patch -Np1 -i ../openldap-2.4.44-consolidated-2.patch &&
autoconf &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dynamic  \
            --disable-debug   \
            --disable-slapd &&
make depend &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
tar xf $TARBALL
cd $DIRECTORY



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
