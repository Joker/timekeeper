import QtQuick 2.1

import "wheels"

Item {
    id: clock
    width: 182; height: 182

    property int hours
    property int minutes
    property int seconds

    property string week_day
    property alias  week_bgd   : week_bg
    property alias  week_glass : glass
    property string gradient   : "#206f4a"

    function setDateTime(date) {
        clock.hours    = date.getHours();
        clock.minutes  = date.getMinutes();
        clock.seconds  = date.getSeconds();
        clock.week_day = Qt.formatDateTime(date, "ddd");
    }

    Wheels {
        id: whell
        x: -26;y: 137;
    }

    Rectangle {
        id: glass
        x: 77; y: 89; z: 5
        width: 20; height: 46
        opacity: 0.65
        visible: false
        gradient: Gradient {
            GradientStop { position: 0;    color: gradient  }
            GradientStop { position: 0.38; color: "#ffffff" }
            GradientStop { position: 0.57; color: "#ffffff" }
            GradientStop { position: 1;    color: gradient  }
        }
        rotation: 270
    }

    Image {
        id: background;
        z: 5
        source: "clock.png"

        MouseArea {
            id: in_out_ma
            x: 62; y: 86
            z: 7
            width: 11; height: 12
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                if (main.debug) {

                    Qt.createQmlObject("
                                    import QtQuick 2.0

                                    Rectangle {
                                        anchors.fill: parent
                                        color: \"transparent\"
                                        border.color: \"white\"
                                    }
                                ", this);
                }
            }

            onClicked: {
                clock.state === "out" ? clock.state = "in" : clock.state = "out";
                plasmoid.configuration.clockState = clock.state
            }
        }

        MouseArea {
            id: hide_ma
            x: 101; y: 86
            z: 7
            width: 11; height: 12
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                if (main.debug) {

                    Qt.createQmlObject("
                                    import QtQuick 2.0

                                    Rectangle {
                                        anchors.fill: parent
                                        color: \"transparent\"
                                        border.color: \"white\"
                                    }
                                ", this);
                }
            }

            onClicked: {
                whell.hide = !whell.hide
                plasmoid.configuration.whellState = whell.hide
            }
        }
    }

    Image { id: week_bg; x: 64; y: 102; z: 5;    source: "week_bg.png" }

    Text {
        x: 66; y: 104; z: 5
        width: 42; height: 17
        text: clock.week_day

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        font.pointSize: 10
        font.family: fixedFont.name
        color: "#333333"
    }

    Image {
        x: 77
        y: 74
        z: 5
        source: "center.png"

        MouseArea {
            id: center_ma
            x: 3
            y: 3
            z: 7
            width: 14
            height: 14
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                if (main.debug) {

                    Qt.createQmlObject("
                                    import QtQuick 2.0

                                    Rectangle {
                                        anchors.fill: parent
                                        color: \"transparent\"
                                        border.color: \"white\"
                                    }
                                ", this);
                }
            }

            onClicked:{
                if(main.state == "marble") timekeeper.state = ""
                if(main.state == "small") {main.state = "big"; luna.state = "home3"} else main.state = "small";
                plasmoid.configuration.mainState = main.state
            }
        }
    }

    Image {
        x: 75; y: 29; z: 5
        source: "hour.png"
        smooth: true

        transform: Rotation {
            id: hourRotation
            origin.x: 12; origin.y: 53;
            angle: (clock.hours * 30) + (clock.minutes * 0.5)
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        x: 79; y: 13; z: 5
        source: "minute.png"
        smooth: true

        transform: Rotation {
            id: minuteRotation
            origin.x: 8; origin.y: 69;
            angle: clock.minutes * 6
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        x: 85; y: 32; z: 5
        source: "second.png"
        smooth: true

        transform: Rotation {
            id: secondRotation
            origin.x: 2; origin.y: 21;
            angle: clock.seconds * 6
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image { x: 26; y: 10; z: 5; source: "clockglass.png"}

    states: [
        State { name: "out"; PropertyChanges { target: clock; x: -9; y: 42; } },
        State { name: "in";  PropertyChanges { target: clock; x: 29; y: 60; } }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 1000 }
        NumberAnimation { properties: "y"; duration: 700  }
    }
}
