import QtQuick 1.1

Image {
    property int phase: 28;
    source: "luna_" + phase + ".svg"

    sourceSize.width:  parent.width
    sourceSize.height: parent.height

    smooth: true;
}
