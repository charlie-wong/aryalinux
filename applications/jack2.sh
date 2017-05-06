#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="jack"
VERSION="1.9.10"

cd $SOURCE_DIR

URL=https://github.com/jackaudio/jack2/archive/v1.9.10.tar.gz
wget -c $URL -O $NAME-$VERSION.tar.gz
TARBALL="$name-$version.tar.gz"
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

tar -xf $TARBALL

cd $DIRECTORY

CXXFLAGS="-Wno-narrowing" ./waf configure --prefix=/usr &&
./waf build
sudo ./waf install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
