import QtQuick 1.1

import "clock"
import "clock/wheels"
import "terra"
import "calendar"
import "timekeeper"
import "otherside"
import "config"

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

    property string fontPath: "clock/Engravers_MT.ttf"
    property int fontWeekSize: 11
    property int fontMonthSize:14
    FontLoader { id: fixedFont; source: fontPath }

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


        var mainState         = plasmoid.readConfig("mainState").toString();
        var clockState        = plasmoid.readConfig("clockState").toString();
        var whellState        = plasmoid.readConfig("whellState").toString();
        var stainedglassState = plasmoid.readConfig("stainedglassState").toString();

        clock.state      = clockState
        main.state       = mainState
        clock.whl_state  = whellState
        timekeeper.stained_glass = stainedglassState

        var vlat = plasmoid.readConfig("lat")
        var vlon = plasmoid.readConfig("lon")
        if (vlat != 0 && vlon != 0 ){ lat = vlat; lon = vlon }
    }


    function nowTimeAndMoonPhase(today) {
        if(!today) today = new Date();

        Moon.touch(today)
        var age = Math.round(Moon.AGE)
        if( age == 0 || age == 30 ) luna.phase = 29
                               else luna.phase = age

        if(luna.state != "big_moon" && main.state != "small"){
            luna.earth_degree = Eth.angle(today)
            luna.moon_degree  = 180 + 12.41 * luna.phase
        }

        var dtime = Qt.formatDateTime(today, "ddd,dd,MMM,yy,yyyy")
        var now = dtime.toString().split(",")
        clock.week_day   = now[0]
        timekeeper.day   = now[1]
        timekeeper.month = now[2]
        timekeeper.year  = now[3]
        timekeeper.yyyy  = now[4]
    }
    function defaultDate(today) {
        if(!today) today = new Date();

        var MM = [0, -31, -62, -93, -123, -153, -182.5, -212, -241.5, -270.5, -299.5, -329.2]
        var month = today.getMonth()
        var date  = today.getDate()-1
        calendar.ring_degree = MM[month] - date;

        nowTimeAndMoonPhase(today)
        count = 0
        timekeeper.stained_glass = ""

//        var aDate = new Date();
//            aDate.setMonth(aDate.getMonth()+1, 0)
//        var num = aDate.getDate();
    }
    function forTimer() {
        var date = new Date;

        clock.hours    = date.getHours()
        clock.minutes  = date.getMinutes()
        clock.seconds  = date.getSeconds()
        if(!side.flipped){

            if(calendar.lock){
                timekeeper.ang = (clock.seconds|3) * 6 * -1;
                calendar.count_angle = clock.seconds * 6;
            }
            if(clock.lock){
                clock.whl_angle = clock.seconds * 6;
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
        id: time
        interval: 1000; running: true; repeat: true;
        onTriggered: forTimer()
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
                            id: color_ma
                            x: 131; y: 25
                            width: 9; height: 11
                            onClicked: {
                                if(timekeeper.stained_glass != "green" ) {timekeeper.color = "purple"; timekeeper.stained_glass = "green" }
                                                                    else {timekeeper.color = "green" ; timekeeper.stained_glass = "purple"}

                                plasmoid.writeConfig("stainedglassState", timekeeper.stained_glass);
                            }
                        }
                        MouseArea {
                            id: flip_ma
                            x: 154; y: 96
                            width: 10; height: 24
                            // onClicked: { side.flipped = !side.flipped }
                        }
                        MouseArea {
                            id: default_ma
                            x: 178; y: 32
                            width: 12; height: 14
                            onClicked: defaultDate()
                        }
                    }

                    MouseArea {
                        id: marble_ma
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

                MouseArea {
                    id: setings_ma
                    x: 388; y: 67
                    width: 10; height: 10
                    onClicked: {

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
    Config {
        x: 375; y: 74
//        x: 105; y: 231
        width: 200; height: 150
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
