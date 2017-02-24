#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="perl-modules#xml-sax-base"
VERSION="1.08"
DESCRIPTION="XML::SAX::Base is intended for use as a base class for SAX filter modules and XML parsers generating SAX events"
SECTION="perl-modules"

URL=http://search.cpan.org/CPAN/authors/id/G/GR/GRANTM/XML-SAX-Base-1.08.tar.gz
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
