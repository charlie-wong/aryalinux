#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Cargo is the Package Manager forbr3ak Rust. Like that, during the buildbr3ak it uses <span class=\"command\"><strong>curl</strong> tobr3ak download <code class=\"filename\">cargo files which arebr3ak actually <code class=\"filename\">.tar.gz source archives.br3ak"
SECTION="general"
VERSION=null
NAME="cargo"

#REQ:cmake
#REQ:rust
#OPT:git
#OPT:openssl


cd $SOURCE_DIR

URL=https://github.com/rust-lang/cargo/archive/0.17.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/rust-lang/cargo/archive/0.17.0.tar.gz
wget -nc http://anduin.linuxfromscratch.org/BLFS/rust/rust-installer-20161004.tar.xz
wget -nc https://static.rust-lang.org/dist/cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cargo/cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cargo/cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cargo/cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cargo/cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cargo/cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cargo/cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cargo/cargo-0.16.0-i686-unknown-linux-gnu.tar.gz || wget -nc https://static.rust-lang.org/dist/cargo-0.16.0-i686-unknown-linux-gnu.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cargo/cargo-0.16.0-i686-unknown-linux-gnu.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cargo/cargo-0.16.0-i686-unknown-linux-gnu.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cargo/cargo-0.16.0-i686-unknown-linux-gnu.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cargo/cargo-0.16.0-i686-unknown-linux-gnu.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cargo/cargo-0.16.0-i686-unknown-linux-gnu.tar.gz

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

wget https://github.com/rust-lang/cargo/archive/0.17.0.tar.gz \
     -O cargo-0.17.0.tar.gz


pushd src/rust-installer                        &&
tar -xf ../../../rust-installer-20161004.tar.xz \
 --strip-components=1                           &&
popd                                            &&
case $(uname -m) in
    x86_64) tar -xf ../cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz
    ;;
    i686) tar -xf ../cargo-0.16.0-i686-unknown-linux-gnu.tar.gz
    ;;
esac                                            &&
./configure --prefix=/usr --sysconfdir=/etc     \
  --docdir=/usr/share/doc/cargo-0.17.0          \
  --cargo=./cargo-nightly*/cargo/bin/cargo      &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                                  &&
mv -v /usr/etc/bash_completion.d/cargo /etc/bash_completion.d

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
