#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Sshfs package contains abr3ak filesystem client based on the SSH File Transfer Protocol. This isbr3ak useful for mounting a remote computer that you have ssh access tobr3ak as a local filesystem. This allows you to drag and drop files orbr3ak run shell commands on the remote files as if they were on yourbr3ak local computer.br3ak"
SECTION="postlfs"
VERSION=2.8
NAME="sshfs"

#REQ:fuse
#REQ:glib2
#REQ:openssh


cd $SOURCE_DIR

URL=https://github.com/libfuse/sshfs/releases/download/sshfs_2.8/sshfs-2.8.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sshfs/sshfs-2.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sshfs/sshfs-2.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sshfs/sshfs-2.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sshfs/sshfs-2.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sshfs/sshfs-2.8.tar.gz || wget -nc https://github.com/libfuse/sshfs/releases/download/sshfs_2.8/sshfs-2.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sshfs/sshfs-2.8.tar.gz

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
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sshfs THINGY:~ ~/MOUNTPATH


fusermount -u ~/MOUNTPATH




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
