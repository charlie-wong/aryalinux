#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:mongodb:3.4.0

#REQ:scons

cd $SOURCE_DIR

URL=https://fastdl.mongodb.org/src/mongodb-src-r3.4.0.tar.gz
wget -nc $URL
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/2016.11/mongodb-gcc6-parse_number_test-literal-comment-out.patch
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../mongodb-gcc6-parse_number_test-literal-comment-out.patch &&
scons core --disable-warnings-as-errors -j$(nproc) &&
sudo scons install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "mongodb=>`date`" | sudo tee -a $INSTALLED_LIST


