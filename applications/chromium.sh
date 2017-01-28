#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Chromium is an open-source browserbr3ak project that aims to build a safer, faster, and more stable way forbr3ak all users to experience the web.br3ak"
SECTION="xsoft"
VERSION=55.0.2883.87
NAME="chromium"

#REQ:alsa-lib
#REQ:cups
#REQ:desktop-file-utils
#REQ:dbus
#REQ:perl-modules#perl-file-basedir
#REQ:gtk2
#REQ:hicolor-icon-theme
#REQ:mitkrb
#REQ:mesa
#REQ:ninja
#REQ:nss
#REQ:python2
#REQ:usbutils
#REQ:xorg-server
#REC:flac
#REC:git
#REC:libevent
#REC:libexif
#REC:libsecret
#REC:libwebp
#REC:pciutils
#REC:pulseaudio
#REC:xdg-utils
#REC:yasm
#OPT:ffmpeg
#OPT:GConf
#OPT:gnome-keyring
#OPT:icu
#OPT:libjpeg
#OPT:libpng
#OPT:libxml2
#OPT:libvpx


cd $SOURCE_DIR

URL=https://commondatastorage.googleapis.com/chromium-browser-official/chromium-55.0.2883.87.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/chromium/chromium-55.0.2883.87.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/chromium/chromium-55.0.2883.87.tar.xz || wget -nc https://commondatastorage.googleapis.com/chromium-browser-official/chromium-55.0.2883.87.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/chromium/chromium-55.0.2883.87.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/chromium/chromium-55.0.2883.87.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/chromium/chromium-55.0.2883.87.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/chromium/chromium-55.0.2883.87.tar.xz
wget -nc https://github.com/foutrelis/chromium-launcher/archive/v3.tar.gz
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/24.0.0.186/flash_player_ppapi_linux.x86_64.tar.gz
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/24.0.0.186/flash_player_ppapi_linux.i386.tar.gz

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
     -O chromium-launcher-3.tar.gz


sed 's/#include <sys\/mman\.h>/&\n\n#if defined(MADV_FREE)\n#undef MADV_FREE\n#endif\n/' \
    -i third_party/WebKit/Source/wtf/allocator/PageAllocator.cpp


sed "s/^config(\"compiler\") {/&\ncflags_cc = [ \"-fno-delete-null-pointer-checks\" ]/" \
    -i build/config/linux/BUILD.gn


sed "s/WIDEVINE_CDM_AVAILABLE/&\n\n#define WIDEVINE_CDM_VERSION_STRING \"Pinkie Pie\"/" \
    -i third_party/widevine/cdm/stub/widevine_cdm_version.h


for LIB in flac harfbuzz-ng libwebp libxslt yasm; do
    find -type f -path "*third_party/$LIB/*" \
        \! -path "*third_party/$LIB/chromium/*" \
        \! -path "*third_party/$LIB/google/*" \
        \! -regex '.*\.\(gn\|gni\|isolate\|py\)' \
        -delete
done &&
python build/linux/unbundle/replace_gn_files.py \
    --system-libraries flac harfbuzz-ng libwebp libxslt yasm


GN_CONFIG=("google_api_key=\"AIzaSyDxKL42zsPjbke5O8_rPVpVrLrJ8aeE9rQ\""
"google_default_client_id=\"595013732528-llk8trb03f0ldpqq6nprjp1s79596646.apps.googleusercontent.com\""
"google_default_client_secret=\"5ntt6GbbkjnTVXx-MSxbmx5e\""
'clang_use_chrome_plugins=false'
'enable_hangout_services_extension=true'
'enable_nacl=false'
'enable_nacl_nonsfi=false'
'enable_widevine=true'
'fatal_linker_warnings=false'
'ffmpeg_branding="Chrome"'
'fieldtrial_testing_like_official_build=true'
'is_debug=false'
'is_clang=false'
'link_pulseaudio=true'
'linux_use_bundled_binutils=false'
'proprietary_codecs=true'
'remove_webcore_debug_symbols=true'
'symbol_level=0'
'treat_warnings_as_errors=false'
'use_allocator="none"'
'use_cups=true'
'use_gconf=false'
'use_gnome_keyring=false'
'use_gold=false'
'use_gtk3=false'
'use_kerberos=true'
'use_pulseaudio=true'
'use_sysroot=false')


python tools/gn/bootstrap/bootstrap.py --gn-gen-args "${GN_CONFIG[*]}" &&
out/Release/gn gen out/Release --args="${GN_CONFIG[*]}"


ninja -C out/Release chrome chrome_sandbox chromedriver widevinecdmadapter



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vDm755  out/Release/chrome \
                 /usr/lib/chromium/chromium              &&
install -vDm4755 out/Release/chrome_sandbox \
                 /usr/lib/chromium/chrome-sandbox        &&
install -vDm755  out/Release/chromedriver \
                 /usr/lib/chromium/chromedriver          &&
ln -svf /usr/lib/chromium/chromium /usr/bin              &&
ln -svf /usr/lib/chromium/chromedriver /usr/bin/         &&
install -vm755 out/Release/libwidevinecdmadapter.so \
               /usr/lib/chromium/                        &&
install -vDm644 out/Release/icudtl.dat /usr/lib/chromium &&
install -vDm644 out/Release/gen/content/content_resources.pak \
                /usr/lib/chromium/                       &&
install -vm644 out/Release/{*.pak,*.bin} \
               /usr/lib/chromium/                        &&
cp -av out/Release/locales /usr/lib/chromium/            &&
chown -Rv root:root /usr/lib/chromium/locales            &&
install -vDm644 out/Release/chrome.1 \
                /usr/share/man/man1/chromium.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


for size in 16 32; do
    install -vDm644 \
        "chrome/app/theme/default_100_percent/chromium/product_logo_$size.png" \
        "/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png"
done &&
for size in 22 24 48 64 128 256; do
    install -vDm644 "chrome/app/theme/chromium/product_logo_$size.png" \
        "/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png"
done &&
cat > /usr/share/applications/chromium.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Chromium Web Browser
Comment=Access the Internet
GenericName=Web Browser
Exec=chromium %u
Terminal=false
Type=Application
Icon=chromium
Categories=GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
EOF


tar -xf ../chromium-launcher-3.tar.gz &&
cd chromium-launcher-3 &&
make PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -f /usr/bin/chromium        &&
make PREFIX=/usr install-strip &&
cd ..

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


mkdir temp                                  &&
cd temp                                     &&
ar -x ../../google-chrome-stable*.deb &&
tar -xf data.tar.xz



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vm755 opt/google/chrome/libwidevinecdm.so \
    /usr/lib/chromium/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../../flash_player_ppapi_linux.*.tar.gz



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /usr/lib/PepperFlash &&
install -vm755 libpepflashplayer.so /usr/lib/PepperFlash &&
install -vm644 manifest.json /usr/lib/PepperFlash

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
