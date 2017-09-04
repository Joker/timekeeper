VER = 0.6
ID = org.kde.plasma.timekeeper

view:
			plasmoidviewer --applet package
qml:
			qmlscene package/contents/ui/main.qml
install: version
			kpackagetool5 -t Plasma/Applet --install package
upgrade: version
			kpackagetool5 -t Plasma/Applet --upgrade package
remove:
			kpackagetool5 -t Plasma/Applet --remove $(ID)
ls:
			kpackagetool5 --list --type Plasma/Applet


version:
			sed -i 's/^X-KDE-PluginInfo-Version=.*$$/X-KDE-PluginInfo-Version=$(VER)/' package/metadata.desktop
			sed -i 's/^X-KDE-PluginInfo-Name=.*$$/X-KDE-PluginInfo-Name=$(ID)/' package/metadata.desktop


plasmoid: version
			cd package; zip -r ../timekeeper-$(VER).plasmoid *
7z: version
			cd package; 7z a -tzip ../timekeeper-$(VER).plasmoid *



clear:
			find . -type f -name '*.qmlc' -delete
			find . -type f -name '*.jsc'  -delete