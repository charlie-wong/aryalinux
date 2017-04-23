#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="gnome-desktop-environment"
VERSION="3.22"
DESCRIPTION="GNOME is a desktop environment that is composed entirely of free and open-source software. GNOME was originally an acronym for GNU Network Object Model Environment."

#REQ:accountsservice
#REQ:desktop-file-utils
#REQ:gcr
#REQ:gsettings-desktop-schemas
#REQ:libsecret
#REQ:rest
#REQ:totem-pl-parser
#REQ:vte
#REQ:yelp-xsl
#REQ:GConf
#REQ:geocode-glib
#REQ:gjs
#REQ:gnome-desktop
#REQ:gnome-menus
#REQ:libnotify
#REQ:gnome-online-accounts
#REQ:gnome-video-effects
#REQ:grilo
#REQ:gtkhtml
#REQ:libchamplain
#REQ:libgdata
#REQ:libgee
#REQ:libgtop
#REQ:libgweather
#REQ:libpeas
#REQ:libwacom
#REQ:libwnck
#REQ:evolution-data-server
#REQ:telepathy-glib
#REQ:telepathy-logger
#REQ:telepathy-mission-control
#REQ:caribou
#REQ:dconf
#REQ:gnome-backgrounds
#REQ:librsvg
#REQ:gnome-themes-standard
#REQ:gvfs
#REQ:nautilus
#REQ:zenity
#REQ:gnome-bluetooth
#REQ:gnome-keyring
#REQ:clutter-gst2
#REQ:cups
#REQ:cups-filters
#REQ:gnome-settings-daemon
#REQ:grilo2
#REQ:gnome-control-center
#REQ:mutter
#REQ:gnome-shell
#REQ:gnome-shell-extensions
#REQ:gnome-session
#REQ:plymouth
#OPT:lightdm-gtk-greeter
#REQ:gnome-user-docs
#OPT:yelp
#REQ:baobab
#REQ:brasero
#REQ:cheese
#REQ:eog
#REQ:evince
#REQ:file-roller
#REQ:gedit
#REQ:gnome-calculator
#REQ:gnome-disk-utility
#REQ:gnome-logs
#REQ:gnome-maps
#REQ:gnome-nettool
#REQ:gnome-power-manager
#REQ:gnome-system-monitor
#REQ:gnome-terminal
#REQ:gnome-tweak-tool
#REQ:gnome-weather
#REQ:gucharmap
#REQ:network-manager-applet
#REQ:seahorse
#REQ:notification-daemon
#REQ:polkit-gnome

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
