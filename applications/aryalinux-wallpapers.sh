#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="aryalinux-wallpapers"
DESCRIPTION="Wallpapers for AryaLinux"
VERSION="2016.04"

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.02/aryalinux-wallpaper-2017.02.tar.xz
wget -nc $URL

sudo tar -xf aryalinux-wallpaper-2017.02.tar.xz -C /

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
