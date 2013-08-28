import QtQuick 1.1

Item {
    id: timekeeper
    width: 193; height: 131

    property string day:   "31"
    property string month: "NOV"
    property string year:  "54"
    property alias cog    : cog.rotation
    property alias cog_sh : cog_sh.rotation
    property alias color  : color.extend
    property bool lock: false

    Item {
        id: cogMonth
        x: 29;y: 13
        width: 84; height: 84
        Image {
            id: cog
            x: -6; y: -5;
            source: "monthCogShadow.png"
            smooth: true;
            Behavior on rotation {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
        Image {
            id: cog_sh
            x: 1; y: 0;
            width: 82; height: 84;
            source: "monthCog.png"
            smooth: true;
            Behavior on rotation {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Rectangle {
        id: yearBackground
        x: 65;y: 70
        width: 66;height: 36
        radius: width*0.5
        gradient: Gradient {
            GradientStop {
                id: gradientstop5
                position: 0.16
                color: "#766139"
            }
            GradientStop {
                id: gradientstop6
                position: 0.68
                color: "#ffffff"
            }
        }
    }
    Rectangle {
        id: dayBackground
        x: 95;y: 5
        width: 36;height: 36
        radius: width*0.5
        gradient: Gradient {
            GradientStop {
                id: gradientstop7
                position: 0.46
                color: "#b8a38b"
            }
            GradientStop {
                id: gradientstop8
                position: 1
                color: "#ffffff"
            }
        }
    }
    Rectangle {
        id: monthBackground
        x: 50;y: 17
        width: 21;height: 76
        gradient: Gradient {
            GradientStop {
                id: gradientstop1
                position: 0
                color: "#766139"
            }
            GradientStop {
                id: gradientstop2
                position: 0.35
                color: "#ffffff"
            }
            GradientStop {
                id: gradientstop3
                position: 0.58
                color: "#ffffff"
            }
            GradientStop {
                id: gradientstop4
                position: 1
                color: "#766139"
            }
        }
        rotation: 270
    }
    Rectangle {
        id: rectangle_glass
        x: 139; y: 36
        opacity: 0.53
        visible: false
        width: 40;height: 40
        radius: width*0.5
    }

    Image { x: 0; y: 0; source: "timekeeper.png"
        Text {
            x: 102; y: 14
            width: 28; height: 22
            text: day
            font.pointSize: 15
            font.family: fixedFont.name
            color: "#333333"

        }
        Text {
            x: 25; y: 44
            width: 69; height: 19
            text: month
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 14
            font.family: fixedFont.name
            color: "#333333"

        }
        Text {
            x: 73; y: 78
            width: 58; height: 22
            text: year
            font.pointSize: 15
            font.family: fixedFont.name
            color: "#333333"

        }
    }

    states: [
        State {
            name: "out"
            PropertyChanges { target: timekeeper; x: 354;}
            PropertyChanges { target: calendar;   lock: false;}
        },
        State {
            name: "green"
            PropertyChanges { target: gradientstop1; position: 0; color: "#206f4a" }
            PropertyChanges { target: gradientstop4; position: 1; color: "#206f4a" }

            PropertyChanges { target: gradientstop5; position: 0.16; color: "#206f4a" }
            PropertyChanges { target: gradientstop7; position: 0.51; color: "#8ac0a6" }
            PropertyChanges { target: gradientstop8; position: 0.7 ; color: "#ffffff" }

            PropertyChanges { target: rectangle_glass; color: "#206f4a"; visible: true }

            PropertyChanges { target: monthBackground; opacity: 0.65 }
            PropertyChanges { target: dayBackground;   opacity: 0.65 }
            PropertyChanges { target: yearBackground;  opacity: 0.65 }
        },
        State {
            name: "purple"
            PropertyChanges { target: gradientstop1; position: 0; color: "#187c8b" }
            PropertyChanges { target: gradientstop4; position: 1; color: "#187c8b" }

            PropertyChanges { target: gradientstop5; position: 0.16; color: "#187c8b" }
            PropertyChanges { target: gradientstop7; position: 0.51; color: "#66b7c2" }
            PropertyChanges { target: gradientstop8; position: 0.68; color: "#ffffff" }

            PropertyChanges { target: rectangle_glass; color: "#187c8b"; visible: true }

            PropertyChanges { target: monthBackground; opacity: 0.65 }
            PropertyChanges { target: dayBackground;   opacity: 0.65 }
            PropertyChanges { target: yearBackground;  opacity: 0.65 }
        },
        State {
            id: color
            name: "color"
            extend: "green"
            when: count != 0
        }

    ]
    transitions: [
        Transition {
            NumberAnimation { properties: "x"; duration: 1000 }
        }
    ]
}
