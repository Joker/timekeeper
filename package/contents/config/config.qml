import QtQuick 2.1
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: Qt.resolvedUrl('../screenshot.png').replace('file://', '')
         source: "configplasma/cfgMain.qml"
    }
}