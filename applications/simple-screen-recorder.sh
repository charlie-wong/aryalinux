#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:jack2
#REQ:qt5
#REQ:ffmpeg
#REQ:pulseaudio

NAME="simple-screen-recorder"
VERSION="0.3.8"
DESCRIPTION="SimpleScreenRecorder is a screen recorder for Linux. Despite the name, this program is actually quite complex. It's 'simple' in the sense that it's easier to use than ffmpeg/avconv or VLC :)"

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.05/simple-screen-recorder-0.3.8.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"

CXXFLAGS="-fPIC" ./configure --prefix=/usr --with-qt5 --with-jack --with-pulseaudio &&
make "-j`nproc`"

makepkg "$NAME" "$VERSION" "1"
sudo tar xf $BINARY_DIR/$NAME-$VERSION-$(uname -m).tar.xz -C /

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
