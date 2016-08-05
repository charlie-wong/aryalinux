#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:systemd:230

#REQ:linux-pam
#REC:polkit
#OPT:cacerts
#OPT:curl
#OPT:elfutils
#OPT:gnutls
#OPT:iptables
#REQ:libgcrypt
#OPT:libidn
#OPT:libxkbcommon
#OPT:python2
#OPT:python3
#OPT:qemu
#OPT:valgrind
#OPT:docbook
#OPT:docbook-xsl
#REQ:libxslt


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/sources/other/systemd/systemd-230.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/systemd/systemd-230.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/systemd/systemd-230.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/systemd/systemd-230.tar.xz || wget -nc http://anduin.linuxfromscratch.org/sources/other/systemd/systemd-230.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/systemd/systemd-230.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/systemd/systemd-230.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's@DRI and frame buffer@DRI@' \
    -e '/SUBSYSTEM==\"graphics\", KERNEL==\"fb\*\"/d' \
    -i  src/login/70-uaccess.rules


sed -e 's:test/udev-test.pl ::g'  \
    -e 's:test-copy$(EXEEXT) ::g' \
    -i Makefile.in


cc_cv_CFLAGS__flto=no                \
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --with-rootprefix=       \
            --with-rootlibdir=/lib   \
            --enable-split-usr       \
            --disable-firstboot      \
            --disable-ldconfig       \
            --disable-sysusers       \
            --without-python         \
            --with-default-dnssec=no \
            --docdir=/usr/share/doc/systemd-230 &&
make "-j`nproc`"


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -rfv /usr/lib/rpm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition
 
session required pam_loginuid.so
session optional pam_systemd.so
# End Systemd addition
EOF
cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user
account required pam_access.so
account include system-account
session required pam_env.so
session required pam_limits.so
session include system-session
auth required pam_deny.so
password required pam_deny.so
# End /etc/pam.d/systemd-user
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "systemd=>`date`" | sudo tee -a $INSTALLED_LIST
