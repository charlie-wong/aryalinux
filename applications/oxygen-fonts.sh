#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Oxygen fonts - needed by KDE"
VERSION=
NAME="oxygen-fonts"

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.02/oxygen-fonts.tar.xz

sudo tar xf oxygen-fonts.tar.xz -C /usr/share/fonts/

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

