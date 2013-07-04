import QtQuick 1.1

Item {
    id: other
    width: 478; height: 478
//rotation: 180
    Image { id: bg; x: 2; y: 0; source: "bg2.png" }
    Image { id: surround; source: "woodSurround.png"; rotation: 0}

    Image {
        id: moon_iron
        x: 318
        y: 296
        source: "moon1.png"
    }

    Image {
        id: sun_iron
        x: 105
        y: 296
        source: "sun2.png"
    }

    Image {
        id: moon
        x: 105
        y: 176
        source: "m0.png"
    }

    Image {
        id: sun
        x: 296
        y: 71
        source: "sun1.png"
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
/*
    Image {
        id:ring
        x: 16; y: 18
        source: "rotatingring.png"
        smooth: true
        rotation: 122
    }
// */
}
