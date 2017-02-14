#!/bin/bash

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
#REQ:lxqt-about.sh
#REQ:lxqt-admin.sh
#REQ:lxqt-common.sh
#REQ:lxqt-kwayland.sh
#REQ:lxqt-libkscreen.sh
#REQ:lxqt-config.sh
#REQ:lxqt-globalkeys.sh
#REQ:lxqt-notificationd.sh
#REQ:lxqt-policykit.sh
#REQ:kidletime.sh
#REQ:lxqt-solid.sh
#REQ:lxqt-powermanagement.sh
#REQ:lxqt-qtplugin.sh
#REQ:lxqt-session.sh
#REQ:lxqt-l10n.sh
#REQ:lxqt-kguiaddons.sh
#REQ:lxqt-panel.sh
#REQ:lxqt-runner.sh
#REQ:pcmanfm-qt.sh

sudo update-mime-database /usr/share/mime          &&
sudo xdg-icon-resource forceupdate --theme hicolor &&
sudo update-desktop-database -q

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
