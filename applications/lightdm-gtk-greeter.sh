#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="lightdm-gtk-greeter"
DESCRIPTION="A GTK+ based greeter for lightdm"
VERSION=2.0.2

#REQ:lightdm
#REC:aryalinux-wallpapers
#REC:aryalinux-fonts
#REC:aryalinux-themes
#REC:aryalinux-icons

cd $SOURCE_DIR

URL=https://launchpad.net/lightdm-gtk-greeter/2.0/2.0.2/+download/lightdm-gtk-greeter-2.0.2.tar.gz
wget -nc $URL


TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar -xf $TARBALL

cd $DIRECTORY

export CFLAGS="-Wno-error=format-nonliteral"
./configure --prefix=/usr --sysconfdir=/etc --disable-liblightdm-qt &&
make "-j`nproc`"

cat > 1434987998845.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh


sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf << EOF
[greeter]
xft-hintstyle = hintmedium
xft-antialias = true
xft-rgba = rgb
icon-theme-name = Numix-Circle
theme-name = Greybird
background = /usr/share/backgrounds/aryalinux/paul-morris-183942.jpg
font-name = Droid Sans 10
EOF

 
cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
