import QtQuick 1.1

Item {
    id: other
    width: 478; height: 478
//rotation: 180
    Image { id: bg;       source: "bg2.png";          x: 2; y: 0; }
    Image { id: surround; source: "woodSurround.png"; rotation: 0 }

    Item {
        id: sun
        x: 322
        y: 200
        width: 76
        height: 76

        Item {
            id: s_up
            width: 76
            height: 40
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
            height: 37
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
        x: 93
        y: 212
        width: 56
        height: 56

        Item {
            id: m_up
            width: 56
            height: 28
            anchors.top: parent.top
            clip: true
            Image {
                anchors.top: parent.top
                source: "m0.png"
            }
        }

        Item {
            id: m_dn
            width: 56
            height: 28
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
