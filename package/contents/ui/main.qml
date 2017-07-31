import QtQuick 2.1
import org.kde.plasma.plasmoid 2.0

import "clock"
import "clock/wheels"
import "terra"
import "calendar"
import "timekeeper"
import "otherside"
import "configscreen"

import "luna/phase.js"        as Moon
import "terra/planets.js"     as Eth
import "otherside/riseset.js" as RS

// import QtMultimediaKit 1.1 as QtMultimediaKit
// import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: main
    width: 478; height: 478

    property string terraImage: Plasmoid.configuration.terraImage

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    function onTerraImageChanged() {
        console.log("IT CHANGED!");
    }

    Plasmoid.compactRepresentation: Item {
        id: compact

        Plasmoid.backgroundHints: "NoBackground"

        property alias lx : luna.x
        property alias ly : luna.y
        property int count: 0

        property double lon: parseFloat(Plasmoid.configuration.lon)
        property double lat: parseFloat(Plasmoid.configuration.lat)

        property string fontPath: "clock/Engravers_MT.ttf"
        property int fontWeekSize: 11
        property int fontMonthSize:14

        property bool showCalendar: Plasmoid.configuration.showCalendar
        property int clockState: Plasmoid.configuration.clockState
        property bool hideCogs: !Plasmoid.configuration.showCogs
        property int whellState: Plasmoid.configuration.whellState
        property int stainedGlassState: Plasmoid.configuration.stainedGlassState

        property string terraState: Plasmoid.configuration.terraState

        property alias luna_terraState: luna.terraState

        property int yearFormat: Plasmoid.configuration.yearFormat

        ClockStates {
          id: clockPositionStates
        }

        StainedGlassStates {
          id: stainedGlassStates
        }

        TickMotionStates {
          id: tickMotionStates
        }

        onYearFormatChanged: timekeeper.yearFormat = yearFormat

        onStainedGlassStateChanged: timekeeper.stained_glass = stainedGlassStates.getStateName(stainedGlassState)

        onHideCogsChanged: whell.hide = compact.hideCogs

        onWhellStateChanged: wheelTick.state = tickMotionStates.getStateName(compact.whellState)

        onClockStateChanged: clock.state = clockPositionStates.getStateName(compact.clockState)

        onShowCalendarChanged: compact.state = compact.showCalendar ? "" : "small"

        FontLoader {
            id: fixedFont; source: fontPath;
            onStatusChanged: if (fixedFont.status == FontLoader.Error) console.log("Cannot load font")
        }

        Component.onCompleted: {
    /*
            // refresh moon image
            plasmoid.addEventListener("dataUpdated", dataUpdated);
            dataEngine("time").connectSource("Local", luna, 360000, PlasmaCore.AlignToHour);

            // plasmoid.setAspectRatioMode(ConstrainedSquare);
    // */
            defaultDate()

            console.log("Lat=" + lat.toString() + ", Lon=" + lon.toString())
            console.log("Sun Rise/Set")
            RS.sun_riseset (lat, lon, new Date())
            console.log("Moon Rise/Set")
            RS.moon_riseset(lat, lon, new Date())

            /*
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

            // calendar.ms = "calendar/Marble.qml"

            luna_terraState = compact.terraState

            clock.state = clockPositionStates.getStateName(compact.clockState)
            compact.state = compact.showCalendar ? "" : "small"
            whell.hide = compact.hideCogs
            wheelTick.state = tickMotionStates.getStateName(compact.whellState)
            timekeeper.stained_glass = stainedGlassStates.getStateName(compact.stainedGlassState)
            timekeeper.yearFormat = compact.yearFormat

            console.log("**** TODO: - Fix Lat-lon load");
            //var vlat = plasmoid.readConfig("lat")
            //var vlon = plasmoid.readConfig("lon")
            //if (vlat != 0 && vlon != 0 ){ lat = vlat; lon = vlon }
        }


        function nowTimeAndMoonPhase(today) {
            if (!today) today = new Date();

            Moon.touch(today)
            var age = Math.round(Moon.AGE)
            if ( age == 0 || age == 30 )
                luna.phase = 29
            else
                luna.phase = age

            if(luna.state != "big_moon" && compact.state != "small"){
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

                // It's now ticking at about 800ms - don't yet know what changed
                // it - was smooth a week ago. Use the ms value to make a fractional
                // value to get the angles - otherwise it pauses every 4 updates
                // when second does not change.
                var msecs = date.getMilliseconds()/1000.0

                //console.log("tick: " + clock.seconds.toString() + " (" + msecs.toString()+")")

                if(calendar.lock){
                    timekeeper.ang = (clock.seconds|3) * 6 * -1;
                    calendar.count_angle = Math.floor((clock.seconds + msecs) * 6);
                }
                if(whell.lock){
                    whell.ang = Math.floor((clock.seconds + msecs) * 6);
                }

                if(Qt.formatDateTime(date, "hhmmss") == "000000") defaultDate()

                if(compact.state == "marble" && clock.minutes%10  == 0 && clock.seconds%60 == 0 && calendar.ch){
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

                        yearFormat: compact.yearFormat

                        Item{
                            id: def
                            MouseArea {
                                id: color_ma
                                x: 131; y: 25
                                width: 9; height: 11
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {  // toggle stained glass colour
                                    // The left upper tick on the date selector window
                                    // Toggle the glass colour
                                    compact.stainedGlassState = stainedGlassStates.next(compact.stainedGlassState)
                                }
                            }
                            MouseArea {
                                id: flip_ma
                                x: 154; y: 96
                                width: 10; height: 24
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {  // toggle back/front
                                  // below the date selector
                                  // turns the device over. There is no back?
                                  // and nothing to click to return
                                  side.flipped = !side.flipped
                                }
                            }
                            MouseArea {
                                id: default_ma
                                x: 178; y: 32
                                width: 12; height: 14
                                onClicked: defaultDate()
                                cursorShape: Qt.PointingHandCursor
                            }
                        }

                        MouseArea {
                            id: marble_ma
                            x: 0; y: 49
                            width: 13; height: 14
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { // toggle marble state
                                /* Marble commented out for now
                                   TODO - fix marble
                                // if ((mouse.button == Qt.LeftButton) && (mouse.modifiers & Qt.ShiftModifier))
                                if(compact.state == "marble") {
                                    compact.state = ""
                                    calendar.state = ""
                                } else {
                                    compact.state = "marble";
                                    if(calendar.ch){
                                        calendar.mar.citylights_off();
                                        calendar.mar.citylights_on();
                                    }
                                }
                                */
                            }
                        }
                    }

                    MouseArea {
                        id: setings_ma
                        x: 388; y: 67
                        width: 10; height: 10
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if(conf.state == "up") conf.state = "down"
                                            else conf.state = "up"
                        }
                    }
                }
                Clock {
                    id: clock;
                    x: 29; y: 60; z: 5
            //        shift: 4
                    state: "in"


                    Wheels {
                        id: whell
                        x: -26;y: 137;

                        Item {
                            id: wheelTick

                            state: "off"

                            states: [
                                State {
                                    name: "off"
                                    PropertyChanges { target: whell; lock: false; ang: 0 }
                                    PropertyChanges { target: timekeeper; ang: 0 }
                                    PropertyChanges { target: calendar; lock: false; count_angle: 0 }
                                },
                                State {
                                    name: "wheel"
                                    PropertyChanges { target: whell; lock: true; ang: -10 }
                                    PropertyChanges { target: timekeeper; ang: 0 }
                                    PropertyChanges { target: calendar; lock: false; count_angle: 0 }
                                },
                                State {
                                    name: "calendar"
                                    PropertyChanges { target: whell; lock: true; ang: -10 }
                                    PropertyChanges { target: timekeeper; ang: 0 }
                                    PropertyChanges { target: calendar; lock: true; count_angle: 10 }
                                }
                            ]
                        }

                        MouseArea {
                            id: tiktak_ma
                            x: 41; y: 38
                            width: 14; height: 14
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                              compact.whellState = tickMotionStates.next(compact.whellState)
                            }
                        }
                    }


                    MouseArea { // centre of the clock
                        id: center_ma
                        x: 80; y: 76
                        width: 14; height: 14
                        cursorShape: Qt.PointingHandCursor

                        onClicked:{
                            // TODO include marble state
                            //if(compact.state == "marble")
                            //    calendar.state = ""

                            compact.showCalendar = !compact.showCalendar
                            //if (compact.showCalendar)
                            //    luna.state = "home3"
                        }
                    }
                    MouseArea {  // SW from centre of clock
                        id: in_out_ma
                        x: 62; y: 86
                        width: 11; height: 12
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            compact.clockState = clockPositionStates.next(compact.clockState);
                        }
                    }
                    MouseArea { // SE from centre of clock
                        id: hide_ma
                        x: 101; y: 86
                        width: 11; height: 12
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            compact.hideCogs = !compact.hideCogs
                        }

                    }
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
        ConfigScreen {
            id:conf
            x: 375; y: 74
    //        x: 105; y: 231
            width: 200; height: 150
        }

        // These states belong to compact.
        states: [
            State {
                name: "small"
                PropertyChanges {
                    target: calendar
                    scale: 0.3
                    rotation: 360
                    x: -119; y: -88
                }
                PropertyChanges { target: whell; hide:   true  }
                PropertyChanges { target: luna;  state: "home" }
            },
            State {
                name: "marble"
                PropertyChanges { target: def;      visible: false; }
                PropertyChanges { target: timekeeper; state: "out"; }
                PropertyChanges { target: clock;      state: "out"; }
                PropertyChanges { target: luna;       state: "big_earth"; moon_z: -1 }
            },
            State {
                name: "otherside"
                PropertyChanges { target: timekeeper; state: "otherside"; }
                PropertyChanges { target: luna;       state: "otherside"; }
            }
        ]
        transitions: [
            Transition {
                from: "*"; to: ""
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

}
