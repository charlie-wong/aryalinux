#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="mongodb-src-r"
DESCRIPTION="MongoDB is an open-source document database and leading NoSQL database. MongoDB is written in C++."
VERSION="3.2.11"

#REQ:scons

cd $SOURCE_DIR

URL=https://fastdl.mongodb.org/src/mongodb-src-r3.2.11.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sudo scons all --disable-warnings-as-errors --prefix=/usr install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
