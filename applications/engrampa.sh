#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="engrampa"
DESCRIPTION="File archive utility for the Mate desktop environment."
VERSION="1.19.0"

cd $SOURCE_DIR

URL="http://pub.mate-desktop.org/releases/1.19/engrampa-1.19.0.tar.xz"
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
