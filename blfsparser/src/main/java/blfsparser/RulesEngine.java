package blfsparser;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class RulesEngine {

	private static void x7Rules(Parser parser) {
		if (parser.getName().startsWith("x7")) {
			List<String> commands = parser.getCommands();
			List<String> newCommands = new ArrayList<String>();
			for (String command : commands) {
				if (command.contains("mkdir app")) {
					command = command.replace("mkdir app", "mkdir -pv app");
				} else if (command.contains("mkdir lib")) {
					command = command.replace("mkdir lib", "mkdir -pv lib");
				} else if (command.contains("mkdir font")) {
					command = command.replace("mkdir font", "mkdir -pv font");
				} else if (command.contains("mkdir proto")) {
					command = command.replace("mkdir proto", "mkdir -pv proto");
				}
				if (command.contains("bash -e")) {
					command = command.replace("bash -e", "");
				}
				if (command.contains("exit")) {
					command = command.replace("exit", "");
				}
				newCommands.add(command);
			}
			parser.setCommands(newCommands);
		}
	}

	private static void removeDoxygenCommands(Parser parser) {
		if (parser.getOptionalDependencies().contains("doxygen")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				boolean shouldAdd = true;
				if (command.startsWith("USER_INPUT")
						&& (command.contains("USER_INPUT:doxygen") || command.contains("USER_INPUT:make doc")
								|| (command.startsWith("USER_INPUT:make") && command.endsWith("doxygen")))) {
					shouldAdd = false;
				}
				if (command.startsWith("ROOT_COMMANDS") && command.contains("/usr/share/doc")
						&& !(command.trim().startsWith("ROOT_COMMANDS:make") && command.trim().endsWith("install"))
						&& !command.contains("make install")) {
					shouldAdd = false;
				}
				if (shouldAdd) {
					newCommands.add(command);
				} else {
					// System.out.println(parser.getSubSection() + "_" +
					// parser.getName() + " : " + command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	private static void removeTexliveCommands(Parser parser) {
		if (parser.getOptionalDependencies().contains("texlive")) {
			List<String> newCommands = new ArrayList<String>();
			boolean texiCommands = false;
			for (String command : parser.getCommands()) {
				boolean shouldAdd = true;
				if (command.startsWith("USER_INPUT") && command.contains(".texi") && !command.contains("./configure")) {
					shouldAdd = false;
					texiCommands = true;
				}
				if (command.startsWith("ROOT_COMMANDS") && command.contains("/usr/share/doc")
						&& !(command.trim().startsWith("ROOT_COMMANDS:make") && command.trim().endsWith("install"))
						&& !command.contains("make install") && texiCommands) {
					shouldAdd = false;
				}
				if (shouldAdd) {
					newCommands.add(command);
				} else {
					// System.out.println(parser.getSubSection() + "_" +
					// parser.getName() + " : " + command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	private static void xorgEnvRule(Parser parser) {
		if (parser.getRequiredDependencies().contains("xorg7#xorg-env")) {
			parser.getRequiredDependencies().remove("xorg7#xorg-env");
			parser.getCommands().add(0,
					"USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
			// System.out.println("Added xorgenv to " + parser.getSubSection() +
			// "_" + parser.getName());
		}
		if (parser.getRecommendedDependencies().contains("xorg7#xorg-env")) {
			parser.getRecommendedDependencies().remove("xorg7#xorg-env");
			parser.getCommands().add(0,
					"USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
			// System.out.println("Added xorgenv to " + parser.getSubSection() +
			// "_" + parser.getName());
		}
		if (parser.getOptionalDependencies().contains("xorg7#xorg-env")) {
			parser.getOptionalDependencies().remove("xorg7#xorg-env");
			parser.getCommands().add(0,
					"USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
			// System.out.println("Added xorgenv to " + parser.getSubSection() +
			// "_" + parser.getName());
		}
		// if (parser.getRequiredDependencies().contains("#xorg-env"))
	}

	private static void xorgPrefixRule(Parser parser) {
		List<String> commands = parser.getCommands();
		boolean declareVariable = false;
		for (String command : commands) {
			if (command.contains("XORG_PREFIX") || command.contains("XORG_CONFIG")) {
				declareVariable = true;
			}
		}
		if (declareVariable && !parser.getCommands().get(0).contains("USER_INPUT:export XORG_PREFIX")) {
			parser.getCommands().add(0,
					"USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\"");
		}
	}

	private static void makeMultiple(Parser parser) {
		List<String> newCommands = new ArrayList<String>();
		for (String command : parser.getCommands()) {
			command = command.replace("br3ak", "\n");
			String newCommand = "";
			StringTokenizer st = new StringTokenizer(command, "\n");
			while (st.hasMoreTokens()) {
				String str = st.nextToken();
				String trimmed = str.trim();
				/*
				 * if (parser.getName().contains("lynx")) {
				 * System.out.println("[" + trimmed + "]"); }
				 */
				if (trimmed.equals("make")) {
					newCommand = newCommand + str.replace("make", "make \"-j`nproc`\"") + "\n";
				} else {
					newCommand = newCommand + str + '\n';
				}
			}
			newCommands.add(newCommand);
		}
		parser.setCommands(newCommands);
	}

	private static void libgpgError(Parser parser) {
		List<String> newCommands = new ArrayList<String>();
		if (parser.getName().contains("libgpg-error")) {
			for (String command : parser.getCommands()) {
				if (command.contains("mv -v /usr/lib/libgpg-error.so.*")) {
					command = command.replace("USER_INPUT:", "ROOT_COMMANDS:");
				}
				newCommands.add(command);
			}
			parser.setCommands(newCommands);
		}
	}

	private static void libgpgcrypt(Parser parser) {
		List<String> newCommands = new ArrayList<String>();
		if (parser.getName().contains("libgcrypt")) {
			for (String command : parser.getCommands()) {
				if (command.contains("mv -v /usr/lib/libgcrypt.so.*")) {
					command = command.replace("USER_INPUT:", "ROOT_COMMANDS:");
				}
				newCommands.add(command);
			}
			parser.setCommands(newCommands);
		}
	}

	private static void systemd(Parser parser) {
		if (parser.getName().endsWith("systemd")) {
			List<String> downloadUrls = parser.getDownloadUrls();
			for (String str : BLFSParser.systemdDownloads) {
				downloadUrls.add(str);
			}
			Util.replaceCommandContaining(parser, "systemd", "-compat-1.patch", "-compat-3.patch");
		}
	}

	private static void kdePrefix(Parser parser) {
		boolean addDeclaration = false;
		for (String command : parser.getCommands()) {
			if (command.contains("$KDE_PREFIX")) {
				addDeclaration = true;
			}
		}
		if (addDeclaration) {
			parser.getCommands().add(0, "USER_INPUT:export KDE_PREFIX=/opt/kde\n");
		}
	}

	private static void qt4Prefix(Parser parser) {
		// TODO: Prefix all QT Variables to all command snippets...
		if (parser.getName().equals("qt4") || parser.getName().equals("qca") || parser.getName().equals("vlc")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (command.startsWith("ROOT_COMMANDS:")) {
					newCommands
							.add("ROOT_COMMANDS:export QT4PREFIX=\"/opt/qt4\"\nexport QT4BINDIR=\"$QT4PREFIX/bin\"\nexport QT4DIR=\"$QT4PREFIX\"\nexport QTDIR=\"$QT4PREFIX\"\nexport PATH=\"$PATH:$QT4BINDIR\"\nexport PKG_CONFIG_PATH=\"/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig\"\n"
									+ command);
				} else {
					newCommands
							.add("USER_INPUT:export QT4PREFIX=\"/opt/qt4\"\nexport QT4BINDIR=\"$QT4PREFIX/bin\"\nexport QT4DIR=\"$QT4PREFIX\"\nexport QTDIR=\"$QT4PREFIX\"\nexport PATH=\"$PATH:$QT4BINDIR\"\nexport PKG_CONFIG_PATH=\"/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig\"\n"
									+ command);
				}
				parser.setCommands(newCommands);
			}
		}
	}

	private static void qt4(Parser parser) {
		if (parser.getName().contains("qt4")) {
			String misplaced = null;
			String toBeDeleted = null;
			for (String command : parser.getCommands()) {
				if (command.contains("mkdir /opt/qt-")) {
					misplaced = command;
				}
				if (command.contains("-bindir") && command.contains("/usr/bin/qt4") && command.contains("\\")) {
					toBeDeleted = command;
				}
			}
			if (misplaced != null) {
				parser.getCommands().remove(misplaced);
				parser.getCommands().add(misplaced);
			}
			if (toBeDeleted != null) {
				parser.getCommands().remove(toBeDeleted);
			}
		}
	}

	private static void dbus(Parser parser) {
		if (parser.getName().equals("dbus")) {
			parser.getDownloadUrls().add(BLFSParser.dbusLink);
			List<String> commands = parser.getCommands();
			int index = -1;
			String oldCommand = null;
			for (int i = 0; i < commands.size(); i++) {
				String command = commands.get(i);
				if (command.contains("mv -v /usr/lib/libdbus-1.so.*")) {
					index = i;
					oldCommand = command;
				}
			}
			if (index != -1 && oldCommand != null) {
				commands.set(index, oldCommand.replace("USER_INPUT", "ROOT_COMMANDS"));
			}
		}
	}

	private static void libvpx(Parser parser) {
		if (parser.getName().equals("libvpx")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (command.contains("../libvpx-v1.4.0/configure")) {
					command = command.replace("../libvpx-v1.4.0/configure", "../$DIRECTORY/configure");
				}
				newCommands.add(command);
			}
			parser.setCommands(newCommands);
		}
	}

	private static void akonadi(Parser parser) {
		if (parser.getName().equals("akonadi")) {
			parser.getRequiredDependencies().remove("mariadb");
			parser.getRequiredDependencies().remove("postgresql");
		}
	}

	private static void kdelibs(Parser parser) {
		if (parser.getName().equals("kdelibs")) {
			parser.getRecommendedDependencies().remove("udisks");
		}
	}

	private static void wget(Parser parser) {
	}

	private static void openssh(Parser parser) {
		if (parser.getName().equals("openssh")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (!command.startsWith("USER_INPUT:ssh-keygen")) {
					newCommands.add(command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	private static void freetype(Parser parser) {
		if (parser.getName().equals("freetype2")) {
			// System.out.println(parser.getCommands());
		}
	}

	private static void llvm(Parser parser) {
		if (parser.getName().equals("llvm")) {
			List<String> newCommands = new ArrayList<String>();
			for (String command : parser.getCommands()) {
				if (!command.contains("sphinx")
						&& !command.contains("install -v -m644 docs/_build/man/* /usr/share/man/man1/")) {
					newCommands.add(command);
				}
			}
			parser.setCommands(newCommands);
		}
	}

	private static void unzip(Parser parser) {
		Util.removeCommandContaining(parser, "unzip", "/path/to/unzipped/files");
	}

	private static void qca(Parser parser) {
		Util.replaceCommandContaining(parser, "qca", "${QT4DIR}/include/qt4/", "${QT4DIR}/include/");
		Util.replaceCommandContaining(parser, "qca", "${QT4DIR}/share/qt4/mkspecs/features/",
				"${QT4DIR}/mkspecs/features/");
	}

	private static void libassuan(Parser parser) {
		if (parser.getName().equals("libassuan")) {
			Util.removeCommandContaining(parser, "libassuan", "make -C doc pdf ps");
			Util.removeCommandContaining(parser, "libassuan", "install -v -dm755 /usr/share/doc/libassuan-2.2.1");
		}
	}

	private static void openldap(Parser parser) {
		if (parser.getName().equals("openldap")) {
			parser.getCommands().add(2,
					"USER_INPUT:cd $SOURCE_DIR\nsudo rm -rf $DIRECTORY\ntar xf $TARBALL\ncd $DIRECTORY\n");
			Util.removeCommandContaining(parser, "openldap", "systemctl start slapd");
			Util.removeCommandContaining(parser, "openldap", "ldapsearch -x -b");
		}
	}/*
		 * 
		 * private static void x7driver(Parser parser) { if
		 * (parser.getName().equals("x7driver")) { parser.getCommands().add(0,
		 * "USER_INPUT:export XORG_PREFIX=/usr\nexport XORG_CONFIG=\"--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static\""
		 * ); } }
		 */

	private static void gnomeSettingsDaemon(Parser parser) {
		if (parser.getName().equals("gnome-settings-daemon")) {
			parser.getRequiredDependencies().remove("x7driver#xorg-wacom-driver");
		}
	}

	private static void gnupg(Parser parser) {
		if (parser.getName().equals("gnupg")) {
			parser.getRequiredDependencies().add("npth");
			Util.removeCommandContaining(parser, "gnupg", "make -C doc pdf ps html");
			Util.removeCommandContaining(parser, "gnupg", "install -v -m644 doc/gnupg.html/*");
		}
	}

	private static void aspell(Parser parser) {
		if (parser.getName().equals("aspell")) {
			parser.getCommands().remove(parser.getCommands().size() - 1);
			parser.getCommands().remove(parser.getCommands().size() - 1);
		}
	}

	private static void popt(Parser parser) {
		if (parser.getName().equals("popt")) {
			Util.removeCommandContaining(parser, "popt", "/usr/share/doc/popt");
		}
	}

	private static void dhcpcd(Parser parser) {
		Util.removeCommandContaining(parser, "dhcpcd", "systemctl enable");
		Util.removeCommandContaining(parser, "dhcpcd", "systemctl start");
	}

	private static void networkManager(Parser parser) {
		if (parser.getName().equals("networkmanager")) {
			parser.getRecommendedDependencies().remove("dhcp");
		}
	}

	private static void x7lib(Parser parser) {
		Util.removeCommandContaining(parser, "x7lib", "ln -sv $XORG_PREFIX/lib/X11");
	}

	private static void freetypeHarfbuzzCircularDeps(Parser parser) {
		if (parser.getName().equals("freetype2")) {
			parser.getRecommendedDependencies().remove("freetype2");
		}
		if (parser.getName().equals("harfbuzz")) {
			parser.getRecommendedDependencies().remove("freetype2");
			parser.getRecommendedDependencies().remove("harfbuzz");
			parser.getRecommendedDependencies().add("freetype2-without-harfbuzz");
		}
		if (parser.getName().equals("freetype2-without-harfbuzz")) {
			parser.getRecommendedDependencies().remove("freetype2");
			parser.getRecommendedDependencies().remove("harfbuzz");
		}
	}

	private static void xfce4session(Parser parser) {
		Util.replaceCommandContaining(parser, "xfce4-session", "update-mime-database",
				"update-mime-database /usr/share/mime");
	}

	private static void libisoburn(Parser parser) {
		Util.removeCommandContaining(parser, "libisoburn", "doxygen");
		Util.removeCommandContaining(parser, "libisoburn", "/usr/share/doc/libisoburn");
	}

	private static void libnotify(Parser parser) {
		if (parser.getName().equals("libnotify")) {
			parser.getRequiredDependencies().remove("xfce4-notifyd");
		}
	}

	private static void docbookXsl(Parser parser) {
		Util.removeCommandContaining(parser, "docbook-xsl", "em class=");
	}

	private static void wpaSupplicant(Parser parser) {
		Util.removeCommandContaining(parser, "wpa_supplicant", "pushd wpa_gui-qt4");
		Util.removeCommandContaining(parser, "wpa_supplicant", "install -v -m755 wpa_gui-qt4");
		Util.removeCommandContaining(parser, "wpa_supplicant", "wpa_passphrase");
		Util.removeCommandContaining(parser, "wpa_supplicant", "em class=");
	}

	private static void gimp(Parser parser) {
		Util.replaceCommandContaining(parser, "gimp", "ALL_LINGUAS=",
				"HELPTARBALL=`ls ../gimp-help*`\nHELPDIR=`tar tf $HELPTARBALL | cut -d/ -f1 | uniq`\ntar xf $HELPTARBALL\ncd $HELPDIR\nALL_LINGUAS=");
		Util.replaceCommandContaining(parser, "gimp", "<em class=\"replaceable\"><code>&lt;browser&gt;</code></em>",
				"firefox");
	}

	private static void transmission(Parser parser) {
		if (parser.getName().equals("transmission")) {
			parser.getRecommendedDependencies().remove("qt4");
			parser.getRecommendedDependencies().remove("qt5");
			Util.removeCommandContaining(parser, "transmission", "pushd qt");
			Util.removeCommandContaining(parser, "transmission", "transmission-qt.desktop");
		}
	}

	private static void libevent(Parser parser) {
		Util.removeCommandContaining(parser, "libevent", "doxygen");
	}

	private static void cups(Parser parser) {
		if (parser.getName().equals("cups")) {
			Util.removeCommandContaining(parser, "cups", "usermod -a -G lpadmin");
		}
	}

	private static void poppler(Parser parser) {
		Util.removeCommandContaining(parser, "poppler", "git");
	}

	private static void gs(Parser parser) {
		Util.removeCommandContaining(parser, "gs", "tar -xvf");
		Util.removeCommandContaining(parser, "gs", "gs -q -dBATCH");
	}

	private static void installing(Parser parser) {
		if (parser.getRequiredDependencies().contains("installing")) {
			parser.getRequiredDependencies().remove("installing");
			parser.getRequiredDependencies().add("xorg-server");
		}
		if (parser.getRecommendedDependencies().contains("installing")) {
			parser.getRecommendedDependencies().remove("installing");
			parser.getRecommendedDependencies().add("xorg-server");
		}
		if (parser.getOptionalDependencies().contains("installing")) {
			parser.getOptionalDependencies().remove("installing");
			parser.getOptionalDependencies().add("xorg-server");
		}
	}

	private static void codecs(Parser parser) {
		parser.getRequiredDependencies().remove("alsa");
		parser.getRecommendedDependencies().remove("alsa");
		parser.getOptionalDependencies().remove("alsa");
		Util.removeCommandContaining(parser, "alsa-lib", "make doc");
		Util.removeCommandContaining(parser, "alsa-lib", "doxygen");
		Util.removeCommandContaining(parser, "alsa-tools", "bash -e");
		Util.removeCommandContaining(parser, "alsa-tools", "exit");
		Util.removeCommandContaining(parser, "faac", "./frontend/faac");
		Util.removeCommandContaining(parser, "faac", "faad Front_Left.mp4");
		Util.removeCommandContaining(parser, "faad2", "./frontend/faad -o sample.wav");
		Util.removeCommandContaining(parser, "faad2", "aplay sample.wav");
		Util.removeCommandContaining(parser, "libmusicbrainz5", "doxygen");
		Util.removeCommandContaining(parser, "libmusicbrainz5", "/usr/share/doc/libmusicbrainz-5.1.0");
		Util.removeCommandContaining(parser, "ffmpeg", "pushd doc");
		Util.removeCommandContaining(parser, "ffmpeg", "doc/*.pdf");
		Util.removeCommandContaining(parser, "ffmpeg", "doc/doxy/html/*");
		Util.removeCommandContaining(parser, "xine-lib", "doxygen");
		Util.removeCommandContaining(parser, "xine-lib", "doc/api/*");
	}

	private static void parole(Parser parser) {
		if (parser.getName().equals("parole")) {
			parser.getRequiredDependencies().add("xdg-utils");
		}
		if (parser.getName().equals("xdg-utils")) {
			parser.getRequiredDependencies().remove("fop");
			parser.getRequiredDependencies().remove("w3m");
			parser.getRequiredDependencies().remove("links");
		}
	}

	private static void vlc(Parser parser) {
		if (parser.getName().equals("vlc")) {
			parser.getRequiredDependencies().add("qt4");
		}
	}

	private static void pidgin(Parser parser) {
		Util.removeCommandContaining(parser, "pidgin", "cp -v doc/html/*");
	}

	private static void graphite2(Parser parser) {
		Util.replaceCommandContaining(parser, "graphite2", "\\ \n", "\\\n");
	}

	private static void libreoffice(Parser parser) {
		Util.replaceCommandContaining(parser, "libreoffice", "--with-system-boost", "--without-system-boost");
	}

	private static void libusb(Parser parser) {
		Util.removeCommandContaining(parser, "libusb", "doc/html/*");
		Util.removeCommandContaining(parser, "fuse", "doc/html/*");
		Util.removeCommandContaining(parser, "parted", "texi2pdf");
		Util.removeCommandContaining(parser, "parted", "pdf,ps,dvi");
		Util.removeCommandContaining(parser, "libgcrypt", "doc/gcrypt.html/*");
		Util.removeCommandContaining(parser, "libgcrypt", "make -j1 -C doc pdf ps html");
	}
	
	private static void removeMail(Parser parser) {
		parser.getRequiredDependencies().remove("mail");
		parser.getRecommendedDependencies().remove("mail");
		parser.getOptionalDependencies().remove("mail");
	}
	
	private static void php(Parser parser) {
		if (parser.getName().equals("php")) {
			parser.getRecommendedDependencies().addAll(parser.getOptionalDependencies());
			parser.getRequiredDependencies().remove("mariadb");
			parser.getRecommendedDependencies().remove("mariadb");
			parser.getRecommendedDependencies().remove("mitkrb");
			parser.getRequiredDependencies().remove("mitkrb");
			parser.getRecommendedDependencies().add("t1lib");
			parser.getRecommendedDependencies().add("gd");
			parser.getRecommendedDependencies().add("net-snmp");
			Util.removeCommandContaining(parser, "php", "php_manual");
			for (int i=0; i<parser.getCommands().size(); i++) {
				String command = parser.getCommands().get(i);
				if (command.contains("./configure")) {
					String newCommand = command.substring(0, command.indexOf("./configure"));
					newCommand = newCommand + PHPConfig.PHP_CONFIG;
					parser.getCommands().set(i, newCommand);
					break;
				}
			}
		}
	}
	
	private static void mariadb(Parser parser) {
		if (parser.getName().equals("mariadb")) {
			for (int i=0; i<parser.getCommands().size(); i++) {
				if (parser.getCommands().get(i).contains("mysqladmin -u root password")) {
					parser.getCommands().add(i, "USER_INPUT:sleep 5\nclear\n");
					i++;
				}
			}
		}
	}
	
	private static void postgresql(Parser parser) {
		if (parser.getName().equals("postgresql")) {
			for (int i=0; i<parser.getCommands().size(); i++) {
				String command = parser.getCommands().get(i);
				if (command.contains("/usr/bin/createdb")) {
					parser.getCommands().add(i, "USER_INPUT:sleep 5\nclear\n");
					i++;
				}
			}
		}
	}
	
	private static void mitkerberos(Parser parser) {
		if (parser.getName().equals("mitkrb")) {
			Util.removeCommandContaining(parser, "mitkrb", "gpg2");
			
		}
	}
	
	private static void updateDesktopDatabase(Parser parser) {
		Util.removeCommandContaining(parser, "desktop-file-utils", "update-desktop-database");
	}
	
	private static void removeDocumentation(Parser parser) {
		Util.removeCommandContaining(parser, "git", "make html");
		Util.removeCommandContaining(parser, "git", "make man");
		Util.removeCommandContaining(parser, "git", "make install-man");
		Util.removeCommandContaining(parser, "git", "htmldir=/usr/share/doc/");
		Util.removeCommandContaining(parser, "git", "man-pages/{html,text}");
		Util.removeCommandContaining(parser, "rsync", "/usr/share/doc/rsync");
	}
	
	public static void applyRules(Parser parser) {
		x7Rules(parser);
		removeDoxygenCommands(parser);
		xorgEnvRule(parser);
		makeMultiple(parser);
		libgpgError(parser);
		libgpgcrypt(parser);
		removeTexliveCommands(parser);
		systemd(parser);
		xorgPrefixRule(parser);
		kdePrefix(parser);
		qt4(parser);
		dbus(parser);
		libvpx(parser);
		akonadi(parser);
		qt4Prefix(parser);
		kdelibs(parser);
		wget(parser);
		openssh(parser);
		freetype(parser);
		llvm(parser);
		unzip(parser);
		qca(parser);
		kdelibs(parser);
		libassuan(parser);
		openldap(parser);
		// x7driver(parser);
		gnomeSettingsDaemon(parser);
		gnupg(parser);
		aspell(parser);
		dhcpcd(parser);
		networkManager(parser);
		popt(parser);
		x7lib(parser);
		freetypeHarfbuzzCircularDeps(parser);
		xfce4session(parser);
		libnotify(parser);
		docbookXsl(parser);
		libisoburn(parser);
		wpaSupplicant(parser);
		gimp(parser);
		transmission(parser);
		libevent(parser);
		cups(parser);
		poppler(parser);
		gs(parser);
		installing(parser);
		codecs(parser);
		parole(parser);
		vlc(parser);
		pidgin(parser);
		graphite2(parser);
		libreoffice(parser);
		libusb(parser);
		php(parser);
		removeMail(parser);
		mariadb(parser);
		postgresql(parser);
		mitkerberos(parser);
		updateDesktopDatabase(parser);
		removeDocumentation(parser);
	}
}
