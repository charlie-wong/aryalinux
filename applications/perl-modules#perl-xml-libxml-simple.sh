#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#perl-xml-sax
#REQ:perl-modules#perl-xml-libxml
#REQ:perl-modules#file-slurp-tiny

SOURCE_ONLY=y
URL="http://cpan.org/authors/id/M/MA/MARKOV/XML-LibXML-Simple-0.97.tar.gz"
VERSION=0.97
NAME="perl-modules#perl-xml-libxml-simple"

cd $SOURCE_DIR
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

if [ -f Build.PL ]
then
perl Build.PL &&
./Build &&
sudo ./Build install
fi

if [ -f Makefile.PL ]
then
perl Makefile.PL &&
make &&
sudo make install
fi
cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME=>`date`" "$VERSION" "$INSTALLED_LIST"
