import QtQuick 1.1

Item{
    id: whell
    property real ang

    width: 132; height: 93
    Image {
        x: 43; y: -5;
        source: "cogShadow.png"
        smooth: true;
        transform: Rotation {
            angle: ang * -1
            origin.x: 95.0; origin.y: 47.0;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        x: 50; y: -17;
        width: 82; height: 84;
        source: "cog.png"
        smooth: true;
        transform: Rotation {
            angle: ang * -1
            origin.x: 91.0; origin.y: 25.0;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        x: 3; y: 2;
        source: "wheelShadow.png"
        smooth: true;
        transform: Rotation {
            angle: ang
            origin.x: 51.0; origin.y: 50.0;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        source: "wheel.png"
        smooth: true;
        transform: Rotation {
            angle: ang
            origin.x: 47.0; origin.y: 46.0;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        x: 26; y: 2;
        source: "driveBand.png"
        MouseArea {
            id: cog
            x: 15; y: 36
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

}
