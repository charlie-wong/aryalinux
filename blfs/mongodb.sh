#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:mongodb:3.4.0

#REQ:scons

cd $SOURCE_DIR

URL=https://fastdl.mongodb.org/src/mongodb-src-r3.4.0.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

scons all --disable-warnings-as-errors -j$(nproc)
sudo scons install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "mongodb=>`date`" | sudo tee -a $INSTALLED_LIST


