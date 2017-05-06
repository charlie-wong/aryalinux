#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="arc-gtk-theme"
VERSION="20170302"
DESCRIPTION="Arc is a flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell which supports GTK 3 and GTK 2 based desktop environments like Gnome, Unity, Budgie, Pantheon, XFCE, Mate, etc"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR
URL="https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.05/arc-theme-20170302.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=$(unzip -l $TARBALL | grep "/" | rev | tr -s " " | cut -d " " -f1 | rev | cut -d/ -f1 | uniq)

tar -xf $TARBALL
cd $DIRECTORY

./autogen.sh --prefix=/usr &&
makepkg "$NAME" "$VERSION" "1"
sudo tar xf $BINARY_DIR/$NAME-$VERSION-$(uname -m).tar.xz -C /

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
