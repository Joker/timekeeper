import QtQuick 1.1
 import org.kde.plasma.components 0.1 as PlasmaComponents

Item {
    width: 200
    height: 150

    Image {
        id: image1
        source: "background.png"

        MouseArea {
            x: 36
            y: 28
            width: 136
            height: 29
        }

        PlasmaComponents.TextField {
//        TextInput{
            id: font_path
            x: 36
            y: 30
            width: 136
            height: 21

            font.pixelSize: 12
        }
        Text {
            id: text3
            x: 39
            y: 32
            width: 130
            height: 19
            text: qsTr("absolut font path")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }

        PlasmaComponents.TextField {
//        TextInput{
            id: week_size
            x: 73
            y: 62
            width: 27
            height: 20
            text: qsTr("11")

            font.pixelSize: 12
            maximumLength: 2
        }
        Text {
            id: text1
            x: 39
            y: 66
            text: qsTr("week")

            font.pixelSize: 12
        }

         PlasmaComponents.TextField {
//        TextInput{
            id: month_size
            x: 145
            y: 62
            width: 27
            height: 20
            text: qsTr("14")


            font.pixelSize: 12
            maximumLength: 2
         }

         Text {
             id: text2
             x: 103
             y: 66
             text: qsTr("month")
             font.pointSize: 10
             font.pixelSize: 12
         }

        Image {
            id: image2
            x: 33
            y: 96
            width: 67
            height: 37
            source: "okb.png"

            MouseArea {
                x: 4
                y: 3
                width: 56
                height: 25
            }
        }

        Image {
            id: image3
            x: 162
            y: 105
            source: "cancel.png"

            MouseArea {
                x: 0
                y: 0
                width: 22
                height: 21
            }
        }


    }
}

