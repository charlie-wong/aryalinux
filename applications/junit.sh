#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The JUnit package contains abr3ak simple, open source framework to write and run repeatable tests. Itbr3ak is an instance of the xUnit architecture for unit testingbr3ak frameworks. JUnit features include assertions for testing expectedbr3ak results, test fixtures for sharing common test data, and testbr3ak runners for running tests.br3ak"
SECTION="general"
VERSION=4_4.11
NAME="junit"

#REQ:apache-ant
#REQ:unzip


cd $SOURCE_DIR

URL=https://launchpad.net/debian/+archive/primary/+files/junit4_4.11.orig.tar.gz

if [ ! -z $URL ]
then
wget -nc https://launchpad.net/debian/+archive/primary/+files/junit4_4.11.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/junit/junit4_4.11.orig.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i '\@/docs/@a<arg value="-Xdoclint:none"/>' build.xml


cp -v ../hamcrest-core-1.3{,-sources}.jar lib/ &&
ant populate-dist



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/{doc,java}/junit-4.11 &&
chown -R root:root .                                 &&
cp -v -R junit*/javadoc/*             /usr/share/doc/junit-4.11  &&
cp -v junit*/junit*.jar               /usr/share/java/junit-4.11 &&
cp -v hamcrest-1.3/hamcrest-core*.jar /usr/share/java/junit-4.11

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
