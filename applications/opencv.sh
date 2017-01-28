#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The opencv package containsbr3ak graphics libraries mainly aimed at real-time computer vision.br3ak"
SECTION="general"
VERSION=3.2.0
NAME="opencv"

#REQ:cmake
#REQ:unzip
#REC:ffmpeg
#REC:gst10-plugins-base
#REC:gtk3
#REC:jasper
#REC:libjpeg
#REC:libpng
#REC:libtiff
#REC:libwebp
#REC:python2
#REC:v4l-utils
#REC:xine-lib
#OPT:apache-ant
#OPT:doxygen
#OPT:java
#OPT:python3


cd $SOURCE_DIR

URL=http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.2.0/opencv-3.2.0.zip

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/opencv/opencv-3.2.0.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/opencv/opencv-3.2.0.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/opencv/opencv-3.2.0.zip || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/opencv/opencv-3.2.0.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/opencv/opencv-3.2.0.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/opencv/opencv-3.2.0.zip || wget -nc http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.2.0/opencv-3.2.0.zip
wget -nc https://raw.githubusercontent.com/opencv/opencv_3rdparty/81a676001ca8075ada498583e4166079e5744668/ippicv/ippicv_linux_20151201.tgz
wget -nc https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz

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

wget https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz \
     -O opencv_contrib-3.2.0.tar.gz


ipp_file=../ippicv_linux_20151201.tgz             &&
ipp_hash=$(md5sum $ipp_file | cut -d" " -f1)      &&
ipp_dir=3rdparty/ippicv/downloads/linux-$ipp_hash &&
mkdir -p $ipp_dir &&
cp $ipp_file $ipp_dir


tar xf ../opencv_contrib-3.2.0.tar.gz


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr      \
      -DWITH_XINE=ON                   \
      -DBUILD_TESTS=OFF                \
      -DENABLE_PRECOMPILED_HEADERS=OFF \
      -Wno-dev  ..                     &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install             &&
case $(uname -m) in
  x86_64) ARCH=intel64 ;;
       *) ARCH=ia32    ;;
esac                     &&
cp -v 3rdparty/ippicv/ippicv_lnx/lib/$ARCH/libippicv.a /usr/lib &&
unset ARCH

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
