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

Item {
    id: main
    width: 478; height: 478

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

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

        // There are two sets of property values because I want config
        // dialog changes to be applied and remembered, but I only want
        // UI changes to apply for the session.

        // These properties change if the config changes
        property bool settingsShowCalendar: Plasmoid.configuration.showCalendar
        property int settingsClockState: Plasmoid.configuration.clockState
        property bool settingsHideCogs: !Plasmoid.configuration.showCogs
        property int settingsWhellState: Plasmoid.configuration.whellState
        property int settingsStainedGlassState: Plasmoid.configuration.stainedGlassState
        property int settingsYearFormat: Plasmoid.configuration.yearFormat
        property int settingsTerraImageIndex: Plasmoid.configuration.terraImageIndex
        property int settingsTerraState: Plasmoid.configuration.terraState

        // These properties are initially set as the config, but are then
        // changed by the on-screen switches OR the matching config is changed.
        property bool showCalendar: Plasmoid.configuration.showCalendar
        property int clockState: Plasmoid.configuration.clockState
        property bool hideCogs: !Plasmoid.configuration.showCogs
        property int whellState: Plasmoid.configuration.whellState
        property int stainedGlassState: Plasmoid.configuration.stainedGlassState
        property int yearFormat: Plasmoid.configuration.yearFormat
        property string terraImage: ""
        property int terraState: Plasmoid.configuration.terraState

        ClockStates {
          id: clockPositionStates
        }

        StainedGlassStates {
          id: stainedGlassStates
        }

        TickMotionStates {
          id: tickMotionStates
        }

        TerraImageChoices {
            id: terraImageChoices
        }

        TerraStates {
            id: terraStates
        }

        // These events occur when the config values are changed. The new
        // values are copied to ones used for the displayed state.
        onSettingsShowCalendarChanged: showCalendar = settingsShowCalendar
        onSettingsClockStateChanged: clockState = settingsClockState
        onSettingsHideCogsChanged: hideCogs = settingsHideCogs
        onSettingsWhellStateChanged: whellState = settingsWhellState
        onSettingsStainedGlassStateChanged: stainedGlassState = settingsStainedGlassState
        onSettingsYearFormatChanged: yearFormat = settingsYearFormat
        onSettingsTerraImageIndexChanged: {
            terraImage = terraImageChoices.getFilename(settingsTerraImageIndex)
        }
        onSettingsTerraStateChanged: terraState = settingsTerraState

        // These react to the GUI state variables changing - affected by
        // config changes or using the GUI switches.
        onShowCalendarChanged: compact.state = compact.showCalendar ? "big" : "small"
        onClockStateChanged: clock.state = clockPositionStates.getStateName(compact.clockState)
        onHideCogsChanged: whell.hide = compact.hideCogs
        onWhellStateChanged: wheelTick.state = tickMotionStates.getStateName(compact.whellState)
        onStainedGlassStateChanged: timekeeper.stained_glass = stainedGlassStates.getStateName(stainedGlassState)
        onYearFormatChanged: timekeeper.yearFormat = yearFormat
        onTerraImageChanged: luna.terraImage = compact.terraImage
        onTerraStateChanged: luna.terraState = terraStates.getStateName(compact.terraState)

        FontLoader {
            id: fixedFont; source: fontPath;
            onStatusChanged: if (fixedFont.status == FontLoader.Error) console.log("Cannot load font")
        }

        Component.onCompleted: {

            defaultDate()

            RS.sun_riseset (lat, lon, new Date())
            RS.moon_riseset(lat, lon, new Date())

            //TODO - fix Marble
            // calendar.ms = "calendar/Marble.qml"

            clock.state = clockPositionStates.getStateName(compact.clockState)
            compact.state = compact.showCalendar ? "big" : "small"
            whell.hide = compact.hideCogs
            wheelTick.state = tickMotionStates.getStateName(compact.whellState)
            timekeeper.stained_glass = stainedGlassStates.getStateName(compact.stainedGlassState)
            timekeeper.yearFormat = compact.yearFormat
            luna.terraImage = compact.terraImage
            luna.terraState = terraStates.getStateName(compact.terraState)
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
        }

        function forTimer() {
            var date = new Date;

            clock.hours    = date.getHours()
            clock.minutes  = date.getMinutes()
            clock.seconds  = date.getSeconds()
            if(!side.flipped){

                // Timer freqency is nominally 1000ms but need to allow for the
                // elapsed time delta to be over/under this value. Use millisecs
                // value where this matters.
                var msecs = date.getMilliseconds()/1000.0

                if(calendar.lock){
                    timekeeper.ang = (clock.seconds|3) * 6 * -1;
                    calendar.count_angle = Math.floor((clock.seconds + msecs) * 6);
                }
                if(whell.lock){
                    whell.ang = Math.floor((clock.seconds + msecs) * 6);
                }

                if(Qt.formatDateTime(date, "hhmmss") == "000000") defaultDate()

                if(compact.state == "marble" && clock.minutes%10  == 0 && clock.seconds%60 == 0 && calendar.ch){
                    calendar.mar.citylights_off();
                    calendar.mar.citylights_on();
                }

            } else {
                // TODO Animate the rear view
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
                            cond.state = (conf.state == "up") ? "down" : "up"
                        }
                    }
                }
                Clock {
                    id: clock;
                    x: 29
                    y: 60
                    z: 5
                    state: "in"

                    Wheels {
                        id: whell
                        x: -26
                        y: 137

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
                            x: 41
                            y: 38
                            width: 14
                            height: 14
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                              compact.whellState = tickMotionStates.next(compact.whellState)
                            }
                        }
                    }


                    MouseArea { // centre of the clock
                        id: center_ma
                        x: 80
                        y: 76
                        width: 14
                        height: 14
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
                        x: 62
                        y: 86
                        width: 11
                        height: 12
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            compact.clockState = clockPositionStates.next(compact.clockState);
                        }
                    }
                    MouseArea { // SE from centre of clock
                        id: hide_ma
                        x: 101
                        y: 86
                        width: 11
                        height: 12
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            compact.hideCogs = !compact.hideCogs
                        }

                    }
                }
                Terra {
                    id:luna;
                    x: 162
                    y: 90
                    z: 7
                }

            }

            back: Item {
                width: 478
                height: 478
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
                origin.x: 239
                origin.y: 239
                axis.x: 1
                axis.y: 0
                axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }
            transitions: Transition {
                // NumberAnimation { target: rotation; property: "angle";  duration: 400 }
                SpringAnimation { target: rotation; property: "angle";  spring: 4; damping: 0.3; modulus: 360 ;mass :4;}// velocity: 490}
            }
        }
        ConfigScreen {
            id:conf
            x: 375
            y: 74
            width: 200
            height: 150
        }

        // These states belong to compact.
        states: [
            State {
                name: "small"
                PropertyChanges {
                    target: calendar
                    scale: 0.3
                    rotation: 360
                    x: -119
                    y: -88
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

}
