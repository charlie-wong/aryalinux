#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Aspell package contains anbr3ak interactive spell checking program and the Aspell libraries. Aspell can either be used as a library or asbr3ak an independent spell checker.br3ak"
SECTION="general"
VERSION=0.60.7
NAME="aspell"

#REQ:general_which


cd $SOURCE_DIR

URL=ftp://alpha.gnu.org/gnu/aspell/aspell-0.60.7-rc1.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://alpha.gnu.org/gnu/aspell/aspell-0.60.7-rc1.tar.gz
wget -nc https://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2017.01.22-0.tar.bz2

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svfn aspell-0.60 /usr/lib/aspell

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 scripts/ispell /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 scripts/spell /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

pushd $SOURCE_DIR
tar xf aspell6-en-2017.01.22-0.tar.bz2
cd aspell6-en-2017.01.22-0
./configure &&
make
sudo make install
cd ..
sudo rm -rf aspell6-en-2017.01.22-0


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
