#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="mate-menus"
DESCRIPTION="Implementation of the freedesktop menu specification for MATE"
VERSION="1.18.0"

cd $SOURCE_DIR

URL="http://pub.mate-desktop.org/releases/1.18/mate-menus-1.18.0.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --with-gtk=3.0 &&
make "-j`nproc`"

makepkg "$NAME" "$VERSION" "1"
sudo tar xf $BINARY_DIR/$NAME-$VERSION-$(uname -m).tar.xz -C /

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
