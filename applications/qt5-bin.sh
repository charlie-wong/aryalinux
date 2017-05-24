#!/bin/bash

set -e
set +h

NAME=qt5
VERSION=5.8.0
DESCRIPTION="Qt5 is a cross-platform application framework that is widely used for developing application software with a graphical user interface (GUI) (in 
which cases Qt5 is classified as a widget toolkit), and also used for developing non-GUI programs such as command-line tools and consoles for servers. One of 
the major users of Qt is KDE Frameworks 5 (KF5)."

. /etc/alps/alps.conf
. /var/lib/alps/functions

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.06/bin/qt5.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

cd $SOURCE_DIR

wget -nc $URL
sudo tar xf $TARBALL -C /

register_installed "qt5" "$VERSION" "$INSTALLED_LIST"
