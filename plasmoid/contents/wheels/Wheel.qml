import QtQuick 1.1

Item {
    Item {
        id: cogSecond
        x: 39
        y: -11
        width: 103; height: 103
        Image { x: 6; y: 17; source: "cogShadow.png"}
        Image { x: 11; y: 10; width: 82; height: 84; source: "cog.png"}
    }

    id: well
    width: 132; height: 93
    Image { x: 3; y: 1;  source: "wheelShadow.png"}
    Image { source: "wheel.png"}
    Image { x: 26; y: 2; source: "driveBand.png"}
}
