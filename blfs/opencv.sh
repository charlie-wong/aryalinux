#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:opencv:3.1.0
#VER:ippicv_linux_:20151201

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

URL=http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.1.0/opencv-3.1.0.zip

wget -nc https://raw.githubusercontent.com/Itseez/opencv_3rdparty/81a676001ca8075ada498583e4166079e5744668/ippicv/ippicv_linux_20151201.tgz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/opencv/opencv-3.1.0.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/opencv/opencv-3.1.0.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/opencv/opencv-3.1.0.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/opencv/opencv-3.1.0.zip || wget -nc http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.1.0/opencv-3.1.0.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/opencv/opencv-3.1.0.zip

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=''
unzip_dirname $TARBALL DIRECTORY

unzip_file $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

ipp_file=../ippicv_linux_20151201.tgz             &&
ipp_hash=$(md5sum $ipp_file | cut -d" " -f1)      &&
ipp_dir=3rdparty/ippicv/downloads/linux-$ipp_hash &&
mkdir -p $ipp_dir &&
cp $ipp_file $ipp_dir


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DWITH_XINE=ON              \
      -DBUILD_TESTS=OFF           \
      -Wno-dev  ..
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install               &&
mv -v /usr/share/OpenCV/3rdparty/lib/libippicv.a /usr/lib &&
rm -rv /usr/share/OpenCV/3rdparty

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "opencv=>`date`" | sudo tee -a $INSTALLED_LIST
