import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0
import org.kde.plasma.plasmoid 2.0

//time keeping
import "clock"
import "clock/wheels"
import "calendar"
import "timekeeper"

//solar system
import "orrery"
import "terra"

import "terra/luna/phase.js"        as Moon
import "terra/planets.js"     as Eth

Item {
    id: main
    readonly property int main_width: 478 * units.devicePixelRatio //540
    readonly property int main_height: 478 * units.devicePixelRatio

    width: main_width
    height: main_height

    Layout.minimumWidth: main_width
    Layout.minimumHeight: main_height
    Layout.preferredWidth: main_width
    Layout.preferredHeight: main_height
    Layout.maximumWidth: main_width
    Layout.maximumHeight: main_height

    Plasmoid.backgroundHints: "NoBackground"
    property alias lx : luna.x
    property alias ly : luna.y

    property int count: 0


    readonly property string fontName:   plasmoid.configuration.fontName
    readonly property int fontWeekSize:  11 //plasmoid.configuration.fontWeekSize
    readonly property int fontMonthSize: 11 //plasmoid.configuration.fontMonthSize

    property string mainState:         plasmoid.configuration.mainState
    property string clockState:        plasmoid.configuration.clockState
    property bool calendarLock:      plasmoid.configuration.calendarLock
    property bool whellLock:         plasmoid.configuration.whellLock
    property string stainedglassState: plasmoid.configuration.stainedglassState

    FontLoader {
        id:   fixedFont;
        name: fontName;
        source: "clock/Engravers_MT.ttf";
        onStatusChanged: {
            if (fixedFont.status == FontLoader.Error) console.log("Cannot load font");
            // console.log(fixedFont.name, fixedFont.source)
        }
    }

    Component.onCompleted: {
        defaultDate()

        clock.state              = clockState
        whell.lock               = whellLock
        calendar.stained_glass = stainedglassState
        timekeeper.lock            = calendarLock
        main.state               = mainState
    }


    function nowTimeAndMoonPhase(today) {
        if(!today) today = new Date();

        Moon.touch(today)
        var age = Math.round(Moon.AGE)
        if( age === 0 || age === 30 ) luna.phase = 29
                               else luna.phase = age

        if(luna.state != "big_moon" && main.state != "small"){
            luna.earth_degree = Eth.angle(today)
            luna.moon_degree  = 180 + 12.41 * luna.phase
        }

        var dtime = Qt.formatDateTime(today, "ddd,dd,MMM,yy,yyyy")
        var now = dtime.toString().split(",")
        clock.week_day   = now[0]
        calendar.day   = now[1]
        calendar.month = now[2]
        calendar.year  = now[3]
        calendar.yyyy  = now[4]
    }
    function defaultDate(today) {
        if(!today) today = new Date();

        var MM = [0, -31, -62, -93, -123, -153, -182.5, -212, -241.5, -270.5, -299.5, -329.2]
        var month = today.getMonth()
        var date  = today.getDate()-1
        timekeeper.ring_degree = MM[month] - date;

        nowTimeAndMoonPhase(today)
        count = 0
        calendar.stained_glass = ""
    }
    function forTimer() {
        var date = new Date;

        clock.hours    = date.getHours()
        clock.minutes  = date.getMinutes()
        clock.seconds  = date.getSeconds()
        if(!side.flipped){

            if(timekeeper.lock){
                calendar.ang = (clock.seconds|3) * 6 * -1;
                timekeeper.count_angle = clock.seconds * 6;
            }
            if(whell.lock){
                whell.ang = clock.seconds * 6;
            }

            if(Qt.formatDateTime(date, "hhmmss") == "000000") defaultDate()

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
            Timekeeper{
                id:timekeeper;
                z: 1
                property bool ch: true
            }

            Calendar{
                id: calendar;
                x: 285;y: 186;
                z: 10
                Item{
                    id: def
                    MouseArea {
                        id: color_ma
                        x: 131; y: 25
                        width: 9; height: 11
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            if(calendar.stained_glass == "purple" ) {
                                calendar.color = "purple";
                                calendar.stained_glass = "green"
                            } else if (calendar.stained_glass == "green") {
                                calendar.color = "";
                                calendar.stained_glass = ""
                            } else if (calendar.stained_glass == "") {
                                calendar.color = "green";
                                calendar.stained_glass = "purple"
                            }

                            plasmoid.configuration.stainedglassState = calendar.stained_glass
                        }
                    }
                    MouseArea {
                        id: flip_ma
                        x: 154; y: 96
                        width: 10; height: 24
                        cursorShape: Qt.PointingHandCursor
                        // onClicked: { side.flipped = !side.flipped }
                    }
                    MouseArea {
                        id: default_ma
                        x: 178; y: 32
                        width: 12; height: 14
                        cursorShape: Qt.PointingHandCursor

                        onClicked: defaultDate()
                    }
                }

                MouseArea {
                    id: solarSystem_ma
                    x: 0; y: 49
                    width: 13; height: 14
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        if(main.state != "solarSystem") {
                            main.state = "solarSystem";
                        } else {
                            main.state = ""; timekeeper.state = ""
                        }

                        plasmoid.configuration.mainState = main.state
                    }
                }
            }
            Clock {
                id: clock;
                x: 29; y: 60;
                z: 10
                state: "in"

                Wheels {
                    id: whell
                    x: -26;y: 137;

                    MouseArea {
                        id: tiktak_ma
                        x: 41; y: 38
                        width: 14; height: 14
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            if(!whell.lock){
                                whell.ang = -10
                                whell.lock = !whell.lock
                            } else if(!timekeeper.lock){
                                timekeeper.count_angle = 10
                                timekeeper.lock = !timekeeper.lock
                            } else {
                                whell.lock = !whell.lock
                                timekeeper.lock = !timekeeper.lock

                                whell.ang = 0
                                calendar.ang = 0
                                timekeeper.count_angle = 0
                            }
                            plasmoid.configuration.calendarLock = timekeeper.lock
                            plasmoid.configuration.whellLock = whell.lock
                        }
                    }
                }


                MouseArea {
                    id: center_ma
                    x: 80; y: 76
                    width: 14; height: 14
                    cursorShape: Qt.PointingHandCursor

                    onClicked:{
                        if(main.state == "marble") timekeeper.state = ""
                        if(main.state == "small") {main.state = "big"; luna.state = "home3"} else main.state = "small";
                        plasmoid.configuration.mainState = main.state
                    }
                }
                MouseArea {
                    id: in_out_ma
                    x: 62; y: 86
                    width: 11; height: 12
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        clock.state == "out" ? clock.state = "in" : clock.state = "out";
                        plasmoid.configuration.clockState = clock.state
                    }
                }
                MouseArea {
                    id: hide_ma
                    x: 101; y: 86
                    width: 11; height: 12
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        whell.hide = !whell.hide
                        plasmoid.configuration.whellState = whell.hide
                    }

                }
            }

            Terra {
                id:luna;
                x: 162; y: 90
                z: 5
            }

        }

        states: [
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
                target: timekeeper
                scale: 0.3
                rotation: 360
                x: -119; y: -88
            }
            PropertyChanges {
                target: calendar
                scale: 0.3
                x: 10; y: 20
                z: 1
            }
            PropertyChanges { target: whell}
            PropertyChanges { target: luna;  state: "home" }
        },
        State {
            name: "marble"
            PropertyChanges { target: def;      visible: false; }
            PropertyChanges { target: calendar; state: "out"; }
            PropertyChanges { target: clock;      state: "out"; }
            PropertyChanges { target: luna;       state: "big_earth"; moon_z: -1 }
        },
        State {
            name: "solarSystem"
            PropertyChanges { target: def;      visible: false; }
            PropertyChanges { target: calendar; state: "out"; }
            PropertyChanges { target: clock;      state: "out"; }
            PropertyChanges { target: luna;       state: "home"; moon_z: -1 }
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
