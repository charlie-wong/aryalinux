#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Flash Player is a multi-platformbr3ak client runtime to view and interact with SWF content, distributedbr3ak as a browser plugin for both NPAPI (Gecko and WebKit) and PPAPIbr3ak (Blink) based browsers.br3ak"
SECTION="multimedia"
VERSION=86_64
NAME="flashplayer"

#REQ:cairo
#REQ:curl
#REQ:graphite2
#REQ:gtk2
#REQ:libffi
#REQ:pcre
#REQ:mesa
#REQ:nss
#OPT:epiphany
#OPT:firefox
#OPT:libreoffice
#OPT:midori
#OPT:seamonkey
#OPT:thunderbird
#OPT:chromium
#OPT:qupzilla


cd $SOURCE_DIR

URL=https://fpdownload.adobe.com/pub/flashplayer/pdc/25.0.0.148/flash_player_npapi_linux.x86_64.tar.gz

if [ ! -z $URL ]
then
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/25.0.0.148/flash_player_npapi_linux.x86_64.tar.gz
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/25.0.0.148/flash_player_npapi_linux.i386.tar.gz
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/25.0.0.148/flash_player_ppapi_linux.x86_64.tar.gz
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/25.0.0.148/flash_player_ppapi_linux.i386.tar.gz
wget -nc https://github.com/foutrelis/chromium-launcher/archive/v3.tar.gz

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

wget https://github.com/foutrelis/chromium-launcher/archive/v3.tar.gz \
     -O chromium-launcher-v3.tar.gz


mkdir flashplayer &&
cd flashplayer    &&
case $(uname -m) in
    x86_64) tar -xf ../flash_player_npapi_linux.x86_64.tar.gz
    ;;
    x86) tar -xf ../flash_player_npapi_linux.i386.tar.gz
    ;;
esac



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vDm755 libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


mkdir flashplayer &&
cd flashplayer    &&
case $(uname -m in
    x86_64) tar -xf ../flash_player_ppapi_linux.x86_64.tar.gz
    ;;
    x86) tar -xf ../flash_player_ppapi_linux.i386.tar.gz
    ;;
esac



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vDm755 libpepflashplayer.so /usr/lib/PepperFlash/libpepflashplayer.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf chromium-launcher-3.tar.gz &&
cd chromium-launcher-3             &&
make PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /usr/bin/chromium /usr/bin/chromium-orig &&
make PREFIX=/usr install-strip

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
