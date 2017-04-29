#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak GDM is a system service that isbr3ak responsible for providing graphical logins and managing local andbr3ak remote displays.br3ak"
SECTION="gnome"
VERSION=3.22.2
NAME="gdm"

#REQ:accountsservice
#REQ:gtk3
#REQ:iso-codes
#REQ:itstool
#REQ:libcanberra
#REQ:libdaemon
#REQ:linux-pam
#REQ:gnome-session
#REQ:gnome-shell
#REQ:systemd
#OPT:check


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gdm/3.22/gdm-3.22.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdm/gdm-3.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdm/gdm-3.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdm/gdm-3.22.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdm/3.22/gdm-3.22.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gdm/3.22/gdm-3.22.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gdm/gdm-3.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdm/gdm-3.22.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdm/gdm-3.22.2.tar.xz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --without-plymouth    \
            --disable-static      \
            --enable-gdm-xsession \
            --with-systemdsystemunitdir=/lib/systemd/system/ &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
cp -v data/gdm.service /lib/systemd/system/
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable gdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
