import QtQuick 1.1
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

    property alias whl_state : whell.state
    property alias whl_x     : whell.x
    property alias whl_y     : whell.y
    property alias whl_angle : whell.ang

    property bool lock: false

    Wheels {
        id: whell
        x: -26;y: 137

        MouseArea {
            x: 41; y: 38
            width: 14; height: 14
            onClicked: {
                if(!lock){
                    lock = !lock
                    return
                }
                if(!calendar.lock){
                    calendar.lock = !calendar.lock
                    return
                }
                lock = !lock
                calendar.lock = !calendar.lock

                whell.ang = 0
                timekeeper.ang = 0
                calendar.count_angle = 0
            }
        }
    }

    Rectangle {
        id: glass
        x: 77; y: 89
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
    Image { id: background; source: "clock_old.png" }
    Image { id: week_bg; x: 64; y: 102;    source: "week_bg.png" }
    Text {
        x: 66; y: 104
        width: 42; height: 17
        text: clock.week_day
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: main.fontWeekSize
        font.family: fixedFont.name
        color: "#333333"

    }

    Image { x: 77; y: 74;  source: "center.png" }

    Image {
        x: 75; y: 29
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
        x: 79; y: 13
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
        x: 85; y: 32
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

    Image { x: 26; y: 10; source: "clockglass.png"}

    states: [
        State { name: "out"; PropertyChanges { target: clock; x: -9; y: 42; } },
        State { name: "in";  PropertyChanges { target: clock; x: 29; y: 60; } }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 1000 }
        NumberAnimation { properties: "y"; duration: 700  }
    }
}
