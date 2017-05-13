#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="openconnect"
VERSION="7.08"


URL=https://fossies.org/linux/privat/openconnect-7.08.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"

sudo mkdir -pv /var/cache/alps/binaries
sudo chmod a+rw /var/cache/alps/binaries
INSTALL_DIR=/var/cache/alps/binaries/$NAME-$VERSION-$(uname -m)
make DESTDIR=${INSTALL_DIR} install

pushd ${INSTALL_DIR}
tar -cJvf ${INSTALL_DIR}/../$NAME-$VERSION-$(uname -m).tar.xz *
popd
rm -r ${INSTALL_DIR}

sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
