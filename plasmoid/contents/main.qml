import QtQuick 1.1
import "clock"
import "calendar"
import "luna"
import "clock/wheels"
import "timekeeper"
// import org.kde.plasma.core 0.1 as PlasmaCore
import "luna/phase.js" as Moon
import "luna/earth.js" as Eth

Rectangle {
    id: main
    width: 478; height: 478
    color: "transparent"

    property alias lx : luna.x
    property alias ly : luna.y
    property int count: 0

    FontLoader { id: fixedFont; source: "clock/Engravers_MT.ttf" }

    Component.onCompleted: {
/*
        // refresh moon image
        plasmoid.addEventListener("dataUpdated", dataUpdated);
        dataEngine("time").connectSource("Local", luna, 360000, PlasmaCore.AlignToHour);

        // plasmoid.setAspectRatioMode(ConstrainedSquare);
// */
        defaultDate()


        plasmoid.setBackgroundHints(NoBackground);
        // calendar.ms = "calendar/Marble.qml"
    }


    function toEarthMoonTime(today) {
        if(!today) today = new Date();

        Moon.touch(today)
        var age = Math.round(Moon.AGE)
        if( age == 0 || age == 30 ) luna.phase = 29
                               else luna.phase = age

        if(luna.state != "big_moon" && main.state != "small"){
            luna.earth_degree = Eth.angle(today)
            luna.moon_degree  = 180 + 12.41 * luna.phase
        }

        timekeeper.day   = Qt.formatDateTime(today, "dd")
        timekeeper.month = Qt.formatDateTime(today, "MMM")
        timekeeper.year  = Qt.formatDateTime(today, "yy")
    }

    function defaultDate(today) {
        if(!today) today = new Date();

        var MM = [0, -31, -62, -93, -123, -153, -182.5, -241.5, -300, -329.5]
        var month = today.getMonth()
        var date  = today.getDate()-1
        calendar.ring_degree = MM[month] - date;

        toEarthMoonTime(today)
        count = 0
        timekeeper.state = ""

//        var aDate = new Date();
//            aDate.setMonth(aDate.getMonth()+1, 0)
//        var num = aDate.getDate();
    }
    function timeChanged() {
        var date = new Date;
//        clock.hours    = clock ? date.getUTCHours()   + Math.floor(clock.shift)  : date.getHours()
//        clock.minutes  = clock ? date.getUTCMinutes() + ((clock.shift % 1) * 60) : date.getMinutes()

        clock.hours    = date.getHours()
        clock.minutes  = date.getMinutes()
        clock.seconds  = date.getSeconds()

        clock.day      = Qt.formatDateTime(date, "ddd")

        if(calendar.lock){
            calendar.count_angle  = clock.seconds * 6;
            timekeeper.cog    = (clock.seconds|3) * 6 * -1;
            timekeeper.cog_sh = (clock.seconds|3) * 6 * -1;
        }
        if(clock.lock){
            clock.whl         = clock.seconds * 6;
            clock.whl_sh      = clock.seconds * 6;
            clock.cog         = clock.seconds * 6 * -1;
            clock.cog_sh      = clock.seconds * 6 * -1;

        }
        if(Qt.formatDateTime(date, "hhmmss") == "000000") defaultDate()

        if(main.state == "marble" && clock.minutes%10  == 0 && clock.seconds%60 == 0 && calendar.ch){
            console.log(clock.seconds)
            calendar.mar.citylights_off();
            calendar.mar.citylights_on();
        }
        // console.log(clock.minutes)

    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: timeChanged()
    }



    Calendar {
        id:calendar;
        z: 1
        property bool ch: true

        Timekeeper{
            id: timekeeper;
            x: 285;y: 186;

            Item{
                id: def
                MouseArea {
                    x: 131; y: 25
                    width: 9; height: 11
                    onClicked: {
                        if(timekeeper.state != "green" ) {timekeeper.color = "purple"; timekeeper.state = "green" }
                                                    else {timekeeper.color = "green" ; timekeeper.state = "purple"}
                    }
                }
                MouseArea {
                    x: 154; y: 90
                    width: 10; height: 30
                }
                MouseArea {

                    x: 178; y: 32
                    width: 12; height: 14
                    onClicked: defaultDate()
                }
            }

            MouseArea {
                x: 0; y: 49
                width: 13; height: 14
                onClicked: {
                    // if ((mouse.button == Qt.LeftButton) && (mouse.modifiers & Qt.ShiftModifier))
                    if(main.state == "marble") {
                        main.state = ""; calendar.state = ""
                    } else {
                        main.state = "marble";
                        if(calendar.ch){
                            calendar.mar.citylights_off();
                            calendar.mar.citylights_on();
                        }
                    }
                }
            }
        }
    }
    Clock {
        id: clock;
        x: 29; y: 60
//        shift: 4
        state: "in"
        MouseArea {
            id: center
            x: 80; y: 76
            width: 14; height: 14

            onClicked:{
                if(main.state == "marble") calendar.state = ""
                if(main.state == "small") {main.state = "big"; luna.state = "home3"} else main.state = "small";
            }
        }
        MouseArea {
            id: in_out
            x: 62; y: 86
            width: 11; height: 12

            onClicked: {
                clock.state == "out" ? clock.state = "in" : clock.state = "out";
                if (clock.whl_state != "hide") clock.whl_state = clock.state;
            }
        }
        MouseArea {
            id: right
            x: 101; y: 86
            width: 11; height: 12

            onClicked: clock.whl_state == "hide" ? clock.whl_state = clock.state : clock.whl_state = "hide";
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
                x: -119; y: -88
            }
            PropertyChanges { target: clock; whl_state: "hide" }
            PropertyChanges { target: luna;  state: "home" }
        },
        State {
            name: "marble"
            PropertyChanges { target: timekeeper; state: "out"; }
            PropertyChanges { target: def;      visible: false; }
            PropertyChanges { target: clock;      state: "out"; whl_state: "out" }
            PropertyChanges { target: luna;       state: "big_earth"; moon_z: -1 }
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
