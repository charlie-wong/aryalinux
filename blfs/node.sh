#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:node:6.9.1

cd $SOURCE_DIR

URL=https://nodejs.org/dist/v6.9.1/node-v6.9.1.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "node=>`date`" | sudo tee -a $INSTALLED_LIST


