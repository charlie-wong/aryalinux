#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kconfig
#DEP:kcrash
#DEP:kdbusaddons
#DEP:ki18n


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.7/kglobalaccel-5.7.0.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/frameworks/5.7/kglobalaccel-5.7.0.tar.xz


TARBALL=kglobalaccel-5.7.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DECM_MKSPECS_INSTALL_DIR=$KF5_PREFIX/share/qt5/mkspecs/modules \
      .. &&
make

cat > 1434987998804.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998804.sh
sudo ./1434987998804.sh
sudo rm -rf 1434987998804.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "kglobalaccel=>`date`" | sudo tee -a $INSTALLED_LIST