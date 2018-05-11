import QtQuick 2.1
import "../luna"

Item {
    id: home;
    width: 152; height: 152

    property alias  moon_degree: moon_angle.angle
    property alias  phase: svg.phase
    property int    earth_degree: 0
    property alias  moon_z: moon.z

    property string terraImage: plasmoid.configuration.terraImage
    property string terraState: plasmoid.configuration.terraState


    Component.onCompleted: {
        home.state = terraState
    }

    Item {
        id:terra
        x: 34; y: 34
        width: 84; height: 84

        Image {
            id: earth
            x: 8; y: 8
            property int  rot: 0
            
            source: "animation/earth0.png"; smooth: true; anchors.centerIn: parent; anchors.fill: parent
            
            Image { id: earth_sh; width: 84; height: 84; x: earth.x + 9; y: earth.y + 9; z: -1; smooth: true; source: "earthUnderShadow.png" }

            transform: Rotation {
                id: rotation
                origin.x: earth.width/2
                origin.y: earth.height/2
                axis.x: 1; axis.y: 0; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }

            transitions: Transition {
                SpringAnimation { target: rotation; property: "angle";  spring: 4; damping: 0.3; modulus: 360 ;mass :3}
            }
            
            Timer {
                id: spin_ani
                interval: 60000; 
                repeat: true;
                running: true
                triggeredOnStart: true
                property int hours
                property int minutes
                onTriggered: { 
                    var date = new Date;
                    hours    = date.getHours();
                    minutes  = date.getMinutes();
                    
                    earth.rot = hours * 4 + Math.round(minutes / 15);
                    console.log(hours);
        
                    if(earth.rot >= 96){ 
                        earth.rot = 0; 
                    } else {
                        earth.rot += 1; 
                    }
                    var img = "animation/earth"+earth.rot+".png";

                    earth.source = img;
                }
            }
        }

    }

    Item {
        id: moon
        x: 60; y: 0
        width: 33; height: 33

        Image { id: moon_big_sh; x: -9; y: -8; smooth: true; source: "moonBigShadow.png";  opacity: 0; }
        Image { id: moon_sh;     x: -6; y: -6; smooth: true; source: "moonUnderShadow.png" }
        Luna  { id: svg }

        transform: Rotation {
            id:moon_angle
            origin.x: 17.5; origin.y: 76;
            // angle: 185 + 12.41 * phase // degree //
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }

        MouseArea {
            x: 60; y: 0
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                home.state == "big_moon" ? home.state = "" : home.state = "big_moon";
                
                plasmoid.configuration.terraState = home.state
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
            PropertyChanges { target:main; lx: 162 ;  ly: 165         }
            PropertyChanges { target:home; moon_degree: 0; earth_degree: 0 }

            PropertyChanges { target: calendar.moon_l; visible: true }
            PropertyChanges { target: calendar.moon_r; visible: true }
        },
        State {
            name: "home"
            PropertyChanges { target:home; moon_degree: 0; earth_degree: 0; }
            onCompleted: luna.state = "home2"
        },
        State {
            name: "home2"
            extend: "home"
            PropertyChanges { target:home; z: 4 }
            PropertyChanges { target:main; lx: clock.x+10 ;  ly: clock.y+10 }
        },
        State {
            name: "home3"
            PropertyChanges { target:home; moon_degree: 0; earth_degree: 0;  z: 4 }
            PropertyChanges { target:main; lx: 150 ;  ly: 150 }
            onCompleted: luna.state = ""
        },
        State {
            name: "big_earth"
            PropertyChanges { target: main;     lx: 162 ; ly: 167 }
            PropertyChanges { target: home;     moon_degree: 0; earth_degree: 0; }
            PropertyChanges { target: earth;    x:-58; y: -57;  width: 200; height: 200 }
            onCompleted: {calendar.state = "earth"; home.state = "big_earth2"}
        },
        State {
            name: "big_earth2"
            extend: "big_earth"
            // TODO marble
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
            NumberAnimation { properties: "earth_degree, degree,x,y, width,height, lx,ly"; duration: 1500; easing.type: Easing.InOutBack; }
        },
        Transition {
            from: "big_earth"; to: "big_earth2"
            NumberAnimation { properties: "opacity"; duration: 2000;}
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
