#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Xorg's ancestor (X11R1, in 1987)br3ak at first only provided bitmap fonts, with a tool (<span class=\"command\"><strong>bdftopcf</strong>) to assist in theirbr3ak installation. With the introduction of xorg-server-1.19.0 and libXfont2 many people will not need them.br3ak There are still a few old packages which might require, or benefitbr3ak from, these deprecated fonts and so the following packages arebr3ak shown here.br3ak"
SECTION="x"
NAME="x7legacy"

#REQ:xcursor-themes
#OPT:xmlto
#OPT:fop
#OPT:links
#OPT:lynx
#OPT:w3m


cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

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
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

cat > legacy.dat << "EOF"
254ee42bd178d18ebc7a73aacfde7f79 lib/ libXfont-1.5.2.tar.bz2
53a48e1fdfec29ab2e89f86d4b7ca902 app/ bdftopcf-1.0.5.tar.bz2
1347c3031b74c9e91dc4dfa53b12f143 font/ font-adobe-100dpi-1.0.3.tar.bz2
EOF


mkdir legacy &&
cd legacy &&
grep -v '^#' ../legacy.dat | awk '{print $2$3}' | wget -i- -c \
     -B http://ftp.x.org/pub/individual/ &&
grep -v '^#' ../legacy.dat | awk '{print $1 " " $3}' > ../legacy.md5 &&
md5sum -c ../legacy.md5


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root





for package in $(grep -v '^#' ../legacy.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
  case $packagedir in
    libXfont-[0-9]* )
      ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --disable-devel-docs
    ;;
    * )
      ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static
    ;;
  esac
  make "-j`nproc`" || make
  as_root make install
  popd
  rm -rf $packagedir
  as_root /sbin/ldconfig
done







if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
