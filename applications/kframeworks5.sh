#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="kframeworks5"
DESCRIPTION="KDE Frameworks 5 is a collection of libraries based on top of Qt5 and QML derived from the monolithic KDE 4 libraries."
VERSION=5.30

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
#OPT:oxygen-fonts
#OPT:noto-fonts
#OPT:doxygen
#OPT:jasper
#OPT:mitkrb
#OPT:udisks2
#OPT:upower


cd $SOURCE_DIR

whoami > /tmp/currentuser
commonBinDir="/var/cache/alps/binaries/"

url=http://download.kde.org/stable/frameworks/$VERSION/
wget -nc -r -nH --cut-dirs=3 -A '*.xz' -np $url


cat > frameworks-$VERSION.0.md5 << EOF
e632a0f2f13615ca961b0a24f3322b58 attica-$VERSION.0.tar.xz
#3c04b695a164407a2a2fcaf848c42c55 extra-cmake-modules-$VERSION.0.tar.xz
3ed25b2b4393a107da6981cee61ddc14 kapidox-$VERSION.0.tar.xz
7d21c57bebdd6800143c1b03b4f9b4c3 karchive-$VERSION.0.tar.xz
4c8488c88285761578bb4d384cb54ada kcodecs-$VERSION.0.tar.xz
2b822e9e4549fd2deffc23468af461e1 kconfig-$VERSION.0.tar.xz
d808f36a8dfa14dd9300d3e0f76b69aa kcoreaddons-$VERSION.0.tar.xz
0805d1dee82cf6d627dbdf2872bbbb00 kdbusaddons-$VERSION.0.tar.xz
8a822dd18517a2ed38bdf5bb0d546c5d kdnssd-$VERSION.0.tar.xz
e910e142696eec33aec7f57fce6efba5 kguiaddons-$VERSION.0.tar.xz
eee903d5ed5575487769403a4979c016 ki18n-$VERSION.0.tar.xz
544c074d621f047ab42f91cc5ef1972d kidletime-$VERSION.0.tar.xz
8231b9fe98138f407b00f7cc011febca kimageformats-$VERSION.0.tar.xz
f80e094e554cb59ea92c2725c6d565ec kitemmodels-$VERSION.0.tar.xz
392f5aca94090ff7a2c71cd6c4e3352f kitemviews-$VERSION.0.tar.xz
4acdf183309dfbee324dfae7f2169cf5 kplotting-$VERSION.0.tar.xz
d218ec2b2e7264fbd0cb631f77bbd70f kwidgetsaddons-$VERSION.0.tar.xz
a94136e4f5af55dab34929fc5521d115 kwindowsystem-$VERSION.0.tar.xz
08b9e2476be272cd2dd2a0b3380abeea networkmanager-qt-$VERSION.0.tar.xz
ed66c1e1e9cb1dcb06e037aa0d2b5d55 solid-$VERSION.0.tar.xz
a557695b926c0857a4aba81c43879242 sonnet-$VERSION.0.tar.xz
b7afffde55f36e3878a2e9ccbd70989c threadweaver-$VERSION.0.tar.xz
1e41eae5f42f03b2de331460f280a327 kauth-$VERSION.0.tar.xz
c06fe622e9297d3a4dd8695b2f79670e kcompletion-$VERSION.0.tar.xz
8f4efc958c5f820399d2620abd4f5b39 kcrash-$VERSION.0.tar.xz
4db500f1850f6138172249ba4fabd926 kdoctools-$VERSION.0.tar.xz
458cc1bc560be08c3a706049bf037918 kpty-$VERSION.0.tar.xz
d2423ba06bfacd9f5d25f9704c3cbdd9 kunitconversion-$VERSION.0.tar.xz
5f5f18e3425775f38b24422a8e9675bb kconfigwidgets-$VERSION.0.tar.xz
73e64bb284dfa301d78a778bb549461e kservice-$VERSION.0.tar.xz
88e64bb284dfa301d78a778bb549461e kglobalaccel-$VERSION.0.tar.xz
c7e6bb3a9141b86b0791f9a949156ec1 kpackage-$VERSION.0.tar.xz
d0642716404ae604d6db198139ce20f7 kservice-$VERSION.0.tar.xz
628bd240ca7b69ab64ead67a95fd11f3 kdesu-$VERSION.0.tar.xz
0e56a38f94975ff508536206f9a3fcb9 kemoticons-$VERSION.0.tar.xz
da801d2c0556759497075c725919c193 kiconthemes-$VERSION.0.tar.xz
5d11070cecef697c44b13fa5f9c3a925 kjobwidgets-$VERSION.0.tar.xz
7ad46c7baf13d98e710bff847d75891f knotifications-$VERSION.0.tar.xz
0f462365b296549e05de2159f18dd3e2 ktextwidgets-$VERSION.0.tar.xz
37715313db7117da3eabc163ce8c9f0b kwallet-$VERSION.0.tar.xz
e8b47c782e7d30b4c363187c9a1a72b9 kxmlgui-$VERSION.0.tar.xz
63c5aa00974e3fd95bfd742c4e90e3bc kbookmarks-$VERSION.0.tar.xz
cad4e5542bec99a3b264b06988193195 kio-$VERSION.0.tar.xz
3de69c04bffcb050ac3f96b510229527 kdeclarative-$VERSION.0.tar.xz
1d4043e0d21472c32619f066402190a0 kcmutils-$VERSION.0.tar.xz
2ac172c3af820c701e8e144e7f9d35db knewstuff-$VERSION.0.tar.xz
16af94413983986c36a3a2b9279a3b7b frameworkintegration-$VERSION.0.tar.xz
4072959e05d8a561fca95919fc8fad18 kinit-$VERSION.0.tar.xz
b2e4a68bff24fd7cc4cb500af53fcd61 knotifyconfig-$VERSION.0.tar.xz
6a82c4f8b69ae6d28d74ed795865c248 kparts-$VERSION.0.tar.xz
85af6c7eab34592872a85c9559ed1b36 kactivities-$VERSION.0.tar.xz
b6731516ccfad1149a8b9c0f818d39d6 kded-$VERSION.0.tar.xz
9799a785217ea8877f288348cce72c0f kdewebkit-$VERSION.0.tar.xz
b7dd9344c55b392ea0d7fc79935e14af ktexteditor-$VERSION.0.tar.xz
fe1ec30258eb149d21c9f649b72a8f1a kdesignerplugin-$VERSION.0.tar.xz
ff844df8d38596734e541a0c53131e32 plasma-framework-$VERSION.0.tar.xz
#b3c61320b50e06b9e3919d10d45229f7 modemmanager-qt-$VERSION.0.tar.xz
32e94125a4e4f559fa70d6855b5d98a7 kpeople-$VERSION.0.tar.xz
0124ecbcda55655ae893f49626b7c35c kxmlrpcclient-$VERSION.0.tar.xz
a7c7afc02a3842119607c62f2f1191b2 bluez-qt-$VERSION.0.tar.xz
4aef6d8fbce1de5906c31318a0dd8e95 kfilemetadata-$VERSION.0.tar.xz
6280369bf13d595f4d951bcab59663ff baloo-$VERSION.0.tar.xz
#ec81600d6dd3059b694827a988cfce95 breeze-icons-$VERSION.0.tar.xz
#0c5375eaba2e68bb2ef046d303de221e oxygen-icons5-$VERSION.0.tar.xz
179ba5f3e126f04461df16c44a6cf0dc kactivities-stats-$VERSION.0.tar.xz
5b3cadf4d586d15729b97b8c152e82b7 krunner-$VERSION.0.tar.xz
8645b010fe6a30c374723cba26266e67 kwayland-$VERSION.0.tar.xz
dbe8d5a37f7f758f36d576b4d8a94126 portingAids/kjs-$VERSION.0.tar.xz
67dc7c5cad0b9a18c53e359878fe183a portingAids/kdelibs4support-$VERSION.0.tar.xz
6a913fe17e44b24291be9aa0f7d3a45e portingAids/khtml-$VERSION.0.tar.xz
4b818b430015981c40a99a638e025e40 portingAids/kjsembed-$VERSION.0.tar.xz
e639b1bfeb1f40f8e11dde2163fdd5ea portingAids/kmediaplayer-$VERSION.0.tar.xz
d25f3dde5af8bd50021f6165fbef6461 portingAids/kross-$VERSION.0.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


export KF5_PREFIX=/opt/kf5
export QT5DIR=/opt/qt5

sudo tee /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh

export KF5_PREFIX=/opt/kf5
export QT5DIR=/opt/qt5
pathappend $KF5_PREFIX/bin             PATH
pathappend $KF5_PREFIX/lib/pkgconfig   PKG_CONFIG_PATH
pathappend /etc/xdg                    XDG_CONFIG_DIRS
pathappend $KF5_PREFIX/etc/xdg         XDG_CONFIG_DIRS
pathappend /usr/share                  XDG_DATA_DIRS
pathappend $KF5_PREFIX/share           XDG_DATA_DIRS
pathappend $KF5_PREFIX/lib/plugins     QT_PLUGIN_PATH
pathappend $KF5_PREFIX/lib/qml         QML2_IMPORT_PATH
pathappend $KF5_PREFIX/lib/python2.7/site-packages PYTHONPATH

# End /etc/profile.d/kf5.sh
EOF

sudo tee -a /etc/profile.d/qt5.sh << "EOF"
# Begin Qt5 changes for KF5

pathappend $QT5DIR/plugins             QT_PLUGIN_PATH
pathappend $QT5DIR/qml                 QML2_IMPORT_PATH

# End Qt5 changes for KF5
EOF

sudo tee -a /etc/ld.so.conf << "EOF"
# Begin KF5 addition

/opt/kf5/lib

# End KF5 addition
EOF

export KF5_PREFIX=/opt/kf5
export QT5DIR=/opt/qt5

pathappend $KF5_PREFIX/bin             PATH
pathappend $KF5_PREFIX/lib/pkgconfig   PKG_CONFIG_PATH
pathappend /etc/xdg                    XDG_CONFIG_DIRS
pathappend $KF5_PREFIX/etc/xdg         XDG_CONFIG_DIRS
pathappend /usr/share                  XDG_DATA_DIRS
pathappend $KF5_PREFIX/share           XDG_DATA_DIRS
pathappend $KF5_PREFIX/lib/plugins     QT_PLUGIN_PATH
pathappend $KF5_PREFIX/lib/qml         QML2_IMPORT_PATH
pathappend $KF5_PREFIX/lib/python2.7/site-packages PYTHONPATH
pathappend $QT5DIR/plugins             QT_PLUGIN_PATH
pathappend $QT5DIR/qml                 QML2_IMPORT_PATH


sudo install -v -dm755           $KF5_PREFIX/{etc,share} &&
sudo ln -sfv /etc/dbus-1         $KF5_PREFIX/etc         &&
sudo ln -sfv /usr/share/dbus-1   $KF5_PREFIX/share
sudo install -v -dm755                $KF5_PREFIX/share/icons &&
sudo ln -sfv /usr/share/icons/hicolor $KF5_PREFIX/share/icons

export KF5_PREFIX=/opt/kf5
export QT5DIR=/opt/qt5


touch /tmp/completed
while read -r line; do
    if ! grep $line /tmp/completed
    then
      # Get the file name, ignoring comments and blank lines
      if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
      file=$(echo $line | cut -d" " -f2)
      pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
      packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory
      tar -xf $file
      pushd $packagedir
        mkdir build
        cd    build
        cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
              -DCMAKE_PREFIX_PATH=$QT5DIR        \
              -DCMAKE_BUILD_TYPE=Release         \
              -DLIB_INSTALL_DIR=lib              \
              -DBUILD_TESTING=OFF                \
              -Wno-dev ..
        make "-j`nproc`"
        as_root make install
    popd
    as_root rm -rf $packagedir
    as_root /sbin/ldconfig
    echo $line >> /tmp/completed
  fi
done < frameworks-$VERSION.0.md5

sudo mv -v /opt/kf5 /opt/kf5-$VERSION.0
sudo ln -sfvn kf5-$VERSION.0 /opt/kf5


cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
