#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:thunar

NAME=thunar-archive-plugin
VERSION=0.3.1
DESCRIPTION="The Thunar Archive Plugin allows you to create and extract archive files using the file context menus in the Thunar file manager."
URL=http://archive.ubuntu.com/ubuntu/pool/universe/t/thunar-archive-plugin/thunar-archive-plugin_0.3.1.orig.tar.bz2

cd $SOURCE_DIR
wget $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./autogen.sh --prefix=/usr &&
./configure --prefix=/usr &&
make "-j$(nproc)" || make
sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

