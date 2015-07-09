#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter-gst2
#DEP:clutter-gtk
#DEP:gnome-desktop
#DEP:gnome-video-effects
#DEP:gst10-plugins-bad
#DEP:gst10-plugins-good
#DEP:itstool
#DEP:libcanberra
#DEP:systemd
#DEP:appstream-glib
#DEP:gobject-introspection
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/cheese/3.14/cheese-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cheese/3.14/cheese-3.14.2.tar.xz


TARBALL=cheese-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998819.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998819.sh
sudo ./1434987998819.sh
sudo rm -rf 1434987998819.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cheese=>`date`" | sudo tee -a $INSTALLED_LIST