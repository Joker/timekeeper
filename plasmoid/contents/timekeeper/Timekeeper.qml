import QtQuick 1.1
import "../wheels"

Item {
    id: timekeeper
    width: 193; height: 131

    property string day: "31"
    property string month: "NOV"
    property string year: "54"

    Item {
        id: cogMonth
        x: 29;y: 13
        width: 84; height: 84
        Image { x: -6; y: -5; source: "../wheels/monthCogShadow.png"}
        Image { x: 1; y: 0; width: 82; height: 84; source: "../wheels/monthCog.png"}
    }
    Rectangle {
        x: 95;y: 70
        width: 36;height: 36
        radius: width*0.5
        gradient: Gradient {
            GradientStop {
                position: 0.16
                color: "#766139"
            }

            GradientStop {
                position: 0.68
                color: "#ffffff"
            }
        }
    }
    Rectangle {
        x: 95;y: 5
        width: 36;height: 36
        radius: width*0.5
        gradient: Gradient {
            GradientStop {
                position: 0.46
                color: "#b8a38b"
            }

            GradientStop {
                position: 1
                color: "#ffffff"
            }
        }
    }
    Rectangle {
        x: 50;y: 17
        width: 21;height: 76
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#766139"
            }

            GradientStop {
                position: 0.35
                color: "#ffffff"
            }

            GradientStop {
                position: 0.58
                color: "#ffffff"
            }

            GradientStop {
                position: 1
                color: "#766139"
            }
        }
        rotation: 270
    }
    Image { x: 0; y: 0; source: "timekeeper.png"
        Text {
            x: 101; y: 14
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
            x: 102; y: 78
            width: 28; height: 22
            text: year
            font.pointSize: 15
            font.family: fixedFont.name
            color: "#333333"

        }

        MouseArea {
            id: mousearea1
            x: 0
            y: 50
            width: 20
            height: 13
        }

        MouseArea {
            id: mousearea2
            x: 154
            y: 90
            width: 10
            height: 30
        }
    }
}
