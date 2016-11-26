#!/bin/bash

set -e
set +h

USERNAME="$1"

alps selfupdate
alps updatescripts

su - $USERNAME -c "env QT5DIR=/opt/qt5 QT5BINDIR=/opt/qt5 alps install-no-prompt qt5"

su - $USERNAME -c "env QT5DIR=/opt/qt5 QT5BINDIR=/opt/qt5 PATH=$PATH:$QT5BINDIR alps install-no-prompt extra-cmake-modules install phonon phonon-backend-gstreamer phonon-backend-vlc polkit-qt libdbusmenu-qt oxygen-fonts noto-fonts kframeworks5 ark5 kate5 kdenlive kmix5 khelpcenter konsole5 libkexiv2 okular5 libkdcraw gwenview5 plasma-all sddm"

if ! grep "sddm=" /etc/alps/installed-list &> /dev/null
then
        echo "KDE5 installation incomplete. Aborting..."
        exit 1
fi