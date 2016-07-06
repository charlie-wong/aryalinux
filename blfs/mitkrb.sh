#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:krb5:1.14.2

#OPT:dejagnu
#OPT:gnupg
#OPT:keyutils
#OPT:openldap
#OPT:python2
#OPT:rpcbind


cd $SOURCE_DIR

URL=http://web.mit.edu/kerberos/dist/krb5/1.14/krb5-1.14.2.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/krb5/krb5-1.14.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/krb5/krb5-1.14.2.tar.gz || wget -nc http://web.mit.edu/kerberos/dist/krb5/1.14/krb5-1.14.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/krb5/krb5-1.14.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/krb5/krb5-1.14.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/krb5/krb5-1.14.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd src &&
sed -e "s@python2.5/Python.h@& python2.7/Python.h@g" \
    -e "s@-lpython2.5]@&,\n  AC_CHECK_LIB(python2.7,main,[PYTHON_LIB=-lpython2.7])@g" \
    -i configure.in &&
sed -e 's@\^u}@^u cols 300}@' \
    -i tests/dejagnu/config/default.exp &&
sed -e  '/eq 0/{n;s/12 //}' \
    -i plugins/kdb/db2/libdb2/test/run.test &&
autoconf &&
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --with-system-et         \
            --with-system-ss         \
            --with-system-verto=no   \
            --enable-dns-for-realm   &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
for f in gssapi_krb5 gssrpc k5crypto kadm5clnt kadm5srv \
               kdb5 kdb_ldap krad krb5 krb5support verto ; do
    find /usr/lib -type f -name "lib$f*.so*" -exec chmod -v 755 {} \;
done &&
mv -v /usr/lib/libkrb5.so.3*        /lib &&
mv -v /usr/lib/libk5crypto.so.3*    /lib &&
mv -v /usr/lib/libkrb5support.so.0* /lib &&
ln -sfv ../../lib/libkrb5.so.3.3        /usr/lib/libkrb5.so        &&
ln -sfv ../../lib/libk5crypto.so.3.1    /usr/lib/libk5crypto.so    &&
ln -sfv ../../lib/libkrb5support.so.0.1 /usr/lib/libkrb5support.so &&
mv -v /usr/bin/ksu /bin &&
chmod -v 755 /bin/ksu   &&
install -v -dm755 /usr/share/doc/krb5-1.14.2 &&
cp -rfv ../doc/*  /usr/share/doc/krb5-1.14.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.07/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-krb5

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mitkrb=>`date`" | sudo tee -a $INSTALLED_LIST
