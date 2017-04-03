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

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.04/aryalinux-wallpapers-2017.04.tar.xz
wget -nc $URL

sudo tar -xf aryalinux-wallpapers-2016.04.tar.gz -C /

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
