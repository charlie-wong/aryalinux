#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#REQ:jack2
#REQ:qt5
#REQ:ffmpeg

cd $SOURCE_DIR

URL=https://github.com/MaartenBaert/ssr/archive/master.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export QT5PREFIX="/opt/QT5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/QT5/lib/pkgconfig"
./configure --prefix=/usr --enable-qt       &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "simple-screen-recorder=>`date`" | sudo tee -a $INSTALLED_LIST

