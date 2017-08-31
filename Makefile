VERSION = 0.6

view: upgrade
			@echo
			@echo '------------------------------------------------'
			@echo
			plasmoidviewer -a org.kde.userbase.plasma.timekeeper



version:
			sed -i 's/^X-KDE-PluginInfo-Version=.*$$/X-KDE-PluginInfo-Version=$(VERSION)/' package/metadata.desktop


plasmoid: version
			cd package; zip -r ../timekeeper-$(VERSION).plasmoid *
7z: version
			cd package; 7z a -tzip ../timekeeper-$(VERSION).plasmoid *



install:
			plasmapkg2 --install package
upgrade:
			plasmapkg2 --upgrade package


clear:
			find . -type f -name '*.qmlc' -delete
			find . -type f -name '*.jsc' -delete