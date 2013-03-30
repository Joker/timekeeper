import QtQuick 1.1
import "clock"
import "calendar"
import "luna"
import "wheels"
import "timekeeper"

Rectangle {
/*
    Component.onCompleted: {
        plasmoid.setBackgroundHints(NoBackground);
    }
// */
    width: 500; height: 500
    color: "transparent"

    Calendar {
        anchors.centerIn: parent


        Wheel{ x: -13;y: 178}
        Clock { x: -9; y: 42; shift: 4 }
        Luna  { x: 162;y: 90}
        Timekeeper{ x: 285;y: 186}

    }

}
