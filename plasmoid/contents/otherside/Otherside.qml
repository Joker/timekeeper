import QtQuick 1.1

Item {
    id: other
    width: 478; height: 478

    Image { x: 2; y: 0; source: "bg2.png" }
    Image { source: "woodSurround.png"; rotation: 180}
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
