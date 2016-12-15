#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="clementine"
DESCRIPTION="Clementine is a multiplatform music player. It is inspired by Amarok 1.4, focusing on a fast and easy-to-use interface for searching and playing your music."
VERSION="1.3.1"

#REQ:audio-video-plugins
#REQ:protobuf
#REQ:libchromaprint
#REQ:libgpod
#REQ:libimobiledevice
#REQ:libmygpo-qt1
#REQ:libcrypto++
#REQ:libechonest
#REQ:libglew
#REQ:libsparsehash
#REQ:libmtp
#REQ:sqlite3
#REQ:liblastfm

cd $SOURCE_DIR

URL="https://github.com/clementine-player/Clementine/archive/1.3.1.tar.gz"

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
