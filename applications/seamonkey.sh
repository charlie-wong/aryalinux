#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak SeaMonkey is a browser suite, thebr3ak Open Source sibling of Netscape.br3ak It includes the browser, composer, mail and news clients, and anbr3ak IRC client. It is the follow-on to the Mozilla browser suite.br3ak"
SECTION="xsoft"
VERSION=2.46
NAME="seamonkey"

#REQ:alsa-lib
#REQ:autoconf213
#REQ:gtk2
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:icu
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:sqlite
#OPT:curl
#OPT:dbus-glib
#OPT:doxygen
#OPT:GConf
#OPT:gst10-plugins-base
#OPT:openjdk
#OPT:pulseaudio
#OPT:startup-notification
#OPT:valgrind
#OPT:wget
#OPT:wireless_tools


cd $SOURCE_DIR

URL=https://ftp.mozilla.org/pub/mozilla.org/seamonkey/releases/2.46/source/seamonkey-2.46.source.tar.xz

if [ ! -z $URL ]
then
wget -nc https://ftp.mozilla.org/pub/mozilla.org/seamonkey/releases/2.46/source/seamonkey-2.46.source.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/seamonkey/seamonkey-2.46.source.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/seamonkey/seamonkey-2.46.source.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/seamonkey/seamonkey-2.46.source.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/seamonkey/seamonkey-2.46.source.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/seamonkey/seamonkey-2.46.source.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/seamonkey/seamonkey-2.46.source.tar.xz

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

cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.
# If desired, you can reduce the number of cores used, e.g. to 1, by
# uncommenting the next line and setting a valid number of CPU cores.
#mk_add_options MOZ_MAKE_FLAGS="-j1"
# If you have installed DBus-Glib comment out this line:
ac_add_options --disable-dbus
# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi
# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification
# Comment out the following option if you have PulseAudio installed
ac_add_options --disable-pulseaudio
# Comment out following option if you have gconf installed
ac_add_options --disable-gconf
# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
# Us the internal version of icu due to execution problems
#ac_add_options --with-system-icu
# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=suite
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests
ac_add_options --enable-optimize
ac_add_options --enable-strip
ac_add_options --enable-install-strip
ac_add_options --enable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier
# Use internal cairo due to reports of unstable execution with
# system cairo
#ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-pthreads
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
EOF


CFLAGS_HOLD=$CFLAGS           &&
CXXFLAGS_HOLD=$CXXFLAGS       &&
EXTRA_FLAGS=" -fno-delete-null-pointer-checks -fno-lifetime-dse -fno-schedule-insns2" &&
export CFLAGS+=$EXTRA_FLAGS   &&
export CXXFLAGS+=$EXTRA_FLAGS &&
unset EXTRA_FLAGS             &&
sed -e 's/256/224/'                                   \
    -i mozilla/netwerk/protocol/http/Http2Session.cpp &&
sed -e '/version=/s/:space:/[&]/' \
    -i ./mozilla/build/autoconf/icu.m4 &&
sed -e s/_EVENT_SIZEOF/EVENT__SIZEOF/ \
    -i mozilla/ipc/chromium/src/base/message_pump_libevent.cc
make -f client.mk



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make  -f client.mk install INSTALL_SDK= &&
chown -R 0:0 /usr/lib/seamonkey-2.46    &&
cp -v $(find -name seamonkey.1 | head -n1) /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


export CFLAGS=$CFLAGS_HOLD     &&
export CXXFLAGS=$CXXFLAGS_HOLD &&
unset CFLAGS_HOLD CXXFLAGS_HOLD



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C obj* install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/{applications,pixmaps}              &&
cat > /usr/share/applications/seamonkey.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=SeaMonkey
Comment=The Mozilla Suite
Icon=seamonkey
Exec=seamonkey
Categories=Network;GTK;Application;Email;Browser;WebBrowser;News;
StartupNotify=true
Terminal=false
EOF
ln -sfv /usr/lib/seamonkey-2.46/chrome/icons/default/seamonkey.png \
        /usr/share/pixmaps

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
