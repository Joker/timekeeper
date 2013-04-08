import QtQuick 1.1
import "clock"
import "calendar"
import "luna"
import "clock/wheels"
import "timekeeper"
// import org.kde.plasma.core 0.1 as PlasmaCore
import "luna/phases.js"   as Phases
import "luna/lunacalc.js" as LunaCalc


Rectangle {
    id: main
    width: 478; height: 478
    color: "transparent"

    property alias lx : luna.x
    property alias ly : luna.y

    FontLoader { id: fixedFont; source: "clock/Engravers_MT.ttf" }

    Component.onCompleted: {
/*
        // refresh moon image
        plasmoid.addEventListener("dataUpdated", dataUpdated);
        dataEngine("time").connectSource("Local", luna, 360000, PlasmaCore.AlignToHour);

        // plasmoid.setAspectRatioMode(ConstrainedSquare);
// */
        dataUpdated()


        plasmoid.setBackgroundHints(NoBackground);
    }

    function dataUpdated(today) {
        var MM = [0, -31, -62, -93, -123, -153, -182.5, -241.5, -300, -329.5]
        if(!today) today = new Date();

//        var aDate = new Date();
//            aDate.setMonth(aDate.getMonth()+1, 0)
//        var num = aDate.getDate();
        var month = today.getMonth()
        var date  = today.getDate()-1
        calendar.month_degree = MM[month] - date;

        luna.earth_degree = month * 30 * -1 - date
        luna.phase = LunaCalc.getTodayPhases(today);
        luna.svg_sourse = "luna-gskbyte" + luna.phase + ".svg"
        luna.degree = 185 + 12.41 * luna.phase
        // console.log(luna.phase)
    }
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
        if(clock.lock){
            clock.wr   = clock.seconds * 6;
            clock.wrs  = clock.seconds * 6;
            clock.wc   = clock.seconds * 6 * -1;
            clock.wcs  = clock.seconds * 6 * -1;
        }
        if(Qt.formatDateTime(date, "hhmmss") == "000000") dataUpdated()

    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: timeChanged()
    }



    Calendar {
        id:calendar;
        z: 1
        // anchors.centerIn: parent

        Timekeeper{
            id: timekeeper;
            x: 285;y: 186
            MouseArea {
                x: 154; y: 90
                width: 10; height: 30
            }
            MouseArea {
                x: 178; y: 32
                width: 12; height: 14
                onClicked: dataUpdated()
            }
            MouseArea {
                x: 0; y: 49
                width: 13; height: 14
                onClicked: {
                    if(main.state == "marble") { main.state = ""; calendar.state = "" } else main.state = "marble";
                }
            }
        }
    }
    Clock {
        id: clock;
        x: 29; y: 60
        shift: 4
        state: "in"
        MouseArea {
            id: center
            x: 80; y: 76
            width: 14; height: 14

            onClicked:{
                if(main.state == "marble") calendar.state = ""
                if(main.state == "small") {main.state = "big"; luna.state = "home3"} else main.state = "small";

                //if (clock.whell_st != "hide") clock.whell_st = clock.state;
            }
        }
        MouseArea {
            id: in_out
            x: 62; y: 86
            width: 11; height: 12

            onClicked: {
                clock.state == "out" ? clock.state = "in" : clock.state = "out";
                if (clock.whell_st != "hide") clock.whell_st = clock.state;
            }
        }
        MouseArea {
            id: right
            x: 101; y: 86
            width: 11; height: 12

            onClicked: clock.whell_st == "hide" ? clock.whell_st = clock.state : clock.whell_st = "hide";
        }

        z: 5
    }
    Luna  {
        id:luna;
        x: 162; y: 90
        z: 7
    }
    states: [
        State {
            name: "small"
            PropertyChanges {
                target: calendar
                scale: 0.3
                rotation: 360
                // rangle:2
                x: -119; y: -88
            }
            PropertyChanges {
                target: clock
                whell_st: "hide"
            }
            PropertyChanges {
                target: luna
                state: "home"
            }

        },
        State {
            name: "marble"
            PropertyChanges {
                target: timekeeper
                state:    "out"
            }
            PropertyChanges {
                target: clock
                whell_st: "out"
                state:    "out"
            }
            PropertyChanges {
                target: luna
                state: "big_earth"
                moon_z: -1
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"; to: "big"
            NumberAnimation { properties: "scale"; duration: 2700 } //InOutBack
            NumberAnimation { properties: "x, y "; duration: 700 }
        },
        Transition {
            from: "*"; to: "small"
            NumberAnimation { properties: "scale"; duration: 1000 }
            NumberAnimation { properties: "rotation, x, y "; duration: 2700 }
        }
    ]
}
