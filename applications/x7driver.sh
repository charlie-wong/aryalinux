#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

## Individual drivers starts from here... ##


# Start of driver installation #

#REQ:python2
#REQ:python3
#OPT:check
#OPT:doxygen
#OPT:valgrind


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/libevdev/libevdev-1.5.6.tar.xz

wget -nc http://www.freedesktop.org/software/libevdev/libevdev-1.5.6.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7driver
#REQ:mtdev
#OPT:check
#OPT:valgrind
#OPT:doxygen
#OPT:graphviz
#OPT:gtk3
#OPT:libwacom


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/libinput/libinput-1.6.1.tar.xz

wget -nc http://www.freedesktop.org/software/libinput/libinput-1.6.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG       \
            --disable-libwacom \
            --with-udev-dir=/lib/udev &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/libinput-1.6.1 &&
cp -rv doc/html/* /usr/share/doc/libinput-1.6.1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7driver
#REQ:mtdev
#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-input-evdev-2.10.5.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-input-evdev-2.10.5.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-evdev-2.10.5.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7driver
#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-input-synaptics-1.9.0.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-input-synaptics-1.9.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-synaptics-1.9.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG               \
            --without-hal-fdi-dir      \
            --without-hal-callouts-dir \
            --with-udev-rules-dir=/lib/udev/rules.d &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server
#OPT:doxygen
#OPT:graphviz


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/linuxwacom/xf86-input-wacom-0.34.0.tar.bz2

wget -nc http://downloads.sourceforge.net/linuxwacom/xf86-input-wacom-0.34.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG \
            --with-udev-rules-dir=/lib/udev/rules.d \
            --with-systemd-unit-dir=/lib/systemd/system &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-ati-7.8.0.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-ati-7.8.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-ati-7.8.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xcb-util
#REQ:xorg-server


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20170216.tar.xz

wget -nc http://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20170216.tar.xz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20170216.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG --enable-kms-only --enable-uxa &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /usr/share/man/man4/intel-virtual-output.4 \
      /usr/share/man/man1/intel-virtual-output.1 &&
sed -i '/\.TH/s/4/1/' /usr/share/man/man1/intel-virtual-output.1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/xorg.conf.d/20-intel.conf << "EOF"
Section "Device"
 Identifier "Intel Graphics"
 Driver "intel"
 Option "AccelMethod" "uxa"
EndSection
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-nouveau-1.0.13.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-nouveau-1.0.13.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-nouveau-1.0.13.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/xorg.conf.d/nvidia.conf << "EOF"
Section "Device"
 Identifier "nvidia"
 Driver "nouveau"
 Option "AccelMethod" "glamor"
EndSection
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-vmware-13.2.1.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-vmware-13.2.1.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-vmware-13.2.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:mesa
#OPT:doxygen
#OPT:wayland


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/vaapi/releases/libva/libva-1.7.3.tar.bz2

wget -nc http://www.freedesktop.org/software/vaapi/releases/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-1.7.3.tar.bz2
wget -nc http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.7.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


autoreconf -fi           &&
./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7lib
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa


cd $SOURCE_DIR

URL=http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

wget -nc http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG \
            --docdir=/usr/share/doc/libvdpau-1.1.1 &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:cmake
#REQ:ffmpeg
#REQ:x7driver
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa


cd $SOURCE_DIR

URL=https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0.tar.gz

wget -nc https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

wget https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0.tar.gz \
     -O libvdpau-va-gl-0.4.0.tar.gz

mkdir build &&
cd    build &&

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "export VDPAU_DRIVER=va_gl" >> /etc/profile.d/xorg.sh
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #

echo "x7driver=>`date`" | sudo tee -a $INSTALLED_LIST

