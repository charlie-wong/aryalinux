#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:cpio:2.12

#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://ftp.gnu.org/pub/gnu/cpio/cpio-2.12.tar.bz2

wget -nc http://ftp.gnu.org/pub/gnu/cpio/cpio-2.12.tar.bz2 || wget -nc ftp://ftp.gnu.org/pub/gnu/cpio/cpio-2.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cpio/cpio-2.12.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi


make -C doc pdf &&
make -C doc ps



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/cpio.{html,txt} \
                    /usr/share/doc/cpio-2.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 doc/cpio.{pdf,ps,dvi} \
                 /usr/share/doc/cpio-2.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "cpio=>`date`" | sudo tee -a $INSTALLED_LIST
