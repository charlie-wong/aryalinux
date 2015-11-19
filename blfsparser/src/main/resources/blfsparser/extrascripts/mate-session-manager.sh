#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL="http://pub.mate-desktop.org/releases/1.12/mate-session-manager-1.12.0.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "mate-session-manager=>`date`" | sudo tee -a $INSTALLED_LIST
