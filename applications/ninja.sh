#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=ninja
VERSION=1.7.2
DESCRIPTION="Ninja is a small build system with a focus on speed."
SOURCE_ONLY=n

#REQ:python2

URL="https://github.com/ninja-build/ninja/archive/v1.7.2.tar.gz"
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

cd $SOURCE_DIR

wget -nc $URL

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./configure.py --bootstrap
sudo cp ninja /usr/bin

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
