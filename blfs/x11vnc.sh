#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/libvncserver/files/x11vnc/0.9.13/x11vnc-0.9.13.tar.gz/download
wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar -tf $TARBALL | sed -e 's@/.*@@' | uniq)

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "x11vnc=>`date`" | sudo tee -a $INSTALLED_LIST


