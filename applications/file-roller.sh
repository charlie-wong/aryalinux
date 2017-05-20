#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak File Roller is an archive managerbr3ak for GNOME with support for tar,br3ak bzip2, gzip, zip, jar, compress, lzop and many other archivebr3ak formats.br3ak"
SECTION="gnome"
VERSION=3.22.2
NAME="file-roller"

#REQ:gtk3
#REQ:itstool
#REC:cpio
#REC:desktop-file-utils
#REC:json-glib
#REC:libarchive
#REC:libnotify
#REC:nautilus
#OPT:unrar
#OPT:unzip
#OPT:zip


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/file-roller/3.22/file-roller-3.22.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/file-roller/file-roller-3.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/file-roller/file-roller-3.22.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/file-roller/3.22/file-roller-3.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/file-roller/file-roller-3.22.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/file-roller/3.22/file-roller-3.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/file-roller/file-roller-3.22.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/file-roller/file-roller-3.22.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/file-roller/file-roller-3.22.2.tar.xz

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

./configure --prefix=/usr         \
            --disable-packagekit  \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 0755 /usr/libexec/file-roller/isoinfo.sh

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
