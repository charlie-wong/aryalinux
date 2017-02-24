#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="perl-modules#xml-namespacesupport"
VERSION="1.11"
DESCRIPTION="A simple generic namespace support class"
SECTION="perl-modules"

URL=http://search.cpan.org/CPAN/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.11.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

cd $SOURCE_DIR
wget -nc $URL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

perl Makefile.PL &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

register_installed "$NAME=>`date`" "$VERSION" "$INSTALLED_LIST"
