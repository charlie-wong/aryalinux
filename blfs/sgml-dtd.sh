#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:docbook:4.5

#REQ:sgml-common
#REQ:unzip


cd $SOURCE_DIR

URL=http://www.docbook.org/sgml/4.5/docbook-4.5.zip

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook/docbook-4.5.zip || wget -nc http://www.docbook.org/sgml/4.5/docbook-4.5.zip

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=''
unzip_dirname $TARBALL DIRECTORY

unzip_file $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -e '/ISO 8879/d' \
       -e '/gml/d' docbook.cat



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d /usr/share/sgml/docbook/sgml-dtd-4.5 &&
chown -R root:root . &&
install -v docbook.cat /usr/share/sgml/docbook/sgml-dtd-4.5/catalog &&
cp -v -af *.dtd *.mod *.dcl /usr/share/sgml/docbook/sgml-dtd-4.5 &&
install-catalog --add /etc/sgml/sgml-docbook-dtd-4.5.cat \
    /usr/share/sgml/docbook/sgml-dtd-4.5/catalog &&
install-catalog --add /etc/sgml/sgml-docbook-dtd-4.5.cat \
    /etc/sgml/sgml-docbook.cat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /usr/share/sgml/docbook/sgml-dtd-4.5/catalog << "EOF"
 -- Begin Single Major Version catalog changes --
PUBLIC "-//OASIS//DTD DocBook V4.4//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.3//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.2//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.1//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.0//EN" "docbook.dtd"
 -- End Single Major Version catalog changes --
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "sgml-dtd=>`date`" | sudo tee -a $INSTALLED_LIST
