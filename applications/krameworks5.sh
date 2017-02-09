#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="kde"
NAME="krameworks5"

#REQ:boost
#REQ:extra-cmake-modules
#REQ:docbook
#REQ:docbook-xsl
#REQ:giflib
#REQ:libepoxy
#REQ:libgcrypt
#REQ:libjpeg
#REQ:libpng
#REQ:libxslt
#REQ:lmdb
#REQ:qtwebkit5
#REQ:phonon
#REQ:shared-mime-info
#REQ:perl-modules#perl-uri
#REQ:wget
#REC:aspell
#REC:avahi
#REC:libdbusmenu-qt
#REC:networkmanager
#REC:polkit-qt
#OPT:bluez
#OPT:ModemManager
#OPT:TTF-and-OTF-fonts#oxygen-fonts
#OPT:TTF-and-OTF-fonts#noto-fonts
#OPT:doxygen
#OPT:python-modules#Jinja2
#OPT:python-modules#PyYAML
#OPT:jasper
#OPT:mitkrb
#OPT:udisks2
#OPT:upower


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

url=http://download.kde.org/stable/frameworks/5.28/
wget -r -nH --cut-dirs=3 -A '*.xz' -np $url


cat > frameworks-5.28.0.md5 << "EOF"
57747b2044d294410d3234b38ba024bd attica-5.28.0.tar.xz
#c8b07337cc3c72a55ec40267f1b3eec4 extra-cmake-modules-5.28.0.tar.xz
18519cc78af2bec9be69fbb885a52c22 kapidox-5.28.0.tar.xz
e11421e5fbc0bd4aa768a453721bef2e karchive-5.28.0.tar.xz
23ef0ce233866abda9cfbcf5f3de4f6e kcodecs-5.28.0.tar.xz
bbc99940debba203c8d7ddb8a82ce95b kconfig-5.28.0.tar.xz
92547554a46ca8b301a8a357ae466eab kcoreaddons-5.28.0.tar.xz
a3fd10031c5b2a27da76c2c8c07be13e kdbusaddons-5.28.0.tar.xz
c682939017dc4ad5dee2b3e362d40fa0 kdnssd-5.28.0.tar.xz
4e6f0bb250b6a10317358696c1897c78 kguiaddons-5.28.0.tar.xz
0c11fcadac974232c92121a3ae26347b ki18n-5.28.0.tar.xz
f915c788749b3e29b5aae15504beac78 kidletime-5.28.0.tar.xz
2ca4e62b2847035a719ff1d2393d65c6 kimageformats-5.28.0.tar.xz
6b6e6b459ff1f2599c30e1e92bc86b6d kitemmodels-5.28.0.tar.xz
d87fdc67fa7e2f6b63c6303974b27eab kitemviews-5.28.0.tar.xz
76f2b7deac266b598d8c3b52cb4274c5 kplotting-5.28.0.tar.xz
c2e8cf3ca4029548c0e65142d8e8ec2f kwidgetsaddons-5.28.0.tar.xz
9ec46f4818ca71f3bfe37251f66613a9 kwindowsystem-5.28.0.tar.xz
e1f4551e57a2636bca36e9c5b747028d networkmanager-qt-5.28.0.tar.xz
2ff51f7f1b907415dac7022327d04b70 solid-5.28.0.tar.xz
9fe51016d7879cb8fac5fe374491a561 sonnet-5.28.0.tar.xz
947893f8fa572b0d4686958517d5696f threadweaver-5.28.0.tar.xz
7d29a6ce7088215457f2eb0bba7ae616 kauth-5.28.0.tar.xz
0e27db4101ee49f41334c25ad35fd22c kcompletion-5.28.0.tar.xz
6950db605ea79a079c6e062547c7d74b kcrash-5.28.0.tar.xz
dfbfce2f5cf2c395600d7e4c34f775dc kdoctools-5.28.0.tar.xz
8867250588914f30d08b7482239647d1 kpty-5.28.0.tar.xz
b169ee8a9a459341dc592787d2c47b04 kunitconversion-5.28.0.tar.xz
ae734430daf80eb0b3fefcc83668e2f2 kconfigwidgets-5.28.0.tar.xz
a5206a772b64c9031a2e6bf5b4cfe5de kservice-5.28.0.tar.xz
937e93a265ed45d1142f2878ce7d539d kglobalaccel-5.28.0.tar.xz
ee7f38c05409f05eb8a4b05c1777d4a4 kpackage-5.28.0.tar.xz
2c5f01bcaf40e3fe62144721f40f55c1 kdesu-5.28.0.tar.xz
c6330f659f9c70c0c2ed139d07564dc8 kemoticons-5.28.0.tar.xz
37cb76fc6c41c66e90316b1e8caf3420 kiconthemes-5.28.0.tar.xz
49a2be90d1e79e4c69863e882b2dea76 kjobwidgets-5.28.0.tar.xz
e5664b3118e4a3e706e9863fdc7e86cf knotifications-5.28.0.tar.xz
0263527d48768ed6d242f741f00eddea ktextwidgets-5.28.0.tar.xz
409f1ea7882344b2f22ebc67150f91dd kwallet-5.28.0.tar.xz
db6f2ad7f6435605ea04f08bead9e4b3 kxmlgui-5.28.0.tar.xz
ebdfa33e711f88b59a38a988a120b1e4 kbookmarks-5.28.0.tar.xz
eae12791a2c172e04287c24ad47c05f5 kio-5.28.0.tar.xz
c6f5b591df46378194123dd23c7ee626 kdeclarative-5.28.0.tar.xz
5cd7908f7bb316f6c41bf42dfaa33c76 kcmutils-5.28.0.tar.xz
ad82fe1bf8a777995af773eb813cfdb1 frameworkintegration-5.28.0.tar.xz
dea7beb4a98462d0098e7abd6397264f kinit-5.28.0.tar.xz
6a52503325bd02c8b5759e24a829d1bc knewstuff-5.28.0.tar.xz
e70723b9d5a8d44a7cf9df629112099d knotifyconfig-5.28.0.tar.xz
1fe64f811249d9189fa035eeb2f72d4f kparts-5.28.0.tar.xz
bf9d06919523c93f10543d89f9e40d4d kactivities-5.28.0.tar.xz
914e57ee540bf2e154cdc86f962b50ad kded-5.28.0.tar.xz
9fc835dfc5aa9e1d8e79d10d1e2a2e10 kdewebkit-5.28.0.tar.xz
7d524ba30f518a0937c3912475a59a13 ktexteditor-5.28.0.tar.xz
ba8603c7f6f3b3290e19f1f5d3fb3e8c kdesignerplugin-5.28.0.tar.xz
dfa9a794aea1104bb45e17f229b2da8e kwayland-5.28.0.tar.xz
bf213e3cf7628b9433cd21bd47c08d8d plasma-framework-5.28.0.tar.xz
#4c261149dd6b42f7f7af1ae13576e99b modemmanager-qt-5.28.0.tar.xz
2eeadc20378d5e90ae61721b5faa8af4 kpeople-5.28.0.tar.xz
4b51b6442c81cf610e3ddab33033ae16 kxmlrpcclient-5.28.0.tar.xz
8b1e8d615428497ccc90ab7895fb0194 bluez-qt-5.28.0.tar.xz
124115109c5e82c6e2c232c844dc7bf5 kfilemetadata-5.28.0.tar.xz
7ceec01ddeb987823d5db21afde266d6 baloo-5.28.0.tar.xz
#6087ef0e0e6612a1ca978c4ba924a4f4 breeze-icons-5.28.0.tar.xz
#37af44082edb2f1e6151a72d69308485 oxygen-icons5-5.28.0.tar.xz
1285ab8095ca21aa0f7f6a5dade6c1c5 kactivities-stats-5.28.0.tar.xz
0c44e78e610504ee8b2f2e5f040c602c krunner-5.28.0.tar.xz
68221bafb3e5dbf04be6317526d18d2d syntax-highlighting-5.28.0.tar.xz
2d3a4679fe09493144e06abb3b77631d portingAids/kjs-5.28.0.tar.xz
5b75e4d1de4864bdc5464c1f843042a9 portingAids/kdelibs4support-5.28.0.tar.xz
3a2b83c7a996db14c68cd6f6fabfbeec portingAids/khtml-5.28.0.tar.xz
eb6283b11c71a07ecce53cdeb0fa2c93 portingAids/kjsembed-5.28.0.tar.xz
5ae765c335601507361119f924f57fe2 portingAids/kmediaplayer-5.28.0.tar.xz
62a01fce03cb3ef36a39719ab86709e9 portingAids/kross-5.28.0.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


rm -rf /opt/kf5


bash -e


while read -r line; do
    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)
    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory
    tar -xf $file
    pushd $packagedir
      mkdir build
      cd    build
      cmake -DCMAKE_INSTALL_PREFIX=/opt/kf5 \
            -DCMAKE_PREFIX_PATH=/opt/qt5        \
            -DCMAKE_BUILD_TYPE=Release         \
            -DLIB_INSTALL_DIR=lib              \
            -DBUILD_TESTING=OFF                \
            -Wno-dev ..
      make "-j`nproc`" || make
      as_root make install
  popd
  as_root rm -rf $packagedir
  as_root /sbin/ldconfig
done < frameworks-5.28.0.md5
exit


mv -v /opt/kf5 /opt/kf5-5.28.0
ln -sfvn kf5-5.28.0 /opt/kf5




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
