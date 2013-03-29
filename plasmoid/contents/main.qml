import QtQuick 1.1
import "clock"
import "calendar"
import "luna"

Rectangle {
    Component.onCompleted: {
        plasmoid.setBackgroundHints(NoBackground);
    }

    width: 500; height: 500
    color: "transparent"

    Calendar {
        anchors.centerIn: parent
        Clock { x: 0; y: 0; shift: 4 }
        Luna  { x: 192;y: 291; width: 40;height: 40}
    }

}
