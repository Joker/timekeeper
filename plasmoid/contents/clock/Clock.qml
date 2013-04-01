import QtQuick 1.1
import "wheels"

Item {
    id: clock
    width: 182; height: 182

    property int hours
    property int minutes
    property int seconds
    property real shift
    property string day
    property alias whell_st : whell.state
    property alias whell_x  : whell.x
    property alias whell_y  : whell.y
    property alias wr : wr_img.rotation
    property alias wrs: wrs_img.rotation
    property alias wc : wc_img.rotation
    property alias wcs: wcs_img.rotation
    property bool lock: false

    Item{
        id: whell
        x: -26;y: 137

        width: 132; height: 93
        Image {
            id: wcs_img
            x: 43; y: -5;
            source: "wheels/cogShadow.png"
            smooth: true;
            Behavior on rotation {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
        Image {
            id: wc_img
            x: 50; y: -17;
            width: 82; height: 84;
            source: "wheels/cog.png"
            smooth: true;
            Behavior on rotation {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
        Image {
            id: wrs_img
            x: 3; y: 2;
            source: "wheels/wheelShadow.png"
            smooth: true;
            Behavior on rotation {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
        Image {
            id: wr_img
            source: "wheels/wheel.png"
            smooth: true;
            Behavior on rotation {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
        Image {
            x: 26; y: 2;
            source: "wheels/driveBand.png"
            MouseArea {
                id: cog
                x: 15; y: 36
                width: 14; height: 14
                onClicked: {
                    //console.log(calendar.lock, lock )
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
                }
            }
        }

        state: "in"

        states: [
            State {
                name: "hide"
                PropertyChanges { target: whell; x: 10; y: 25; }
            },
            State {
                name: "out"
                PropertyChanges { target: whell; x: -5; }
            },
            State {
                name: "in"
                PropertyChanges { target: whell; x: -26; y: 137; }
            }
        ]

        Behavior on x {
                 NumberAnimation { duration: 1500 }
        }
        Behavior on y {
                 NumberAnimation { duration: 800 }
        }

    } // x: -13;y: 178

    Image { id: background; source: "clock.png" }
    Image { x: 77; y: 74;  source: "center.png" }

    Text {
        x: 67; y: 104
        text: clock.day
        font.pointSize: 11
        font.family: fixedFont.name
        color: "#333333"

    }

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
}
