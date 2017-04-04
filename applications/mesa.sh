#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Mesa is an OpenGL compatible 3Dbr3ak graphics library.br3ak"
SECTION="x"
VERSION=17.0.0
NAME="mesa"

#REQ:x7lib
#REQ:libdrm
#REQ:python2
#REC:elfutils
#REC:llvm
#REC:libva-wo-mesa
#REC:libvdpau
#OPT:libgcrypt
#OPT:nettle
#REQ:wayland
#OPT:plasma-all
#OPT:lxqt


cd $SOURCE_DIR

URL=https://mesa.freedesktop.org/archive/17.0.0/mesa-17.0.0.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mesa-17.0.0-add_xdemos-1.patch

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../mesa-17.0.0-add_xdemos-1.patch

EGL_PLATFORMS="drm,x11,wayland"
DRI_DRIVERS="i915,i965,nouveau,r200,radeon,swrast"
GLL_DRV="i915,nouveau,r300,r600,radeonsi,svga,swrast" &&


sed -i "/pthread-stubs/d" configure.ac      &&
sed -i "/seems to be moved/s/^/: #/" bin/ltmain.sh &&
./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'		\
            --prefix=$XORG_PREFIX				\
            --sysconfdir=/etc					\
            --enable-texture-float				\
            --enable-gles1						\
            --enable-gles2						\
            --enable-osmesa						\
            --enable-xa               	    	\
            --enable-gallium-llvm				\
            --enable-llvm-shared-libs			\
            --enable-egl						\
            --enable-shared-glapi				\
            --enable-gbm        	            \
            --enable-nine						\
            --enable-glx						\
            --enable-dri						\
            --enable-dri3						\
            --enable-glx-tls					\
            --enable-vdpau						\
            --with-egl-platforms="$EGL_PLATFORMS" \
            --with-dri-drivers="$DRI_DRIVERS"	\
            --with-gallium-drivers=$GLL_DRV &&
unset GLL_DRV &&
make "-j`nproc`" || make


make -C xdemos DEMOS_PREFIX=$XORG_PREFIX



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C xdemos DEMOS_PREFIX=$XORG_PREFIX install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/mesa-17.0.0 &&
cp -rfv docs/* /usr/share/doc/mesa-17.0.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
