import QtQuick 1.1

Item {
    id: calendar
    width: 478; height: 478
    Image {
        id: iGlass
        x: 2; y: 1
        source: "innerFramesAndGlass.png"
    }
    Image {
        id: iSurround
        source: "woodSurround.png"
    }
    Image {
        id: rotatingring
        x: 16; y: 17
        clip: true
        source: "rotatingring.png"
    }

}
