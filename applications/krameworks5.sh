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

url=http://download.kde.org/stable/frameworks/5.31/
wget -r -nH --cut-dirs=3 -A '*.xz' -np $url


cat > frameworks-5.31.0.md5 << "EOF"
2243e955a41b8a5036fb8d0e497342f5 attica-5.31.0.tar.xz
#74d7c29138168f9a62fe475705c0b351 extra-cmake-modules-5.31.0.tar.xz
b846e442fd48b8387f93aa37295e9f7c kapidox-5.31.0.tar.xz
de591b1902b1721b74762d712f13a265 karchive-5.31.0.tar.xz
8e0c15990e84dfcfc5c85a88e2e0319b kcodecs-5.31.0.tar.xz
f044848c2406fa1452b11780af2e1fea kconfig-5.31.0.tar.xz
95935748baf5465f150f4e1a94af1923 kcoreaddons-5.31.0.tar.xz
c6c8f751eff1f03406f63bcfb1f4ffe0 kdbusaddons-5.31.0.tar.xz
5ee257c5ff53d5551b9df1b640cfabf6 kdnssd-5.31.0.tar.xz
ecb1a10910116e9fd3265f2f1908c6a1 kguiaddons-5.31.0.tar.xz
62457f60936bb8dc6649ed362e7ab80a ki18n-5.31.0.tar.xz
c45511be577726afd5c7d88c7f13f274 kidletime-5.31.0.tar.xz
99cbfa14df2fb11930090122b461bc6a kimageformats-5.31.0.tar.xz
91916337e5a8edf9fca9de3bdd1ad8fa kitemmodels-5.31.0.tar.xz
71251518337febe21cd0af8e7db66fae kitemviews-5.31.0.tar.xz
e36ccf164785957e07d03cddef152136 kplotting-5.31.0.tar.xz
3ff1ee177df63262636954cb7e0460dc kwidgetsaddons-5.31.0.tar.xz
cd402e03c023354e9ee37b7d0d5de621 kwindowsystem-5.31.0.tar.xz
8c4d807e867f11f5a55604fa59cce85d networkmanager-qt-5.31.0.tar.xz
2946f8c7780e2f3de5384717a8a34cdc solid-5.31.0.tar.xz
11cef5b5016def5298b64e2ce561a8b5 sonnet-5.31.0.tar.xz
f1dbc18f38a9582cd1d4f94bc9f0f132 threadweaver-5.31.0.tar.xz
ec49b90d1566a37e91b9710557e102f2 kauth-5.31.0.tar.xz
81234f797d4da26106a91bdcc34440df kcompletion-5.31.0.tar.xz
a0cffc08aa51c61d48d9e25778a61e62 kcrash-5.31.0.tar.xz
fc1b4de766d04ac3abc87050588d083d kdoctools-5.31.0.tar.xz
8f5efa781672c67f01195ee3dc823c6b kpty-5.31.0.tar.xz
0f7be81fe9c68044f20d6c297a624558 kunitconversion-5.31.0.tar.xz
4deb8a01f99cb16bbcf80f1e11d90824 kconfigwidgets-5.31.0.tar.xz
b46d2550b689fc818064f69cb1db29a7 kservice-5.31.0.tar.xz
d56e35255d2697cc3a89a1a99d1821fe kglobalaccel-5.31.0.tar.xz
9d66b0fe531892180006f0deb77aa4b2 kpackage-5.31.0.tar.xz
9a593607c47472dd6ce0d546b2f2a736 kdesu-5.31.0.tar.xz
4c8d3ab1e358efd89acd7ab95025dd37 kemoticons-5.31.0.tar.xz
fa2e0994412b83dbb0e54aa277f4bff3 kiconthemes-5.31.0.tar.xz
cc2f41fd5b8ba6ad795a7835a68d4e8c kjobwidgets-5.31.0.tar.xz
b8483a6872720152acfb22dae0db417e knotifications-5.31.0.tar.xz
a3240501f842655be3b354d98da95939 ktextwidgets-5.31.0.tar.xz
de28f21c121dc24f31d35ab622304e7e kxmlgui-5.31.0.tar.xz
8c1d5970b25f877567494486638d6082 kbookmarks-5.31.0.tar.xz
3372c17e1a0020616fea29ec9097e0cc kwallet-5.31.0.tar.xz
62f31e7a9cd0b875fce5b552ec9be3c7 kio-5.31.0.tar.xz
8b76f1704314258a944eb57a466d338d kdeclarative-5.31.0.tar.xz
eccc7474f7442b656d26211050f3b2c3 kcmutils-5.31.0.tar.xz
2df293c8e3cedd3a7b71af69045dc5a0 knewstuff-5.31.0.tar.xz
128fa26a3e7928ae74db95ee774fcf48 frameworkintegration-5.31.0.tar.xz
8cf1b185c3d5b74a168995f8e0747931 kinit-5.31.0.tar.xz
a8fdfb88286f73485734ad2feecb7e16 knotifyconfig-5.31.0.tar.xz
21849d002c27964c0d264aa9b5a7c67d kparts-5.31.0.tar.xz
31f9bd0f380f60b0ab2e9b8f56b1662a kactivities-5.31.0.tar.xz
569c52fc5424b1c58fc0476ffa02b58b kded-5.31.0.tar.xz
d063b3b7827eaaa8e345ebaf6c1500f9 kdewebkit-5.31.0.tar.xz
302e06bd05b8632fe60702c82218d1eb syntax-highlighting-5.31.0.tar.xz
315aae6b286757696513ecc7ca69e68e ktexteditor-5.31.0.tar.xz
89a054526209180e02b87b30b8766f5f kdesignerplugin-5.31.0.tar.xz
3ba021780eb40fadd3472630be680571 kwayland-5.31.0.tar.xz
cbef982888a30ca96b4c1f52d502551c plasma-framework-5.31.0.tar.xz
#ac454faa59de5fb2c5f995acd71fd769 modemmanager-qt-5.31.0.tar.xz
6eaf7bd9165a7042221926064c01cce9 kpeople-5.31.0.tar.xz
c1cd0538b4f7e56653a4d6d4f2c994a2 kxmlrpcclient-5.31.0.tar.xz
2e2dfc3e49d878044c4848d147918d1b bluez-qt-5.31.0.tar.xz
b0553bbd667d7d209735d2123f33af46 kfilemetadata-5.31.0.tar.xz
831874cc5f6bf3aab76ca196d30995b3 baloo-5.31.0.tar.xz
#f16a9b1a901700ecd0790e3d80ae32d4 breeze-icons-5.31.0.tar.xz
#385ddb6e36639dfffb0bf30b75b049e0 oxygen-icons5-5.31.0.tar.xz
cd4290e76d0c07a3612b82257119a4df kactivities-stats-5.31.0.tar.xz
6105cf1f51b69cd9232aa662f8d2511a krunner-5.31.0.tar.xz
#95cb43eb20e081db51709b0ab6bcfa96 prison-5.31.0.tar.xz
71ec95ef3c79e2a86de4872bb97daa0e portingAids/kjs-5.31.0.tar.xz
aa244aa083a03be78a976a8a8cd6ed8c portingAids/kdelibs4support-5.31.0.tar.xz
21a3859d1358a330fbdb83f3c184dd71 portingAids/khtml-5.31.0.tar.xz
49f65f405b4e3d49adf81247efce963f portingAids/kjsembed-5.31.0.tar.xz
f287ac1073cae07f51178ad78f30cf4b portingAids/kmediaplayer-5.31.0.tar.xz
743b48d58b23d386e4417081a4d456cb portingAids/kross-5.31.0.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5.old                         &&
install -v -dm755           /opt/kf5/{etc,share} &&
ln -sfv /etc/dbus-1         /opt/kf5/etc         &&
ln -sfv /usr/share/dbus-1   /opt/kf5/share

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


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
            -DBUILD_TESTING=OFF                \
            -Wno-dev ..
      make "-j`nproc`" || make
      as_root make install
  popd
  as_root rm -rf $packagedir
  as_root /sbin/ldconfig
done < frameworks-5.31.0.md5
exit



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5-5.31.0
ln -sfvn kf5-5.31.0 /opt/kf5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
