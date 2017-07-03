#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="galculator"
DESCRIPTION="A simple gtk based calculator application"
VERSION=2.1.3

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/galculator/files/galculator/2.1.3/galculator-2.1.3.tar.bz2
wget -nc $URL
TARBALL=galculator-2.1.3.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
