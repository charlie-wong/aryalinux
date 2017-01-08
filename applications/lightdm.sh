#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="lightdm"
DESCRIPTION="A light-weight desktop manager with greeters available in GTK/QT."
VERSION=1.21.3

#REQ:xserver-meta
#REQ:itstool
#REQ:libgcrypt
#REQ:libxklavier
#REQ:systemd
#REQ:polkit
#REQ:accountsservice

cd $SOURCE_DIR

wget -nc https://launchpad.net/lightdm/1.21/1.21.3/+download/lightdm-1.21.3.tar.xz

TARBALL=lightdm-1.21.3.tar.xz
DIRECTORY=lightdm-1.21.3

tar -xf $TARBALL

cd $DIRECTORY

export MOC4=moc-qt4

CFLAGS="-march=native -mtune=native -O3"   \
CXXFLAGS="-march=native -mtune=native -O3" \
CPPLAGS="-march=native -mtune=native -O3"  \
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --libexecdir=/usr/lib \
            --with-greeter-user=lightdm \
            --with-greeter-session=lightdm-gtk-greeter \
            --disable-static \
            --disable-tests  \
			--disable-liblightdm-qt5  \
			--disable-liblightdm-qt

make "-j`nproc`"

cat > 1434987998845.sh << "ENDOFFILE"
make install
cp -v data/lightdm.conf /etc/lightdm/
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh

cat > 1434987998845.sh << "ENDOFFILE"
rm -rf /etc/apparmor.d /etc/init
install -dm770 /var/lib/lightdm-data
install -dm711 /var/log/lightdm-data

chmod +t /var/lib/lightdm-data

echo "GDK_CORE_DEVICE_EVENTS=true" > /var/lib/lightdm-data/.pam_environment

chmod 644 /var/lib/lightdm-data/.pam_environment

install -dm755 /etc/lightdm

ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh

cat > 1434987998845.sh << "ENDOFFILE"
cat > /etc/lightdm/users.conf << "EOF"
#
# User accounts configuration
#
# NOTE: If you have AccountsService installed on your system, then LightDM will
# use this instead and these settings will be ignored
#
# minimum-uid = Minimum UID required to be shown in greeter
# hidden-users = Users that are not shown to the user
# hidden-shells = Shells that indicate a user cannot login
#
[UserAccounts]
minimum-uid=1000
hidden-users=nobody nobody4 noaccess
hidden-shells=/bin/false /sbin/nologin
EOF

cat > ${DEST}/etc/lightdm/Xsession << "EOF"
#!/bin/sh
#
# LightDM wrapper to run around X sessions.

echo "Running X session wrapper"

# Load profile
for file in "/etc/profile" "$HOME/.profile" "/etc/xprofile" "$HOME/.xprofile"; do
    if [ -f "$file" ]; then
        echo "Loading profile from $file";
        . "$file"
    fi
done

# Load resources
for file in "/etc/X11/Xresources" "$HOME/.Xresources"; do
    if [ -f "$file" ]; then
        echo "Loading resource: $file"
        xrdb -nocpp -merge "$file"
    fi
done

# Load keymaps
for file in "/etc/X11/Xkbmap" "$HOME/.Xkbmap"; do
    if [ -f "$file" ]; then
        echo "Loading keymap: $file"
        setxkbmap `cat "$file"`
        XKB_IN_USE=yes
    fi
done

# Load xmodmap if not using XKB
if [ -z "$XKB_IN_USE" ]; then
    for file in "/etc/X11/Xmodmap" "$HOME/.Xmodmap"; do
        if [ -f "$file" ]; then
           echo "Loading modmap: $file"
           xmodmap "$file"
        fi
    done
fi

unset XKB_IN_USE

# Run all system xinitrc shell scripts.
xinitdir="/etc/X11/xinit/xinitrc.d"
if [ -d "$xinitdir" ]; then
    for script in $xinitdir/*; do
        echo "Loading xinit script $script"
        if [ -x "$script" -a ! -d "$script" ]; then
            . "$script"
        fi
    done
fi

echo "X session wrapper complete, running session $@"

exec $@
EOF

ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh

cat > 1434987998845.sh << "ENDOFFILE"
chmod 755 /etc/lightdm/Xsession

install -dm755 /etc/pam.d

cat > /etc/pam.d/lightdm << "EOF"
# Begin /etc/pam.d/lightdm

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     include        system-auth
auth     optional       pam_gnome_keyring.so

account  include        system-account
password include        system-password

session  required       pam_limits.so
session  include        system-session
session  optional       pam_gnome_keyring.so auto_start

# End /etc/pam.d/lightdm
EOF

cat > /etc/pam.d/lightdm-autologin << "EOF"
# Begin /etc/pam.d/lightdm-autologin

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     required       pam_permit.so

account  include        system-account

password required       pam_deny.so

session  required       pam_limits.so
session  include        system-session

# End /etc/pam.d/lightdm-autologin
EOF

cat > /etc/pam.d/lightdm-greeter << "EOF"
# Begin /etc/pam.d/lightdm-greeter

auth     required       pam_env.so
auth     required       pam_permit.so

account  required       pam_permit.so
password required       pam_deny.so
session  required       pam_unix.so

# End /etc/pam.d/lightdm-greeter
EOF
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh

cat > 1434987998845.sh << "ENDOFFILE"
install -dm700 /usr/share/polkit-1/rules.d

cat > /usr/share/polkit-1/rules.d/lightdm.rules << "EOF"
polkit.addRule(function(action, subject) {
    if (subject.user == "lightdm") {
        polkit.log("action=" + action);
        polkit.log("subject=" + subject);
        if (action.id.indexOf("org.freedesktop.login1.") == 0) {
            return polkit.Result.YES;
        }
        if (action.id.indexOf("org.freedesktop.consolekit.system.") == 0) {
            return polkit.Result.YES;
        }
        if (action.id.indexOf("org.freedesktop.upower.") == 0) {
            return polkit.Result.YES;
        }
    }
});
EOF

chmod 600 /usr/share/polkit-1/rules.d/lightdm.rules

install -dm755 /etc/tmpfiles.d /lib/systemd/system

cat > /etc/tmpfiles.d/lightdm.conf << "EOF"
d /run/lightdm 0711 lightdm lightdm
EOF

cat > /lib/systemd/system/lightdm.service << "EOF"
[Unit]
Description=Light Display Manager
Documentation=man:lightdm(1)
Conflicts=getty@tty1.service
After=systemd-user-sessions.service getty@tty1.service plymouth-quit.service

[Service]
ExecStart=/usr/sbin/lightdm
Restart=always
IgnoreSIGPIPE=no
BusName=org.freedesktop.DisplayManager

[Install]
Alias=display-manager.service
EOF

ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh

cat > 1434987998845.sh << "ENDOFFILE"
getent group lightdm > /dev/null || groupadd -g 63 lightdm
getent passwd lightdm > /dev/null || useradd -c "Light Display Manager" -u 63 -g lightdm -d /var/lib/lightdm-data -s /sbin/nologin lightdm

chown -R lightdm:lightdm /var/lib/lightdm-data /var/log/lightdm

chmod 700 /usr/share/polkit-1/rules.d
chmod 600 /usr/share/polkit-1/rules.d/*
chown -R polkitd:polkitd /usr/share/polkit-1/rules.d

systemctl enable lightdm

groupadd -r autologin
groupadd -r nopasswdlogin

ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh


cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
