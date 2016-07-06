#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:postgresql:9.5.3

#OPT:python2
#OPT:tcl
#OPT:openssl
#OPT:libxml2
#OPT:libxslt
#OPT:openldap
#OPT:linux-pam
#OPT:mitkrb
#OPT:sgml-dtd
#OPT:docbook-dsssl
#OPT:openjade
#OPT:perl-modules#perl-sgmlspm


cd $SOURCE_DIR

URL=http://ftp.postgresql.org/pub/source/v9.5.3/postgresql-9.5.3.tar.bz2

wget -nc http://ftp.postgresql.org/pub/source/v9.5.3/postgresql-9.5.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/postgresql/postgresql-9.5.3.tar.bz2 || wget -nc ftp://ftp.postgresql.org/pub/source/v9.5.3/postgresql-9.5.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/postgresql/postgresql-9.5.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/postgresql/postgresql-9.5.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/postgresql/postgresql-9.5.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/postgresql/postgresql-9.5.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/DEFAULT_PGSOCKET_DIR/s@/tmp@/run/postgresql@' src/include/pg_config_manual.h &&
./configure --prefix=/usr          \
            --enable-thread-safety \
            --docdir=/usr/share/doc/postgresql-9.5.3 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install      &&
make install-docs

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm700 /srv/pgsql/data &&
install -v -dm755 /run/postgresql &&
groupadd -g 41 postgres &&
useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
        -u 41 postgres &&
chown -Rv postgres:postgres /srv/pgsql /run/postgresql &&
su - postgres -c '/usr/bin/initdb -D /srv/pgsql/data'

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
su - postgres -c '/usr/bin/postgres -D /srv/pgsql/data > \
                  /srv/pgsql/data/logfile 2>&1 &'

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sleep 5
clear



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
su - postgres -c '/usr/bin/createdb test' &&
echo "create table t1 ( name varchar(20), state_province varchar(20) );" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Billy', 'NewYork');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Evanidus', 'Quebec');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Jesse', 'Ontario');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "select * from t1;" | (su - postgres -c '/usr/bin/psql test')

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.07/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-postgresql

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "postgresql=>`date`" | sudo tee -a $INSTALLED_LIST
