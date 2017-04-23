#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak This is an old version of llvm,br3ak installed in /opt so that <a class=\"xref\" href=\"rust.html\" title=\"Rustc-1.16.0\">rustc-1.16.0</a> can use it. For normal use youbr3ak should install <a class=\"xref\" href=\"llvm.html\" title=\"LLVM-4.0.0\">LLVM-4.0.0</a>.br3ak"
SECTION="general"
VERSION=3.9.1
NAME="llvm-old"

#REQ:cmake
#REC:python2
#OPT:doxygen
#OPT:graphviz
#OPT:libffi
#OPT:rust
#OPT:libxml2
#OPT:texlive
#OPT:tl-installer
#OPT:valgrind
#OPT:zip


cd $SOURCE_DIR

URL=http://llvm.org/releases/3.9.1/llvm-3.9.1.src.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-3.9.1.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-3.9.1.src.tar.xz || wget -nc http://llvm.org/releases/3.9.1/llvm-3.9.1.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/llvm-3.9.1.src.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/llvm/llvm-3.9.1.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-3.9.1.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-3.9.1.src.tar.xz

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

mkdir -v build                           &&
cd       build                           &&
CC=gcc CXX=g++                           \
cmake -DCMAKE_INSTALL_PREFIX=/opt/llvm3  \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLLVM_BUILD_LLVM_DYLIB=ON         \
      -DLLVM_LINK_LLVM_DYLIB=ON          \
      -DLLVM_TARGETS_TO_BUILD="host"     \
      -DLLVM_INSTALL_UTILS=ON            \
      -Wno-dev ..                        &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "/opt/llvm3/lib" >> /etc/ld.so.conf &&
make install                             &&
ldconfig                                 &&
ln -sfv /opt/llvm3/bin/FileCheck /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
