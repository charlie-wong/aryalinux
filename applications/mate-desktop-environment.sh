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
#REQ:python-modules#pygobject2
#REQ:python-modules#pygobject3
#REQ:gnome-themes-standard
#REQ:adwaita-icon-theme
#REQ:mate-themes-gtk3
#REQ:galculator
#REQ:lightdm
#REQ:lightdm-gtk-greeter
#REQ:plymouth
#REQ:murrine-gtk-engine
#REQ:wireless_tools
#REQ:wpa_supplicant
#REQ:networkmanager
#REQ:ModemManager
#REQ:network-manager-applet
#REQ:net-tools
#REQ:usb_modeswitch
#REQ:compton


cd $SOURCE_DIR

sudo mkdir -pv /etc/profile.d
sudo tee /etc/profile.d/mate.sh <<EOF
export PATH=$PATH:/opt/mate/bin
export PKG_CONFIG_PATH=/opt/mate/usr/lib/pkgconfig
EOF

sudo tee -a /etc/ld.so.conf <<EOF
/opt/mate/lib
/opt/mate/usr/lib
EOF

cat > mate-packages.list <<"EOF"
mate-common 1.18 1.18.0
mate-desktop 1.18 1.18.0
libmatekbd 1.18 1.18.2
libmatewnck 1.6 1.6.1
libmateweather 1.18 1.18.1
mate-icon-theme 1.18 1.18.2
caja 1.18 1.18.1
marco 1.18 1.18.1
mate-settings-daemon 1.18 1.18.1
mate-session-manager 1.18 1.18.0
mate-menus 1.18 1.18.0
mate-panel 1.18 1.18.3
mate-control-center 1.18 1.18.2
mate-screensaver 1.18 1.18.1
mate-terminal 1.18 1.18.1
caja 1.18 1.18.3
caja-extensions 1.18 1.18.1
caja-dropbox 1.18 1.18.0
pluma 1.18 1.18.2
eom 1.18 1.18.2
engrampa 1.18 1.18.2
atril 1.18 1.18.0
mate-utils 1.18 1.18.2
mate-system-monitor 1.18 1.18.0
mate-power-manager 1.18 1.18.0
marco 1.18 1.18.1
mozo 1.18 1.18.0
mate-backgrounds 1.18 1.18.0
mate-media 1.18 1.18.1
EOF

for line in $(cat mate-packages.list); do
echo "Installing $line"
package_name=$(echo $line | cut -d " " -f1)
version=$(echo $line | cut -d " " -f2)
full_version=$(echo $line | cut -d " " -f3)

if ! grep "$package_name" $INSTALLED_LIST; then
	url="http://pub.mate-desktop.org/releases/$version/$package_name-$full_version.tar.xz"
	wget -nc $url
	tarball_name=$(echo $url | rev | cut -d/ -f1 | rev)
	directory_name=$(tar tf $tarball_name | cut -d/ -f1 | uniq)

	tar xf $tarball_name
	cd $directory_name

	export PKG_CONFIG_PATH=/opt/mate/usr/lib/pkgconfig

	if [ "$line" == "mate-power-manager" ]; then
		./configure --prefix=/opt/mate --disable-static --with-gtk=3.0 --without-keyring
	elif [ "$line" == "libmatewnck" ]; then
		./configure --prefix=/opt/mate --disable-static
	else
		./configure --prefix=/opt/mate --disable-static --with-gtk=3.0
	fi
	make "-j`nproc`"
	sudo make install

	sudo ldconfig

	cd $SOURCE_DIR
	sudo rm -rf $directory_name

	register_installed "$package_name" "$full_version" "$INSTALLED_LIST"
fi

done

pushd /opt/mate/share/applications/
for f in *.desktop; do
	sudo ln -svf "/opt/mate/share/applications/$f" "/usr/share/applications/mate-$f"
done
popd

sudo ln -svf "/mate/share/xsessions/mate.desktop" "/usr/share/xsessions/mate.desktop"

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
