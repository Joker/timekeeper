import QtQuick 1.1



Item {
    id: luna
    width: 152; height: 152

    property string svg_sourse: "luna-gskbyte13.svg"
    property double degree: 0
    property int    phase: 29
    property int    home_degree: 0

    Item {
        x: 34; y: 34
        width: 84; height: 84
        Image { x: 1; y: 1; smooth: true; source: "earthUnderShadow.png"}
        Image { x: 8; y: 8; smooth: true; source: "earth.png"}
    }
    Item {
        id: moon
        x: 60; y: 0
        width: 33; height: 33
        Image { x: -6; y: -6; smooth: true; source: "moonUnderShadow.png"}
        Image {
            width: 33; height: 33
            source: luna.svg_sourse
            sourceSize.width: parent.width
            sourceSize.height: parent.height
             smooth: true;
        }
        transform: Rotation {
            id: minuteRotation
            origin.x: 17.5; origin.y: 76;
            angle: degree
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    transform: Rotation {
        origin.x: 76.5; origin.y: 152;
        angle:home_degree
        Behavior on angle {
            SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
        }
    }
}
