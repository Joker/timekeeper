import QtQuick 1.1

import "clock"
import "clock/wheels"
import "terra"
import "calendar"
import "timekeeper"
import "otherside"

import "luna/phase.js"        as Moon
import "terra/planets.js"     as Eth
import "otherside/riseset.js" as RS

// import QtMultimediaKit 1.1 as QtMultimediaKit
// import org.kde.plasma.core 0.1 as PlasmaCore

Rectangle {
    id: main
    width: 478; height: 478
    color: "transparent"

    property alias lx : luna.x
    property alias ly : luna.y
    property int count: 0

    property double lon: 37.620789
    property double lat: 55.750513

    FontLoader { id: fixedFont; source: "clock/Engravers_MT.ttf" }

    Component.onCompleted: {
/*
        // refresh moon image
        plasmoid.addEventListener("dataUpdated", dataUpdated);
        dataEngine("time").connectSource("Local", luna, 360000, PlasmaCore.AlignToHour);

        // plasmoid.setAspectRatioMode(ConstrainedSquare);
// */
        defaultDate()
/*
        RS.sun_riseset (lat, lon, new Date())
        RS.moon_riseset(lat, lon, new Date())

        var sinkS = {
          dataUpdated: function (name, data) {
            console.log(data.Sunrise, data.Sunset);
          }
        };
        var sinkM = {
          dataUpdated: function (name, data) {
            console.log(data.Moonrise, data.Moonset);
          }
        };
        var intervalInMilliSeconds = 3600000 // evrey hour ; 86400000 - one day
        dataEngine("time").connectSource("Local|Solar|Latitude="+lat+"|Longitude="+lon, sinkS, intervalInMilliSeconds)
        dataEngine("time").connectSource( "Local|Moon|Latitude="+lat+"|Longitude="+lon, sinkM, intervalInMilliSeconds)
// */
        plasmoid.setBackgroundHints(NoBackground);
        // calendar.ms = "calendar/Marble.qml"


        var mainState       = plasmoid.readConfig("mainState").toString();
        var clockState      = plasmoid.readConfig("clockState").toString();
        var whellState      = plasmoid.readConfig("whellState").toString();
        var timekeeperState = plasmoid.readConfig("timekeeperState").toString();

        if (clockState.length > 0)      { clock.state      = clockState }
        if (whellState.length > 0)      { clock.whl_state  = whellState }
        if (timekeeperState.length > 0) { timekeeper.state = timekeeperState }
        if (mainState.length > 0)       { main.state       = mainState }

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

        var MM = [0, -31, -62, -93, -123, -153, -182.5, -212, -241.5, -270.5, -299.5, -329.2]
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
        if(!side.flipped){
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
                //console.log(clock.seconds)
                calendar.mar.citylights_off();
                calendar.mar.citylights_on();
            }
        }else{

        }
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: timeChanged()
    }


    Flipable {
        id: side
        property bool flipped: false
        //anchors.left: parent.left
        //anchors.leftMargin: 30

        front: Item {
            width: 478; height: 478
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
                                plasmoid.writeConfig("timekeeperState", timekeeper.state);
                            }
                        }
                        MouseArea {
                            x: 154; y: 96
                            width: 10; height: 24
                            // onClicked: { side.flipped = !side.flipped }
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
                            plasmoid.writeConfig("mainState", main.state);
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
                        plasmoid.writeConfig("mainState", main.state);
                    }
                }
                MouseArea {
                    id: in_out
                    x: 62; y: 86
                    width: 11; height: 12

                    onClicked: {
                        clock.state == "out" ? clock.state = "in" : clock.state = "out";
                        if (clock.whl_state != "hide") clock.whl_state = clock.state;
                        plasmoid.writeConfig("clockState", clock.state);
                    }
                }
                MouseArea {
                    id: right
                    x: 101; y: 86
                    width: 11; height: 12

                    onClicked: {
                        clock.whl_state == "hide" ? clock.whl_state = clock.state : clock.whl_state = "hide";
                        plasmoid.writeConfig("whellState", clock.whl_state);
                    }

                }

                z: 5
            }
            Terra {
                id:luna;
                x: 162; y: 90
                z: 7
            }

        }
        back: Item {
            width: 478; height: 478
            Otherside {
                z: 1
            }
        }

        states: [
            State {
                name: "otherside"
                PropertyChanges { target: rotation; angle: 180 }
                when: side.flipped
            },
            State {
                name: "calendar"
                PropertyChanges { target: rotation; angle: 0 }
                when: !side.flipped
            }
        ]
        transform: Rotation {
            id: rotation
            origin.x: 239; origin.y: 239
            axis.x: 1; axis.y: 0; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: 0    // the default angle
        }
        transitions: Transition {
            // NumberAnimation { target: rotation; property: "angle";  duration: 400 }
            SpringAnimation { target: rotation; property: "angle";  spring: 4; damping: 0.3; modulus: 360 ;mass :4;}// velocity: 490}
        }
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
        },
        State {
            name: "otherside"
            PropertyChanges { target: clock; whl_state: "hide"; x: -20;y: 309}
            PropertyChanges { target: timekeeper; state: "otherside"; }
            PropertyChanges { target: luna;       state: "otherside"; }
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
