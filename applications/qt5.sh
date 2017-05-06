#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Qt5 is a cross-platformbr3ak application framework that is widely used for developingbr3ak application software with a graphical user interface (GUI) (inbr3ak which cases Qt5 is classified as abr3ak widget toolkit), and also used for developing non-GUI programs suchbr3ak as command-line tools and consoles for servers. One of the majorbr3ak users of Qt is KDE Frameworks 5 (KF5).br3ak"
SECTION="x"
VERSION=5.8.0
NAME="qt5"

#REQ:python2
#REQ:x7lib
#REC:alsa-lib
#REC:cacerts
#REC:cups
#REC:glib2
#REC:gst10-plugins-base
#REC:harfbuzz
#REC:icu
#REC:jasper
#REC:libjpeg
#REC:libmng
#REC:libpng
#REC:libtiff
#REC:libxkbcommon
#REC:mesa
#REC:mtdev
#REC:nss
#REC:openssl
#REC:pcre
#REC:sqlite
#REC:wayland
#REC:xcb-util-image
#REC:xcb-util-keysyms
#REC:xcb-util-renderutil
#REC:xcb-util-wm
#OPT:bluez
#OPT:ibus
#OPT:x7driver
#OPT:mariadb
#OPT:pciutils
#OPT:postgresql
#OPT:pulseaudio
#OPT:unixodbc


cd $SOURCE_DIR

URL=http://download.qt.io/archive/qt/5.8/5.8.0/single/qt-everywhere-opensource-src-5.8.0.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.8.0.tar.xz || wget -nc http://download.qt.io/archive/qt/5.8/5.8.0/single/qt-everywhere-opensource-src-5.8.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.8.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.8.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.8.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.8.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.8.0.tar.xz

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

export QT5PREFIX=/opt/qt5

sudo mkdir -pv /opt/qt-5.8.0
sudo ln -sfnv qt-5.8.0 /opt/qt5

./configure -prefix         /opt/qt5 \
            -sysconfdir     /etc/xdg   \
            -confirm-license           \
            -opensource                \
            -dbus-linked               \
            -openssl-linked            \
            -system-harfbuzz           \
            -system-sqlite             \
            -nomake examples           \
            -no-rpath                  \
            -skip qtwebengine          &&
make "-j`nproc`" || make

sudo mkdir -pv /var/cache/alps/binaries
sudo chmod a+rw /var/cache/alps/binaries

INSTALL_DIR=/var/cache/alps/binaries/$NAME-$VERSION-$(uname -m)
make INSTALL_ROOT=${INSTALL_DIR} install
find ${INSTALL_DIR}/opt/qt5/lib/pkgconfig -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;
find ${INSTALL_DIR}/opt/qt5/ -name qt_lib_bootstrap_private.pri \
   -exec sed -i -e "s:$PWD/qtbase://opt/qt5/lib/:g" {} \; &&
find ${INSTALL_DIR}/opt/qt5/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

install -v -dm755 ${INSTALL_DIR}/usr/share/pixmaps/                  &&
install -v -Dm644 qttools/src/assistant/assistant/images/assistant-128.png \
                  ${INSTALL_DIR}/usr/share/pixmaps/assistant-qt5.png &&
install -v -Dm644 qttools/src/designer/src/designer/images/designer.png \
                  ${INSTALL_DIR}/usr/share/pixmaps/designer-qt5.png  &&
install -v -Dm644 qttools/src/linguist/linguist/images/icons/linguist-128-32.png \
                  ${INSTALL_DIR}/usr/share/pixmaps/linguist-qt5.png  &&
install -v -Dm644 qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png \
                  ${INSTALL_DIR}/usr/share/pixmaps/qdbusviewer-qt5.png &&
install -dm755 ${INSTALL_DIR}/usr/share/applications &&
cat > ${INSTALL_DIR}/usr/share/applications/assistant-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Assistant
Comment=Shows Qt5 documentation and examples
Exec=/opt/qt5/bin/assistant
Icon=assistant-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF
cat > ${INSTALL_DIR}/usr/share/applications/designer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Designer
GenericName=Interface Designer
Comment=Design GUIs for Qt5 applications
Exec=/opt/qt5/bin/designer
Icon=designer-qt5.png
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
cat > ${INSTALL_DIR}/usr/share/applications/linguist-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Linguist
Comment=Add translations to Qt5 applications
Exec=/opt/qt5/bin/linguist
Icon=linguist-qt5.png
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
cat > ${INSTALL_DIR}/usr/share/applications/qdbusviewer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 QDbusViewer
GenericName=D-Bus Debugger
Comment=Debug D-Bus applications
Exec=/opt/qt5/bin/qdbusviewer
Icon=qdbusviewer-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Debugger;
EOF

mkdir -pv ${INSTALL_DIR}/usr/bin/
mkdir -pv ${INSTALL_DIR}/etc/profile.d/

for file in moc uic rcc qmake lconvert lrelease lupdate; do
  ln -sfrvn ${INSTALL_DIR}/opt/qt5/bin/$file ${INSTALL_DIR}/usr/bin/$file-qt5
done

cat > ${INSTALL_DIR}/etc/profile.d/qt5.sh << "EOF"
# Begin /etc/profile.d/qt5.sh
QT5DIR=/opt/qt5
pathappend /opt/qt5/bin PATH
pathappend /opt/qt5/lib/pkgconfig PKG_CONFIG_PATH
export QT5DIR
# End /etc/profile.d/qt5.sh
EOF

cat > ${INSTALL_DIR}/etc/ld.so.conf.d/qt5.conf <<EOF
/opt/qt5/lib/
EOF

pushd ${INSTALL_DIR}
tar -cJvf ${INSTALL_DIR}/../$NAME-$VERSION-$(uname -m).tar.xz *
popd
rm -r ${INSTALL_DIR}

sudo tar xf /var/cache/alps/binaries/$NAME-$VERSION-$(uname -m).tar.xz -C /

sudo ldconfig

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
