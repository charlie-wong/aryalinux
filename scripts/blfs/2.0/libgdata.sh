#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:liboauth
#DEP:libsoup
#DEP:json-glib
#DEP:gcr
#DEP:gnome-online-accounts
#DEP:gobject-introspection
#DEP:uhttpmock


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libgdata/0.16/libgdata-0.16.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgdata/0.16/libgdata-0.16.1.tar.xz


TARBALL=libgdata-0.16.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998815.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998815.sh
sudo ./1434987998815.sh
sudo rm -rf 1434987998815.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libgdata=>`date`" | sudo tee -a $INSTALLED_LIST