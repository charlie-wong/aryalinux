#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Firefox is a stand-alone browserbr3ak based on the Mozilla codebase.br3ak"
SECTION="xsoft"
VERSION=53.0
NAME="firefox"

#REQ:autoconf213
#REQ:cargo
#REQ:gtk3
#REQ:gtk2
#REQ:nss
#REQ:pulseaudio
#REQ:alsa-lib
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:icu
#REC:libevent
#REC:libvpx
#REC:sqlite
#REQ:curl
#REQ:dbus-glib
#OPT:doxygen
#REQ:GConf
#REQ:ffmpeg
#REQ:libwebp
#OPT:openjdk
#REQ:startup-notification
#REQ:valgrind
#REQ:wget
#REQ:wireless_tools
#REQ:liboauth
#REQ:graphite2
#REQ:harfbuzz


cd $SOURCE_DIR

URL=https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/53.0/source/firefox-53.0.source.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/firefox/firefox-53.0.source.tar.xz || wget -nc https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/53.0/source/firefox-53.0.source.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/firefox/firefox-53.0.source.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/firefox/firefox-53.0.source.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/firefox/firefox-53.0.source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/firefox/firefox-53.0.source.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/firefox/firefox-53.0.source.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/firefox-53.0-system_graphite2_harfbuzz-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/firefox/firefox-53.0-system_graphite2_harfbuzz-1.patch

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
# ac_add_options --disable-dbus
# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
# ac_add_options --disable-necko-wifi
# Uncomment this option if you wish to build with gtk+-2
#ac_add_options --enable-default-toolkit=cairo-gtk2
# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
ac_add_options --enable-startup-notification
# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# and uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa
# If you have installed GConf, comment out this line
# ac_add_options --disable-gconf
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
ac_add_options --with-system-graphite2
ac_add_options --with-system-harfbuzz
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


patch -Np1 -i ../firefox-53.0-system_graphite2_harfbuzz-1.patch


sed -e s/_EVENT_SIZEOF/EVENT__SIZEOF/ \
    -i ipc/chromium/src/base/message_pump_libevent.cc

SHELL=/bin/sh make -f client.mk

INSTALL_DIR=/var/cache/alps/binaries/$NAME-$VERSION-$(uname -m)
SHELL=/bin/sh make -f client.mk install DESTDIR="$INSTALL_DIR" INSTALL_SDK=
mkdir -pv    $INSTALL_DIR/usr/lib/mozilla/plugins
ln    -sfv   ../../mozilla/plugins $INSTALL_DIR/usr/lib/firefox-53.0/browser
mkdir -pv $INSTALL_DIR/usr/share/{applications,pixmaps} &&
cat > $INSTALL_DIR/usr/share/applications/firefox.desktop << "EOF" &&
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
ln -sfv /usr/lib/firefox-53.0/browser/icons/mozicon128.png \
        $INSTALL_DIR/usr/share/pixmaps/firefox.png
pushd ${INSTALL_DIR}
tar -cJvf ${INSTALL_DIR}/../$NAME-$VERSION-$(uname -m).tar.xz *
popd
sudo rm -r ${INSTALL_DIR}
sudo tar xf $BINARY_DIR/$NAME-$VERSION-$(uname -m).tar.xz -C /


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
