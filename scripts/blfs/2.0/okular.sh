#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kdelibs
#DEP:freetype2
#DEP:kactivities
#DEP:poppler
#DEP:qimageblitz


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/4.14.3/src/okular-4.14.3.tar.xz


TARBALL=okular-4.14.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -Wno-dev .. &&
make

cat > 1434987998800.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998800.sh
sudo ./1434987998800.sh
sudo rm -rf 1434987998800.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "okular=>`date`" | sudo tee -a $INSTALLED_LIST