import QtQuick 1.1
import "../luna"
import "../clock/back"

Item {
    id: other
    width: 478; height: 478

    Image { id: bg;       source: "bg2.png";          x: 2; y: 0; }
    Image { id: surround; source: "../calendar/woodSurround.png"; }

    Back {
        x: -15; y: 9; z: -1
    }


//Image { x: 239; y: 239; width: 76; height: 160; source: "zxc.png"}
// x: 239; y: 79; height: 160;

    Item {
        id: sun
        x: 201
        y: 41
        width: 76
        height: 76
        property double an: 0
        property double pr: 0
        Item {
            id: s_up
            width: 76
            height: 38
            anchors.top: parent.top
            clip: true

            Image {
                anchors.top: parent.top
                source: "sun1.png"
                smooth: true
            }
        }
        Item {
            id: s_dn
            width: 76
            height: 38
            anchors.bottom: parent.bottom
            clip: true

            Image {
                anchors.bottom: parent.bottom
                source: "sun2.png"
                smooth: true
            }
        }
/*
        transform:[
            Rotation {
                id: sun_a
                origin.x: 38; origin.y: 38;
                angle: sun_angle.angle * -1
            },
            Rotation {
                id: sun_angle
                origin.x: 38; origin.y: 198;
                angle: clock.seconds * 6
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }

        ]
// */
    }


    Item {
        id: moon
        x: 212
        y: 117
        width: 56
        height: 56

        Item {
            id: m_up
            width: 56
            height: 56
            anchors.top: parent.top
            clip: true
            Item {
                width: 52
                height: 52
                anchors.topMargin: 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                Luna { id: luna }
            }
        }

        Item {
            id: m_dn
            width: 56
            height: 0
            anchors.bottom: parent.bottom
            clip: true

            Image {
                anchors.bottom: parent.bottom
                source: "luna2.png"
            }
        }
    }



    Image {
        id: stick_l
        x: 41
        y: 237
        width: 159
        height: 4
        source: "stick_l.png"

        Image {
            x: -12
            y: -1
            width: 12
            height: 6
            source: "stick_end.png"
        }
    }
    Image {
        id: stick_r
        x: 281
        y: 237
        width: 158
        height: 4
        source: "stick_r.png"

        Image {
            x: 158
            y: -1
            width: 12
            height: 6
            source: "stick_end.png"
        }
    }
    Image {
        id: earth
        x: 197
        y: 198
        width: 85
        height: 83
        source: "dusk.png"
    }


    MouseArea {
        id: mousearea1
        x: 92
        y: 178
        width: 27
        height: 28
        onClicked: { }
    }
    MouseArea {
        id: mousearea2
        x: 257
        y: 323
        width: 27
        height: 28
        onClicked: {
            sun_angle.angle -= 1;
            sun_a.angle = sun_angle.angle * -1;

            if(sun_angle.angle > 75 && sun_angle.angle < 102){

            }
            if(sun_angle.angle > 255 && sun_angle.angle < 282){

            }
            console.log(sun_angle.angle)
        }
    }
    MouseArea {
        id: mousearea3
        x: 307
        y: 200
        width: 27
        height: 28
        onClicked: {
            console.log("==", sun.x, sun.y)
            sun.pr = 30 * Math.PI/180
            sun.an += sun.pr
            var radius = 160
            sun.x = other.height/2 + Math.cos(sun.an)*radius - 38
            sun.y = other.width/2  + Math.sin(sun.an)*radius - 38
            console.log(sun.x, sun.y)

        }
    }




    //*
    transform: Rotation {
        origin.x: 239
        origin.y: 239
        axis.x: 1; axis.y: 0; axis.z: 0
        angle: 180
    }
    // */
}
