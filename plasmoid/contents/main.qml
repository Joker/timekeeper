import QtQuick 1.1
import "clock"
import "calendar"
import "luna"
import "wheels"
import "timekeeper"

Rectangle {
    FontLoader { id: fixedFont; source: "clock/Engravers_MT.ttf"}
/*
    Component.onCompleted: {
        plasmoid.setBackgroundHints(NoBackground);
    }
// */

    function timeChanged() {
        var date = new Date;
        clock.hours    = clock ? date.getUTCHours()   + Math.floor(clock.shift)  : date.getHours()
        clock.minutes  = clock ? date.getUTCMinutes() + ((clock.shift % 1) * 60) : date.getMinutes()
        clock.seconds  = date.getUTCSeconds();
        clock.day      = Qt.formatDateTime(date, "ddd")

        timekeeper.day   = Qt.formatDateTime(date, "dd")
        timekeeper.month = Qt.formatDateTime(date, "MMM")
        timekeeper.year  = Qt.formatDateTime(date, "yy")

        if(calendar.lock){
            calendar.tak  = clock.seconds * 6;
        }
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: timeChanged()
    }



    width: 500; height: 500
    color: "transparent"

    Calendar {
        id:calendar;
        anchors.centerIn: parent


        Wheel{ x: -13;y: 178}

        Clock {
            id: clock;
            x: -9; y: 42;
            shift: 4
        }

        Luna  { x: 162;y: 90}

        Timekeeper{
            id: timekeeper;
            x: 285;y: 186
        }
    }
}
