#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Firefox is a stand-alone browser based on the Mozilla codebase."
SECTION="xsoft"
VERSION=51.0.1
NAME="firefox"

#REQ:alsa-lib
#REQ:autoconf213
#REQ:gtk3
#REQ:gtk2
#REQ:nss
#REQ:unzip
#REQ:yasm
#REQ:zip
#REQ:dbus-glib
#REQ:GConf
#REQ:ffmpeg
#REQ:libwebp
#REQ:pulseaudio
#REQ:startup-notification
#REQ:valgrind
#REQ:liboauth
#REQ:graphite2
#REC:icu
#REC:libevent
#REC:libvpx
#REC:sqlite
#REQ:cargo
#REQ:rust
#OPT:curl
#OPT:dbus-glib
#OPT:doxygen
#OPT:GConf
#OPT:ffmpeg
#OPT:libwebp
#OPT:openjdk
#OPT:pulseaudio
#OPT:startup-notification
#OPT:valgrind
#OPT:wget
#OPT:wireless_tools
#OPT:liboauth
#OPT:graphite2
#OPT:harfbuzz


cd $SOURCE_DIR

URL=https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$VERSION/source/firefox-$VERSION.source.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

export SHELL=/bin/sh

cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.
# If desired, you can reduce the number of cores used, e.g. to 1, by
# uncommenting the next line and setting a valid number of CPU cores.
#mk_add_options MOZ_MAKE_FLAGS="-j1"
# If you have installed dbus-glib, comment out this line:
#ac_add_options --disable-dbus
# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
#ac_add_options --disable-necko-wifi
# Uncomment this option if you wish to build with gtk+-2
#ac_add_options --enable-default-toolkit=cairo-gtk2
# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification
# Comment out following option if you have PulseAudio installed
#ac_add_options --disable-pulseaudio
# If you have installed GConf, comment out this line
#ac_add_options --disable-gconf
# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu
# If you are going to apply the patch for system graphite
# and system harfbuzz, uncomment these lines:
# ac_add_options --with-system-graphite2
# ac_add_options --with-system-harfbuzz
# Stripping is now enabled by default.
# Uncomment these lines if you need to run a debugger:
#ac_add_options --disable-strip
#ac_add_options --disable-install-strip
# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=browser
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests
ac_add_options --enable-optimize
ac_add_options --enable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier
# From firefox-40, using system cairo causes firefox to crash
# frequently when it is doing background rendering in a tab.
#ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-pthreads
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
EOF


sed -e s/_EVENT_SIZEOF/EVENT__SIZEOF/ \
    -i ipc/chromium/src/base/message_pump_libevent.cc

make -f client.mk

sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -f client.mk install INSTALL_SDK= &&
chown -R 0:0 /usr/lib/firefox-$VERSION   &&
mkdir -pv    /usr/lib/mozilla/plugins  &&
ln    -sfv   ../../mozilla/plugins /usr/lib/firefox-$VERSION/browser

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/applications &&
mkdir -pv /usr/share/pixmaps &&
cat > /usr/share/applications/firefox.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF
ln -sfv /usr/lib/firefox-$VERSION/browser/icons/mozicon128.png \
        /usr/share/pixmaps/firefox.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
