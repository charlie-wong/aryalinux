#!/bin/b

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
NAME=lxqt-desktop-environment
DESCRIPTION="The LXQT Desktop environment"
VERSION=0.11

#REQ:libfm
#REQ:libstatgrab
#REQ:lm_sensors
#REQ:extra-cmake-modules
#REQ:libdbusmenu-qt
#REQ:polkit-qt
#REQ:xdg-utils
#REQ:oxygen-icons5
#REQ:lxqt-build-tools
#REQ:libsysstat
#REQ:libqtxdg
#REQ:lxqt-kwindowsystem
#REQ:liblxqt
#REQ:libfm-qt
#REQ:lxqt-about
#REQ:lxqt-admin
#REQ:lxqt-common
#REQ:lxqt-kwayland
#REQ:lxqt-libkscreen
#REQ:lxqt-config
#REQ:lxqt-globalkeys
#REQ:lxqt-notificationd
#REQ:lxqt-policykit
#REQ:kidletime
#REQ:lxqt-solid
#REQ:lxqt-powermanagement
#REQ:lxqt-qtplugin
#REQ:lxqt-session
#REQ:lxqt-l10n
#REQ:lxqt-kguiaddons
#REQ:lxqt-panel
#REQ:lxqt-runner
#REQ:pcmanfm-qt

sudo update-mime-database /usr/share/mime          &&
sudo xdg-icon-resource forceupdate --theme hicolor &&
sudo update-desktop-database -q

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
