#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Slim is a very lightweight display manager"
VERSION=SVN
NAME="slim-display-manager"

cd $SOURCE_DIR

URL="https://sourceforge.net/projects/aryalinux-bin/files/releases/2017/sources/slim-display-manager.tar.xz"
wget -nc $URL

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

cmake . -DUSE_PAM=yes
make
sudo make install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
