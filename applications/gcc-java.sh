#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak See the introduction to the Java language and system at <a class=\"xref\" href=\"java.html\" title=\"Java-1.8.0.121\">Java-1.8.0.121</a>.br3ak The GNU Compiler Collection (GCC) contains a Java compiler tobr3ak native code. Together with the ecjbr3ak Java compiler from Eclipse (to bytecode), it provides a way tobr3ak build an acceptable JVM from source. However, since the release ofbr3ak OpenJDK, the development ofbr3ak GCC-Java has almost stopped, and the built JVM is an old version,br3ak which cannot be used for building <a class=\"xref\" href=\"openjdk.html\" title=\"OpenJDK-1.8.0.121\">OpenJDK-1.8.0.121</a>.br3ak"
SECTION="general"
VERSION=6.3.0
NAME="gcc-java"

#REQ:unzip
#REQ:general_which
#REQ:zip
#REC:dejagnu
#OPT:gtk2


cd $SOURCE_DIR

URL=http://ftpmirror.gnu.org/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcc/gcc-6.3.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gcc/gcc-6.3.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gcc/gcc-6.3.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gcc/gcc-6.3.0.tar.bz2 || wget -nc http://ftpmirror.gnu.org/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gcc/gcc-6.3.0.tar.bz2 || wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcc/gcc-6.3.0.tar.bz2

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

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
sed -i 's/\(install.*:\) install-.*recursive/\1/' libffi/Makefile.in         &&
sed -i 's/\(install-data-am:\).*/\1/'             libffi/include/Makefile.in &&
sed -i 's/absolute/file normalize/' libjava/testsuite/lib/libjava.exp &&
sed -i 's/major.*1000.*minor/major/' gcc/java/decl.c &&
cp ../ecj-4.9.jar ./ecj.jar &&
mkdir build &&
cd    build &&
../configure                     \
    --prefix=/usr                \
    --disable-multilib           \
    --with-system-zlib           \
    --disable-bootstrap          \
    --enable-java-home           \
    --with-jvm-root-dir=/opt/gcj \
    --with-antlr-jar=$(pwd)/../../antlr-4.6-complete.jar \
    --enable-languages=java &&
make "-j`nproc`" || make


ulimit -s 32768 &&
make -k check


../contrib/test_summary



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/gdb/auto-load/usr/lib              &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib &&
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/6.3.0/include{,-fixed} &&
gcj -o ecj ../../ecj-4.9.jar \
    --main=org.eclipse.jdt.internal.compiler.batch.Main &&
mv ecj /usr/bin &&
ln -sfv ../../../usr/bin/ecj /opt/gcj/bin/javac

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
