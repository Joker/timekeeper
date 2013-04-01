import QtQuick 1.1
import "clock"
import "calendar"
import "luna"
import "clock/wheels"
import "timekeeper"
//import org.kde.plasma.core 0.1 as PlasmaCore
import "luna/phases.js"   as Phases
import "luna/lunacalc.js" as LunaCalc


Rectangle {
    FontLoader { id: fixedFont; source: "clock/Engravers_MT.ttf"}

    Component.onCompleted: {
/*
        plasmoid.setBackgroundHints(NoBackground);

        // refresh moon image
        plasmoid.addEventListener("dataUpdated", dataUpdated);
        dataEngine("time").connectSource("Local", luna, 360000, PlasmaCore.AlignToHour);

        // plasmoid.setAspectRatioMode(ConstrainedSquare);
// */
        dataUpdated()
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
//*
        if(!calendar.lock){
            calendar.tak  = clock.seconds * 6;
        }
// */
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

        Clock {
            id: clock;
            x: 29; y: 60
            shift: 4
            state: "in"
            MouseArea {
                id: center
                x: 80; y: 76
                width: 14; height: 14

               onClicked: clock.state = "zen";
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
            states: [
                State {
                    name: "out"
                    PropertyChanges { target: clock; x: -9; y: 42; }
                },
                State {
                    name: "in"
                    PropertyChanges { target: clock; x: 29; y: 60; }
                }
            ]
            Behavior on x {
                     NumberAnimation { duration: 1000 }
            }
            Behavior on y {
                     NumberAnimation { duration: 700 }
            }
        }

        Timekeeper{
            id: timekeeper;
            x: 285;y: 186
        }

        Luna  {
            id:luna;
            x: 162;y: 90
        }
    }
}
