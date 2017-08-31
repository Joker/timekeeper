VERSION = 0.6

view:
			plasmoidviewer --applet package
qml:
			qmlscene package/contents/ui/main.qml
install: version
			kpackagetool5 -t Plasma/Applet --install package
upgrade: version
			kpackagetool5 -t Plasma/Applet --upgrade package
remove:
			kpackagetool5 -t Plasma/Applet --remove org.kde.plasma.timekeeper



version:
			sed -i 's/^X-KDE-PluginInfo-Version=.*$$/X-KDE-PluginInfo-Version=$(VERSION)/' package/metadata.desktop


plasmoid: version
			cd package; zip -r ../timekeeper-$(VERSION).plasmoid *
7z: version
			cd package; 7z a -tzip ../timekeeper-$(VERSION).plasmoid *



clear:
			find . -type f -name '*.qmlc' -delete
			find . -type f -name '*.jsc'  -delete