#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
NAME=mate-desktop-environment
DESCRIPTION="The classic linux desktop environment forked from the gnome 2 desktop environment."
VERSION=1.18

#REQ:gobject-introspection
#REQ:desktop-file-utils
#REQ:shared-mime-info
#REQ:libxml2
#REQ:libxslt
#REQ:glib2
#REQ:libidl
#REQ:dbus
#REQ:dbus-glib
#REQ:polkit
#REQ:popt
#REQ:libgcrypt
#REQ:gtk2
#REQ:libcanberra
#REQ:libart
#REQ:libglade
#REQ:libtasn1
#REQ:libxklavier
#REQ:libsoup
#REQ:icon-naming-utils
#REQ:libunique
#REQ:libunique3
#REQ:libwnck
#REQ:librsvg
#REQ:upower
#REQ:intltool
#REQ:libtasn1
#REQ:libtool
#REQ:xmlto
#REQ:gtk-doc
#REQ:rarian
#REQ:dconf
#REQ:libsecret
#REQ:gnome-keyring
#REQ:libnotify
#REQ:libwnck2
#REQ:zenity
#REC:yelp
#REQ:xdg-utils
#REQ:xdg-user-dirs

#REQ:mate-common
#REQ:mate-desktop
#REQ:libmatekbd
#REQ:libmatewnck
#REQ:libmateweather
#REQ:mate-icon-theme
#REQ:caja
#REQ:marco
#REQ:mate-settings-daemon
#REQ:mate-session-manager
#REQ:mate-menus
#REQ:mate-panel
#REQ:mate-control-center
#REQ:lightdm
#REQ:lightdm-gtk-greeter
#REQ:plymouth
#REQ:mate-screensaver

#REQ:mate-terminal
#REQ:caja
#REQ:caja-extensions
#REQ:caja-dropbox
#REQ:pluma
#REQ:galculator
#REQ:eom
#REQ:engrampa
#REQ:atril
#REQ:mate-utils
#REQ:murrine-gtk-engine
#REQ:mate-themes-gtk3
#REQ:gnome-themes-standard
#REQ:adwaita-icon-theme
#REQ:mate-system-monitor
#REQ:mate-power-manager
#REQ:marco
#REQ:python-modules#pygobject2
#REQ:python-modules#pygobject3
#REQ:mozo
#REQ:mate-backgrounds
#REQ:mate-media

#REQ:wireless_tools
#REQ:wpa_supplicant
#REQ:networkmanager
#REQ:ModemManager
#REQ:network-manager-applet
#REQ:net-tools
#REQ:usb_modeswitch
#REQ:compton
#REQ:arc-gtk-theme

sudo tee /etc/gtk-2.0/gtkrc <<"EOF"
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "elementary"
EOF

sudo mkdir -pv /etc/polkit-1/localauthority/50-local.d/
sudo mkdir -pv /etc/polkit-1/rules.d/

sudo tee /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManagerAndUdisks2.rules <<"EOF"
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 || action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0) {
    return polkit.Result.YES;
  }
});
EOF

sudo mkdir -pv /usr/share/icons/default/
sudo tee /usr/share/icons/default/index.theme <<"EOF"
[Icon Theme]
Inherits=Adwaita
EOF

ccache -C
sudo ccache -C
ccache -c
sudo ccache -c

rm -rf ~/.ccache
sudo rm -rf ~/.ccache
xdg-user-dirs-update
sudo xdg-user-dirs-update

sudo tee /etc/profile.d/xdg.sh << EOF
cd ~
xdg-user-dirs-update
EOF

sudo rm -rf /etc/X11/xorg.conf.d/*

sudo tee /etc/X11/xorg.conf.d/99-synaptics-overrides.conf <<"EOF"
Section  "InputClass"
    Identifier  "touchpad overrides"
    # This makes this snippet apply to any device with the "synaptics" driver
    # assigned
    MatchDriver  "synaptics"

    ####################################
    ## The lines that you need to add ##
    # Enable left mouse button by tapping
    Option  "TapButton1"  "1"
    # Enable vertical scrolling
    Option  "VertEdgeScroll"  "1"
    # Enable right mouse button by tapping lower right corner
    Option "RBCornerButton" "3"
    ####################################

EndSection
EOF

if [ ! -f /usr/share/pixmaps/aryalinux.png ]
then
pushd /usr/share/pixmaps/
sudo wget https://sourceforge.net/projects/aryalinux-bin/files/artifacts/aryalinux.png
popd
fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
