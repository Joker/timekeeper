import QtQuick 1.1
import "../luna"

Item {
    id: other
    width: 478; height: 478
//rotation: 180
    Image { id: bg;       source: "bg2.png";          x: 2; y: 0; }
    Image { id: surround; source: "woodSurround.png"; rotation: 0 }

    Item {
        id: sun
        x: 201
        y: 41
        width: 76
        height: 76

        Item {
            id: s_up
            width: 76
            height: 76
            anchors.top: parent.top
            clip: true

            Image {
                anchors.top: parent.top
                source: "sun1.png"
            }
        }

        Item {
            id: s_dn
            width: 76
            height: 0
            anchors.bottom: parent.bottom
            clip: true

            Image {
                anchors.bottom: parent.bottom
                source: "sun2.png"
            }
        }

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
                source: "moon1.png"
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
}
