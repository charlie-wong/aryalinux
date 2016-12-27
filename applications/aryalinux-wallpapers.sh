#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="aryalinux-wallpapers"
DESCRIPTION="Wallpapers for AryaLinux"
VERSION="2016.12"

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2016.12/aryalinux-wallpapers-2016.12.tar.xz
wget -nc $URL

sudo mkdir -pv /usr/share/backgrounds/aryalinux/
sudo tar -xf aryalinux-wallpapers-2016.12.tar.xz -C /usr/share/backgrounds/aryalinux/

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
