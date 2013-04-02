import QtQuick 1.1

Item {
    id: home
    width: 152; height: 152

    property string svg_sourse: "luna-gskbyte13.svg"
    property double degree: 0
    property int    phase: 29
    property int    earth_degree: 0
    //state: "big_moon"

    Item {
        x: 34; y: 34
        width: 84; height: 84
        Image {id: earth_sh; x: 1; y: 1; smooth: true; source: "earthUnderShadow.png" }
        Image {id: earth;    x: 8; y: 8; smooth: true; source: "earth.png" }
    }

    Item {
        id: moon
        x: 60; y: 0
        width: 33; height: 33
        Image { id: moon_sh; x: -6; y: -6; smooth: true; source: "moonUnderShadow.png" }
        Image {
            id: svg
            source: home.svg_sourse
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            smooth: true;
        }

        transform: Rotation {
            id:moon_angle
            origin.x: 17.5; origin.y: 76;
            angle: degree
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }

        MouseArea {
            id: mousearea1
            x: 60; y: 0
            anchors.fill: parent

            onClicked: {
                home.state == "big_moon" ? home.state = "" : home.state = "big_moon";
            }
        }
    }

    states: [
        State {
            name: "big_moon"
            PropertyChanges {
                target: moon
                x: 16; y: 16
                width: 120; height: 120
            }
            PropertyChanges {
                target: moon_sh
                x: 38; y: 37
                visible: false
            }
            PropertyChanges {
                target: earth
                x: 30; y: 30
                width: 25;height: 25
            }
            PropertyChanges {
                target: earth_sh
                x: 27; y: 26
                width: 31;height: 32
            }
            PropertyChanges { target:calendar; lx: 162 ;  ly: 165         }
            PropertyChanges { target:home;     degree: 0; earth_degree: 0 }
        }
//        State {
//            name: "home"
//            onCompleted: luna.state = "big_moon"
//        }
    ]

    transitions: [
        // from: "*"; to: "bottomLeft"
        Transition {
            NumberAnimation { properties: "opacity, earth_degree, x,y, width,height, lx,ly"; duration: 1500; easing.type: Easing.InOutBack; } //InOutBack
        }

    ]

    transform: Rotation {
        id: luna_angle
        origin.x: 76.5; origin.y: 152;
        angle:earth_degree
        Behavior on angle {
            SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
        }
    }
}
