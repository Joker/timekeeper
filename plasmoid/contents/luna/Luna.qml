import QtQuick 1.1

Item {
    id: home;
    width: 152; height: 152

    property string svg_sourse: "luna-gskbyte13.svg"
    property double degree: 0
    property int    phase: 29
    property int    earth_degree: 0
    property alias  moon_z: moon.z
    //state: "home3"

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
        Image { id: moon_big_sh; x: -9; y: -8; opacity: 0; smooth: true; source: "moonBigShadow.png" }
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
                target: moon_big_sh
                opacity:1
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
            PropertyChanges { target:main; lx: 162 ;  ly: 165         }
            PropertyChanges { target:home; degree: 0; earth_degree: 0 }
        },
        State {
            name: "home"
            PropertyChanges { target:home; degree: 0; earth_degree: 0; }
            onCompleted: luna.state = "home2"
        },
        State {
            name: "home2"
            PropertyChanges { target:home; degree: 0; earth_degree: 0; z: 4 }
            PropertyChanges { target:main; lx: clock.x+10 ;  ly: clock.y+10 }
        },
        State {
            name: "home3"
            PropertyChanges { target:home; degree: 0; earth_degree: 0;  z: 4 }
            PropertyChanges { target:main; lx: 150 ;  ly: 150 }
            onCompleted: luna.state = ""
        },
        State {
            name: "big_earth"
            PropertyChanges { target:home; degree: 0; earth_degree: 0; }
            PropertyChanges {
                target: earth
                x: -65; y: -65
                width: 215; height: 215

            }
            PropertyChanges { target:main; lx: 162 ;  ly: 167 }
            onCompleted:  {calendar.state = "earth"; home.state = "big_earth2"}
        },
        State {
            name: "big_earth2"
            PropertyChanges { target:home; degree: 0; earth_degree: 0; }
            PropertyChanges {
                target: earth
                x: -65; y: -65
                width: 215; height: 215
                opacity: 0
            }
            PropertyChanges { target:main; lx: 162 ;  ly: 167 }
            PropertyChanges { target: earth_sh; visible: false }
            PropertyChanges { target: moon;     visible: false }

        }
    ]

    transitions: [
        Transition {
            NumberAnimation { properties: "earth_degree, x,y, width,height, lx,ly"; duration: 1500; easing.type: Easing.InOutBack; } //InOutBack

        },
        Transition {
            from: "*"; to: "big_moon"
            NumberAnimation { properties: "earth_degree, x,y, width,height, lx,ly"; duration: 1500; easing.type: Easing.InOutBack; }
            NumberAnimation { properties: "opacity"; duration: 1200;  easing.type: Easing.InExpo}
        },
        Transition {
            from: "home"; to: "home2"
            NumberAnimation { properties: "lx,ly"; duration: 600; easing.type: Easing.InOutBack; }
        },
        Transition {
            from: "*"; to: "home3"
            NumberAnimation { properties: "lx,ly"; duration: 1500;}
        },
        Transition {
            from: "*"; to: "big_earth"
            NumberAnimation { properties: "earth_degree, degree,x,y, width,height, lx,ly"; duration: 1000;}
        },
        Transition {
            from: "big_earth"; to: "big_earth2"
            NumberAnimation { properties: "opacity"; duration: 300;}
        },
        Transition {
            from: "big_earth2"; to: "*"
            NumberAnimation { properties: "earth_degree, degree,x,y, width,height, lx,ly"; duration: 900;}
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
